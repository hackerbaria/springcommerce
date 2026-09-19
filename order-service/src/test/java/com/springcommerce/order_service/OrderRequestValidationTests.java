package com.springcommerce.order_service;

import com.springcommerce.order_service.controller.OrderController;
import com.springcommerce.order_service.service.OrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class OrderRequestValidationTests {
    private OrderService orderService;
    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        orderService = mock(OrderService.class);
        mockMvc = MockMvcBuilders.standaloneSetup(new OrderController(orderService)).build();
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "{}",
            "{\"userDetails\":null}",
            "{\"userDetails\":{}}",
            "{\"userDetails\":{\"email\":\"\"}}",
            "{\"userDetails\":{\"email\":\"invalid\"}}"
    })
    void rejectsMissingCustomerDetailsOrInvalidEmailBeforeCallingService(String body) throws Exception {
        mockMvc.perform(post("/api/order").contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isBadRequest());
        verifyNoInteractions(orderService);
    }

    @Test
    void acceptsOrderWithCustomerDetails() throws Exception {
        mockMvc.perform(post("/api/order").contentType(MediaType.APPLICATION_JSON).content("""
                {
                    "skuCode": "iphone_15",
                    "price": 999.09,
                    "quantity": 1,
                    "userDetails": {
                        "email": "customer@example.com",
                        "firstName": "Test",
                        "lastName": "Customer"
                    }
                }
                """))
                .andExpect(status().isCreated());
        verify(orderService).placeOrder(any());
    }
}
