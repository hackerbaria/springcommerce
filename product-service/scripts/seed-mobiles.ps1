param(
    [ValidateRange(1, 100000)]
    [int]$Count = 1000,
    [string]$Container = 'mongodb',
    [string]$Database = 'product-service',
    [string]$MongoUri = $env:SPRINGCOMMERCE_MONGO_URI,
    [switch]$GenerateOnly
)

$ErrorActionPreference = 'Stop'
# Windows PowerShell 5.1 needs TLS 1.2 for the catalog/CDN.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (-not $MongoUri) {
    $MongoUri = 'mongodb://root:password@localhost:27017/?authSource=admin'
}

function Get-VerifiedImage([string]$Url) {
    if (-not $Url.StartsWith('https://cdn.dummyjson.com/')) {
        throw "Unexpected image host: $Url"
    }
    $client = New-Object System.Net.WebClient
    try {
        $bytes = $client.DownloadData($Url)
        $contentType = $client.ResponseHeaders['Content-Type']
        # These source images are WebP. Reject HTML error pages and empty bodies.
        if ($contentType -notlike 'image/*' -or $bytes.Length -lt 12 -or
            [Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne 'RIFF' -or
            [Text.Encoding]::ASCII.GetString($bytes, 8, 4) -ne 'WEBP') {
            throw "URL did not return a WebP image: $Url"
        }
        return $Url
    }
    finally { $client.Dispose() }
}

$catalog = Invoke-RestMethod 'https://dummyjson.com/products/category/smartphones?limit=0' -TimeoutSec 30
$phones = @($catalog.products | Sort-Object id)
if ($phones.Count -eq 0) { throw 'The smartphone catalog is empty.' }
if (-not ($phones | Where-Object brand -eq 'Apple') -or
    -not ($phones | Where-Object brand -ne 'Apple')) {
    throw 'Expected both Apple and Android phones in the catalog.'
}

$images = @{}
foreach ($phone in $phones) {
    Write-Host "Checking image: $($phone.title)"
    $images[$phone.id] = Get-VerifiedImage $phone.images[0]
}

$random = New-Object Random 42
$now = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$products = @(for ($i = 0; $i -lt $Count; $i++) {
    $phone = $phones[$i % $phones.Count]
    $lot = [int][Math]::Floor($i / $phones.Count) + 1
    $quantity = $random.Next(10, 201)
    $price = ([decimal]$phone.price).ToString('0.00', [Globalization.CultureInfo]::InvariantCulture)
    [ordered]@{
        _id = ('seed-mobile-{0:D6}' -f ($i + 1))
        name = "$($phone.title) - Demo lot $lot"
        description = "Demo listing for $($phone.title) by $($phone.brand). Sample lot $lot; price and stock are synthetic test data. Image shows the base model."
        price = @{ '$numberDecimal' = $price }
        brand = $phone.brand
        image = $images[$phone.id]
        maxQuantity = [Math]::Min(5, $quantity)
        quantity = $quantity
        dateAdded = @{ '$numberLong' = ([long]($now - ($i * 60000L))).ToString() }
    }
})

$outputDirectory = Join-Path $PSScriptRoot '../data/mobile-seed'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$jsonPath = Join-Path $outputDirectory 'products.json'
$scriptPath = Join-Path $outputDirectory 'insert-mobiles.js'
$json = ConvertTo-Json -InputObject $products -Depth 8 -Compress
$jsonLiteral = ConvertTo-Json -InputObject $json -Compress
$databaseLiteral = ConvertTo-Json -InputObject $Database -Compress
$mongoScript = @"
const products = EJSON.parse($jsonLiteral, { relaxed: false });
const collection = db.getSiblingDB($databaseLiteral).getCollection('product');
const result = collection.bulkWrite(products.map(product => ({
    updateOne: {
        filter: { _id: product._id },
        update: { `$setOnInsert: product },
        upsert: true
    }
})), { ordered: false });
printjson({ requested: products.length, inserted: result.upsertedCount, existing: result.matchedCount });
"@
$utf8 = New-Object Text.UTF8Encoding $false
[IO.File]::WriteAllText($jsonPath, $json, $utf8)
[IO.File]::WriteAllText($scriptPath, $mongoScript, $utf8)
Write-Host "Generated $Count products from $($phones.Count) models; verified $($images.Count) image URLs."
Write-Host "Files: $outputDirectory"
if ($GenerateOnly) { return }

# Execute a real UTF-8 file; large scripts can be truncated when read from stdin.
$containerScript = '/tmp/springcommerce-mobile-seed-' + [Guid]::NewGuid().ToString('N') + '.js'
& docker cp ([IO.Path]::GetFullPath($scriptPath)) "${Container}:$containerScript"
if ($LASTEXITCODE -ne 0) { throw "Could not copy seed script to container '$Container'. Check that it is running." }
try {
    & docker exec $Container mongosh $MongoUri --quiet --file $containerScript
    if ($LASTEXITCODE -ne 0) { throw "MongoDB import failed (exit code $LASTEXITCODE). See the mongosh error above." }
}
finally {
    & docker exec $Container rm -f -- $containerScript
    if ($LASTEXITCODE -ne 0) { Write-Warning "Could not remove temporary file $containerScript in container '$Container'." }
}
