# Mobile product seed

From the repository root, with the project's MongoDB Docker container running:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./product-service/scripts/seed-mobiles.ps1
```

Defaults: 1,000 documents, container `mongodb`, database `product-service`, collection
`product`, and the development MongoDB credentials in `docker-compose.yml`.
Set `SPRINGCOMMERCE_MONGO_URI` to override the connection URI (it is interpreted
inside the container). `-Container`, `-Database`, and `-Count` are configurable.

To generate and check images without writing to MongoDB:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./product-service/scripts/seed-mobiles.ps1 -GenerateOnly
```

Generated Extended JSON and a standalone mongosh insertion script are written to
`product-service/data/mobile-seed/` (gitignored). Requires PowerShell 5.1 or newer,
internet access, and Docker for insertion. No Python or extra packages needed.

The script uses the [DummyJSON smartphone catalog](https://dummyjson.com/products/category/smartphones).
It repeats base models as uniquely named **demo lots**, not 1,000 distinct real
phone models. Prices are sample USD values, stock is synthetic, and `maxQuantity`
is assumed to mean the purchase limit per order. Images match the base models.
Each image is downloaded and checked for an image content type and WebP signature
before any database write. The stored HTTPS URLs can be used directly in an HTML
`img` element; future CDN availability is outside the script's control.

MongoDB `_id` maps to Java `id`. Prices use Decimal128, dates use BSON Int64 epoch
milliseconds, and quantities use integers. Stable `seed-mobile-000001` IDs and
`$setOnInsert` make repeat runs safe: existing products are preserved. Increasing
`-Count` adds missing seed IDs; decreasing it does not delete prior records.
