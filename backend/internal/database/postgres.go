package database

import (
	"fmt"
	"database/sql"
	_ "github.com/lib/pq"
	"github.com/TobiasMolinero/personal_finances/internal/config"
)

func Connect(cfg config.Config) (*sql.DB, error) {
	connectionString := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=%s",
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	db, err := sql.Open("postgres", connectionString)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	return db, nil
}