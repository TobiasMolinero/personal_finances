-- =========================================================
-- ENUMS
-- =========================================================

CREATE TYPE transaction_type_code AS ENUM (
    'INCOME',
    'EXPENSE',
    'TRANSFER'
);


-- =========================================================
-- ACCOUNTS
-- =========================================================

CREATE TABLE accounts (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name            VARCHAR(100) NOT NULL UNIQUE,
    initial_balance NUMERIC(15, 2) NOT NULL DEFAULT 0,
    currency        CHAR(3) NOT NULL DEFAULT 'ARS',
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT accounts_currency_length
        CHECK (char_length(currency) = 3)
);


-- =========================================================
-- TRANSACTION TYPES
-- =========================================================

CREATE TABLE transaction_types (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code        transaction_type_code NOT NULL UNIQUE,
    name        VARCHAR(50) NOT NULL UNIQUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- CATEGORIES
-- =========================================================

CREATE TABLE categories (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    transaction_type_id BIGINT NOT NULL,
    parent_category_id  BIGINT NULL,
    is_active            BOOLEAN NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categories_transaction_type
        FOREIGN KEY (transaction_type_id)
        REFERENCES transaction_types(id),

    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_category_id)
        REFERENCES categories(id),

    CONSTRAINT categories_name_unique
        UNIQUE (name)
);


-- =========================================================
-- TRANSACTIONS
-- =========================================================

CREATE TABLE transactions (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_type_id BIGINT NOT NULL,
    source_account_id   BIGINT NULL,
    destination_account_id BIGINT NULL,
    category_id         BIGINT NULL,
    amount              NUMERIC(15, 2) NOT NULL,
    transaction_date    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description         VARCHAR(255) NULL,
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_type
        FOREIGN KEY (transaction_type_id)
        REFERENCES transaction_types(id),

    CONSTRAINT fk_transactions_source_account
        FOREIGN KEY (source_account_id)
        REFERENCES accounts(id),

    CONSTRAINT fk_transactions_destination_account
        FOREIGN KEY (destination_account_id)
        REFERENCES accounts(id),

    CONSTRAINT fk_transactions_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT transactions_amount_positive
        CHECK (amount > 0),

    CONSTRAINT transactions_different_accounts
        CHECK (
            source_account_id IS NULL
            OR destination_account_id IS NULL
            OR source_account_id <> destination_account_id
        )
);

INSERT INTO transaction_types (code, name)
VALUES
    ('INCOME', 'Income'),
    ('EXPENSE', 'Expense'),
    ('TRANSFER', 'Transfer');

INSERT INTO categories (name, transaction_type_id)
VALUES
    ('Salary',       (SELECT id FROM transaction_types WHERE code = 'INCOME')),
    ('Positive Interest', (SELECT id FROM transaction_types WHERE code = 'INCOME')),
    ('Food',         (SELECT id FROM transaction_types WHERE code = 'EXPENSE')),
    ('Rent',         (SELECT id FROM transaction_types WHERE code = 'EXPENSE')),
    ('Transportation', (SELECT id FROM transaction_types WHERE code = 'EXPENSE'));