package main

import (
	"log"
	"net/http"
	"github.com/TobiasMolinero/personal_finances/internal/config"
	"github.com/TobiasMolinero/personal_finances/internal/database"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env");
	}

	cfg := config.Load();

	db, err := database.Connect(cfg);
	if err != nil {
		log.Fatal(err);
	}
	defer db.Close();

	log.Println("Database connected succesfully");

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Personal Finances API"))
	})

	log.Println("Server running on http://localhost:8080");

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err);
	}
}