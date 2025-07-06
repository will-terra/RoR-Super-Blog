#!/usr/bin/env bash

# Exit on error
set -o errexit

echo "🔍 Starting build process..."
echo "🔍 Environment variables check:"
echo "DATABASE_URL: ${DATABASE_URL:-'NOT SET'}"
echo "RAILS_ENV: ${RAILS_ENV:-'NOT SET'}"
echo "ROR_SUPER_BLOG_DATABASE_PASSWORD: ${ROR_SUPER_BLOG_DATABASE_PASSWORD:-'NOT SET'}"

echo "🔍 All environment variables containing 'DATA', 'DB', or 'POSTGRES':"
env | grep -E -i '(data|db|postgres)' || echo "No relevant database environment variables found"

echo "🔍 PostgreSQL related processes:"
ps aux | grep -i postgres || echo "No PostgreSQL processes found"

bundle install
bin/rails assets:precompile
bin/rails assets:clean

