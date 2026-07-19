package config

import (
	"strings"

	"github.com/spf13/viper"
)

// Config stores all configuration of the application.
type Config struct {
	ServerPort         string   `mapstructure:"PORT"`
	MongoURI           string   `mapstructure:"MONGO_URI"`
	DBName             string   `mapstructure:"DB_NAME"`
	JWTSecretKey       string   `mapstructure:"JWT_SECRET_KEY"`
	JWTExpirationHours int      `mapstructure:"JWT_EXPIRATION_HOURS"`
	EnableCache        bool     `mapstructure:"ENABLE_CACHE"`
	RedisAddr          string   `mapstructure:"REDIS_ADDR"`
	RedisPassword      string   `mapstructure:"REDIS_PASSWORD"`
	LogLevel           string   `mapstructure:"LOG_LEVEL"`
	LogFormat          string   `mapstructure:"LOG_FORMAT"`
	CookieDomains      []string `mapstructure:"COOKIE_DOMAINS"`
	SecureCookie       bool     `mapstructure:"SECURE_COOKIE"`
	AllowedOrigins     []string `mapstructure:"ALLOWED_ORIGINS"`
}

// LoadConfig reads configuration from file and environment variables.
func LoadConfig(path string) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName(".env")
	viper.SetConfigType("env")

	// Read environment variables
	viper.AutomaticEnv()
	viper.BindEnv("PORT")
	viper.BindEnv("MONGO_URI")
	viper.BindEnv("DB_NAME")
	viper.BindEnv("JWT_SECRET_KEY")
	viper.BindEnv("JWT_EXPIRATION_HOURS")
	viper.BindEnv("ENABLE_CACHE")
	viper.BindEnv("REDIS_ADDR")
	viper.BindEnv("REDIS_PASSWORD")
	viper.BindEnv("LOG_LEVEL")
	viper.BindEnv("LOG_FORMAT")
	// Default values
	viper.SetDefault("PORT", "8080")
	viper.SetDefault("ENABLE_CACHE", false)
	viper.SetDefault("JWT_EXPIRATION_HOURS", 72)
	viper.SetDefault("COOKIE_DOMAINS", []string{"localhost"})
	viper.SetDefault("SECURE_COOKIE", false)
	viper.SetDefault("ALLOWED_ORIGINS", []string{"http://localhost:5173"})

	// Read .env if it exists.
	// If it doesn't exist, continue using environment variables.
	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			return config, err
		}
	}

	err = viper.Unmarshal(&config)
	if err != nil {
		return config, err
	}
	config.ServerPort = viper.GetString("PORT")

	config.MongoURI = viper.GetString("MONGO_URI")
	config.DBName = viper.GetString("DB_NAME")

	config.JWTSecretKey = viper.GetString("JWT_SECRET_KEY")
	config.JWTExpirationHours = viper.GetInt("JWT_EXPIRATION_HOURS")

	config.EnableCache = viper.GetBool("ENABLE_CACHE")

	config.RedisAddr = viper.GetString("REDIS_ADDR")
	config.RedisPassword = viper.GetString("REDIS_PASSWORD")

	config.LogLevel = viper.GetString("LOG_LEVEL")
	config.LogFormat = viper.GetString("LOG_FORMAT")

	config.SecureCookie = viper.GetBool("SECURE_COOKIE")

	// Handle comma-separated slices
	if allowedOrigins := viper.GetString("ALLOWED_ORIGINS"); allowedOrigins != "" {
		parts := strings.Split(allowedOrigins, ",")
		var cleaned []string
		for _, p := range parts {
			trimmed := strings.TrimSpace(p)
			trimmed = strings.Trim(trimmed, "\"'")
			if trimmed != "" {
				cleaned = append(cleaned, trimmed)
			}
		}
		config.AllowedOrigins = cleaned
	}

	if cookieDomains := viper.GetString("COOKIE_DOMAINS"); cookieDomains != "" {
		parts := strings.Split(cookieDomains, ",")
		var cleaned []string
		for _, p := range parts {
			trimmed := strings.TrimSpace(p)
			trimmed = strings.Trim(trimmed, "\"'")
			if trimmed != "" {
				cleaned = append(cleaned, trimmed)
			}
		}
		config.CookieDomains = cleaned
	}

	return
}