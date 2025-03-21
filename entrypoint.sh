#!/bin/sh
set -e

echo "Generating Prisma client..."
yarn run prisma:generate || { echo "Prisma generate failed"; exit 1; }

echo -e "\n===========================\n"
echo "Run Prisma DB migrations..."
yarn prisma migrate deploy || { echo "prisam DB migration failed"; exit 1; }

echo -e "\n===========================\n"
echo "Generating Prisma SQL..."
yarn run prisma:generate-sql || { echo "Prisma SQL generation failed"; exit 1; }

echo -e "\n===========================\n"
echo "Building application..."
yarn build || { echo "Build failed"; exit 1; }

# Ensure the built file exists
if [ ! -f dist/main.js ]; then
  echo "Error: dist/main.js not found!"
  exit 1
fi

echo -e "\n===========================\n"
echo "Starting application..."
exec node dist/main.js
