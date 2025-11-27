# Flutter BLoC Tutorial - Clean Architecture Restructuring

## Prerequisites

This project has been restructured to follow Clean Architecture principles. Before using the restructured code, you need to create the directory structure.

## Step 1: Create Directory Structure

### Option A: Windows Command Prompt
Open Command Prompt in the project root and run:
```batch
create_directories.bat
```

### Option B: Manual PowerShell
```powershell
cd d:\flutter_projects\flutter_bloc_tutorial\lib
New-Item -ItemType Directory -Force -Path "core\error"
New-Item -ItemType Directory -Force -Path "core\usecases"
New-Item -ItemType Directory -Force -Path "features\user\domain\entities"
New-Item -ItemType Directory -Force -Path "features\user\domain\repositories"
New-Item -ItemType Directory -Force -Path "features\user\domain\usecases"
New-Item -ItemType Directory -Force -Path "features\user\data\datasources"
New-Item -ItemType Directory -Force -Path "features\user\data\models"
New-Item -ItemType Directory -Force -Path "features\user\data\repositories"
New-Item -ItemType Directory -Force -Path "features\user\presentation\bloc"
New-Item -ItemType Directory -Force -Path "features\user\presentation\screens"
New-Item -ItemType Directory -Force -Path "features\post\domain\entities"
New-Item -ItemType Directory -Force -Path "features\post\domain\repositories"
New-Item -ItemType Directory -Force -Path "features\post\domain\usecases"
New-Item -ItemType Directory -Force -Path "features\post\data\datasources"
New-Item -ItemType Directory -Force -Path "features\post\data\models"
New-Item -ItemType Directory -Force -Path "features\post\data\repositories"
New-Item -ItemType Directory -Force -Path "features\post\presentation\cubit"
New-Item -ItemType Directory -Force -Path "features\post\presentation\screens"
New-Item -ItemType Directory -Force -Path "features\product\domain\entities"
New-Item -ItemType Directory -Force -Path "features\product\domain\repositories"
New-Item -ItemType Directory -Force -Path "features\product\domain\usecases"
New-Item -ItemType Directory -Force -Path "features\product\data\datasources"
New-Item -ItemType Directory -Force -Path "features\product\data\models"
New-Item -ItemType Directory -Force -Path "features\product\data\repositories"
New-Item -ItemType Directory -Force -Path "features\product\presentation\bloc"
New-Item -ItemType Directory -Force -Path "features\product\presentation\screens"
cd ..
```

### Option C: Git Bash / Unix-like Shell
```bash
cd lib
mkdir -p core/{error,usecases}
mkdir -p features/user/domain/{entities,repositories,usecases}
mkdir -p features/user/data/{datasources,models,repositories}
mkdir -p features/user/presentation/{bloc,screens}
mkdir -p features/post/domain/{entities,repositories,usecases}
mkdir -p features/post/data/{datasources,models,repositories}
mkdir -p features/post/presentation/{cubit,screens}
mkdir -p features/product/domain/{entities,repositories,usecases}
mkdir -p features/product/data/{datasources,models,repositories}
mkdir -p features/product/presentation/{bloc,screens}
cd ..
```

## Step 2: Understand the New Structure

The project now follows Clean Architecture with three distinct layers:

### Core Layer (Shared Utilities)
```
lib/core/
├── error/
│   └── failures.dart          # Error handling
└── usecases/
    └── usecase.dart           # Base use case class
```

### Feature-Based Organization

Each feature (User, Post, Product) follows the same structure:

```
lib/features/{feature_name}/
├── domain/                     # Business Logic Layer (No dependencies)
│   ├── entities/              # Business models
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business operations
├── data/                       # Data Layer (Depends on domain)
│   ├── datasources/           # API/Database access
│   ├── models/                # Data transfer objects
│   └── repositories/          # Repository implementations
└── presentation/               # UI Layer (Depends on domain)
    ├── bloc/ or cubit/        # State management
    └── screens/               # UI screens
```

## Step 3: Key Changes

### Dependency Flow
```
Presentation Layer → Use Cases → Repository Interface → Repository Implementation → Data Source
      (UI)              (Domain)        (Domain)              (Data)                  (Data)
```

### Before (Old Structure)
```
Screen → BLoC → API Service
```

### After (Clean Architecture)
```
Screen → BLoC → Use Case → Repository Interface
                              ↓
                         Repository Impl → Data Source
```

## Step 4: Benefits

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to mock dependencies and test each layer
3. **Independence**: Domain layer is independent of frameworks and UI
4. **Flexibility**: Easy to swap data sources (API, cache, mock)
5. **Scalability**: Adding features follows consistent pattern
6. **Maintainability**: Changes are isolated to specific layers

## Step 5: Running the Restructured App

After creating all files:

```bash
# Get dependencies (if needed)
flutter pub get

# Run the app
flutter run

# Run tests (when tests are added)
flutter test
```

## Step 6: Migration from Old Structure

If you have the old structure and want to migrate:

1. ✅ Create new directory structure (Step 1)
2. ✅ Create all new files with updated code
3. ✅ Update main.dart with dependency injection
4. ✅ Test the application
5. ✅ Remove old directories (bloc/, cubit/, models/, services/)

## Documentation

- See `CLEAN_ARCHITECTURE_GUIDE.md` for detailed architecture explanation
- See `FILES_TO_CREATE.md` for complete file listing
- Original tutorials remain valid - just imports have changed

## Troubleshooting

**Issue**: Import errors after restructuring  
**Solution**: Update import paths to match new structure

**Issue**: BLoC not provided  
**Solution**: Check main.dart for proper BlocProvider setup with dependency injection

**Issue**: Use case not found  
**Solution**: Ensure use case files are created in domain/usecases/

## Example: Adding a New Feature

To add a new feature following Clean Architecture:

1. Create feature directory: `lib/features/my_feature/`
2. Add domain layer: entities, repository interface, use cases
3. Add data layer: data source, models, repository implementation
4. Add presentation layer: BLoC/Cubit, screens
5. Wire up in main.dart with dependency injection

---

**Note**: The project maintains both BLoC (User/Product) and Cubit (Post) patterns to demonstrate both approaches within Clean Architecture.
