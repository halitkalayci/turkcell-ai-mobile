package com.turkcell.aimobile.infrastructure.config;

import com.turkcell.aimobile.application.ProductApplicationService;
import com.turkcell.aimobile.domain.port.ProductRepositoryPort;
import com.turkcell.aimobile.domain.service.ProductDomainService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class BeanConfig {

    @Bean
    public ProductDomainService productDomainService(ProductRepositoryPort repositoryPort) {
        return new ProductDomainService(repositoryPort);
    }

    @Bean
    public ProductApplicationService productApplicationService(ProductRepositoryPort repositoryPort,
                                                               ProductDomainService domainService) {
        return new ProductApplicationService(repositoryPort, domainService);
    }
}
