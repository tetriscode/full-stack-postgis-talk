createdb fullstack -O fullstack -h localhost -U postgres
psql -U fullstack -d fullstack -c "CREATE SCHEMA IF NOT EXISTS fullstack" -h localhost

