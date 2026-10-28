package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/TobiasMolinero/personal_finances/internal/repositories"
	"github.com/TobiasMolinero/personal_finances/internal/services"
)

type AccountHandler struct {
	service *services.AccountService
}

func NewAccountHandler(service *services.AccountService) *AccountHandler {
	return &AccountHandler {
		service: service,
	}
}

func (h *AccountHandler) Create(w http.ResponseWriter, r *http.Request) {
	var account repositories.Account

	if err := json.NewDecoder(r.Body).Decode(&account); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	account.IsActive = true

	id, err := h.service.Create(account)
	if err != nil {
		http.Error(w, "Could not create account", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)

	if err := json.NewEncoder(w).Encode(map[string]int64{
		"id": id,
	}); err != nil {
		return
	}
}