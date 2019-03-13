createdb fullstack -O fullstack -h localhost -U postgres
psql -U postgres -d signal -c "CREATE EXTENSION IF NOT EXISTS postgis" -h localhost
psql -U fullstack -d fullstack -c "CREATE SCHEMA IF NOT EXISTS fullstack" -h localhost


