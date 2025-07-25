package com.maxvision.demo.config;

import com.maxvision.edge.gateway.sdk.config.LockSdkConfig;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MaxvisionConfig {

    @Bean(initMethod = "init")
    public LockSdkConfig lockSdkConfig() {
        return new LockSdkConfig();
    }
} 