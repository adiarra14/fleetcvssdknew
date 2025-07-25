package com.maxvision.demo.service;

import com.maxvision.edge.gateway.sdk.report.LockReportService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class LockReportServiceImpl implements LockReportService {
    
    @Override
    public void reportLockMsg(String jsonStr) {
        log.info("Received lock report message: {}", jsonStr);
        // TODO: Implement your business logic here to handle the lock report
    }
} 