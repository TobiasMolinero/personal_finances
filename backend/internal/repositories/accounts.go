package repositories

import (
	"database/sql"
	"time"
)

type AccountRepository struct {
	db *sql.DB
}

type Account struct {
	ID int64
	Name string
	InitialBalance float64
	Currency string
	IsActive bool
	CreatedAt time.Time
	UpdatedAt time.Time
}

func NewAccountRepository(db *sql.DB) *AccountRepository {
	return &AccountRepository{
		db: db,
	}
}

func (r *AccountRepository) create(account Account) (int64, error) {
	var id int64

	query := `
		INSERT INTO accounts(
			name,
			initial_balance,
			currency,
			is_active
		)
		VALUES ($1, $2, $3, $4)
		RETURNING id
	`

	err := r.db.QueryRow(
		query,
		account.Name,
		account.InitialBalance,
		account.Currency,
		account.IsActive,
	).Scan(&id)

	if err != nil {
		return 0, err
	}

	return id, nil
}