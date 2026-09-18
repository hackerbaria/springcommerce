package com.springcommerce.order_service.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record OrderRequest(Long id, String orderNumber, String skuCode, BigDecimal price, Integer quantity,
                           @NotNull @Valid UserDetails userDetails) {
    public record UserDetails(@NotBlank @Email String email, String firstName, String lastName) {}
}
