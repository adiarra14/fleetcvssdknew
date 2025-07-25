-- Locks table to store lock device information
CREATE TABLE locks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_code VARCHAR(50) NOT NULL UNIQUE,
    device_mode INT DEFAULT 0,
    gps_interval INT DEFAULT 60,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    last_connection TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Cards table to store seal card information
CREATE TABLE cards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    card_no VARCHAR(50) NOT NULL UNIQUE,
    card_type INT NOT NULL,
    is_bound BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Lock_cards table for mapping between locks and cards
CREATE TABLE lock_cards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    card_id BIGINT NOT NULL,
    binding_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (lock_id) REFERENCES locks(id),
    FOREIGN KEY (card_id) REFERENCES cards(id),
    UNIQUE KEY unique_lock_card (lock_id, card_id)
);

-- SMS VIP settings table
CREATE TABLE sms_vip_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    index_number INT NOT NULL,
    push_alarm BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id),
    UNIQUE KEY unique_lock_phone (lock_id, phone_number)
);

-- GPS locations table
CREATE TABLE gps_locations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    altitude DECIMAL(10, 2),
    accuracy FLOAT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id)
);

-- Lock commands history
CREATE TABLE lock_commands (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    command_type VARCHAR(50) NOT NULL,
    command_log_id VARCHAR(100) NOT NULL,
    parameters TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id)
);

-- Lock events table
CREATE TABLE lock_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id)
);

-- Create indexes
CREATE INDEX idx_lock_code ON locks(lock_code);
CREATE INDEX idx_card_no ON cards(card_no);
CREATE INDEX idx_lock_commands_log_id ON lock_commands(command_log_id);
CREATE INDEX idx_gps_locations_timestamp ON gps_locations(timestamp);
CREATE INDEX idx_lock_events_type ON lock_events(event_type); 