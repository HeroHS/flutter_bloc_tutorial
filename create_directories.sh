#!/bin/bash
# Clean Architecture Setup Script for Git Bash / WSL

echo "Creating Clean Architecture Directory Structure..."
echo ""

cd lib || exit

# Core layer
mkdir -p core/error
mkdir -p core/usecases

# User feature
mkdir -p features/user/domain/entities
mkdir -p features/user/domain/repositories
mkdir -p features/user/domain/usecases
mkdir -p features/user/data/datasources
mkdir -p features/user/data/models
mkdir -p features/user/data/repositories
mkdir -p features/user/presentation/bloc
mkdir -p features/user/presentation/screens

# Post feature
mkdir -p features/post/domain/entities
mkdir -p features/post/domain/repositories
mkdir -p features/post/domain/usecases
mkdir -p features/post/data/datasources
mkdir -p features/post/data/models
mkdir -p features/post/data/repositories
mkdir -p features/post/presentation/cubit
mkdir -p features/post/presentation/screens

# Product feature
mkdir -p features/product/domain/entities
mkdir -p features/product/domain/repositories
mkdir -p features/product/domain/usecases
mkdir -p features/product/data/datasources
mkdir -p features/product/data/models
mkdir -p features/product/data/repositories
mkdir -p features/product/presentation/bloc
mkdir -p features/product/presentation/screens

cd ..

echo ""
echo "================================================================================"
echo "Directory structure created successfully!"
echo "================================================================================"
echo ""
echo "Next: All the Clean Architecture files will be created automatically"
echo ""
