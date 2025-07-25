-- Locks table to store lock device information
CREATE TABLE locks (
    id BIGSERIAL PRIMARY KEY,
    lock_code VARCHAR(50) NOT NULL UNIQUE,
    device_mode INT DEFAULT 0,
    gps_interval INT DEFAULT 60,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    last_connection TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cards table to store seal card information
CREATE TABLE cards (
    id BIGSERIAL PRIMARY KEY,
    card_no VARCHAR(50) NOT NULL UNIQUE,
    card_type INT NOT NULL,
    is_bound BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Lock_cards table for mapping between locks and cards
CREATE TABLE lock_cards (
    id BIGSERIAL PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    card_id BIGINT NOT NULL,
    binding_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (lock_id) REFERENCES locks(id),
    FOREIGN KEY (card_id) REFERENCES cards(id),
    CONSTRAINT maxv_unique_lock_card UNIQUE (lock_id, card_id)
);

-- SMS VIP settings table
CREATE TABLE sms_vip_settings (
    id BIGSERIAL PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    index_number INT NOT NULL,
    push_alarm BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id),
    CONSTRAINT maxv_unique_lock_phone UNIQUE (lock_id, phone_number)
);

-- GPS locations table
CREATE TABLE gps_locations (
    id BIGSERIAL PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    altitude DECIMAL(10, 2),
    accuracy REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id)
);

-- Lock commands history
CREATE TABLE lock_commands (
    id BIGSERIAL PRIMARY KEY,
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
    id BIGSERIAL PRIMARY KEY,
    lock_id BIGINT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lock_id) REFERENCES locks(id)
);

-- Create indexes with maxv- prefix
CREATE INDEX maxv_idx_lock_code ON locks(lock_code);
CREATE INDEX maxv_idx_card_no ON cards(card_no);
CREATE INDEX maxv_idx_lock_commands_log_id ON lock_commands(command_log_id);
CREATE INDEX maxv_idx_gps_locations_timestamp ON gps_locations(timestamp);
CREATE INDEX maxv_idx_lock_events_type ON lock_events(event_type);

-- Create triggers for automatic updated_at timestamps
CREATE OR REPLACE FUNCTION maxv_update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER maxv_update_locks_updated_at
    BEFORE UPDATE ON locks
    FOR EACH ROW
    EXECUTE FUNCTION maxv_update_updated_at_column();

CREATE TRIGGER maxv_update_cards_updated_at
    BEFORE UPDATE ON cards
    FOR EACH ROW
    EXECUTE FUNCTION maxv_update_updated_at_column();

CREATE TRIGGER maxv_update_sms_vip_settings_updated_at
    BEFORE UPDATE ON sms_vip_settings
    FOR EACH ROW
    EXECUTE FUNCTION maxv_update_updated_at_column(); 