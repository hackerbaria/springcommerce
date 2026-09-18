package com.springcommerce.product_service.service;

import com.springcommerce.product_service.dto.ProductRequest;
import com.springcommerce.product_service.dto.ProductResponse;
import com.springcommerce.product_service.model.Product;
import com.springcommerce.product_service.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService {
    private final ProductRepository productRepository;

    public ProductResponse createProduct(ProductRequest productRequest){
        Product product = Product.builder()
                .name(productRequest.name())
                .description(productRequest.description())
                .price(productRequest.price())
                .brand(productRequest.brand())
                .image(productRequest.image())
                .maxQuantity(productRequest.maxQuantity())
                .quantity(productRequest.quantity())
                .dateAdded(productRequest.dateAdded())
                .build();
        productRepository.save(product);
        log.info("Product created successfully");
        return toResponse(product);
    }

    public List<ProductResponse> getAllProducts() {
        return productRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private ProductResponse toResponse(Product product) {
        return new ProductResponse(product.getId(), product.getName(), product.getDescription(), product.getPrice(),
                product.getBrand(), product.getImage(), product.getMaxQuantity(), product.getQuantity(), product.getDateAdded());
    }
}
