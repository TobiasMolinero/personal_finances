package services

import "github.com/TobiasMolinero/personal_finances/internal/repositories"

type AccountService struct {
	repository *repositories.AccountRepository
}

func NewAccountService(
	repository *repositories.AccountRepository,
) *AccountService {	
	return &AccountService {
		repository: repository,
	}
}

func (s *AccountService) Create(account repositories.Account) (int64, error) {

	// Reglas de negocio...

	return s.repository.Create(account);
}