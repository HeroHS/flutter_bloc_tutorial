# Clean Architecture Restructuring Guide

## Overview
This guide restructures the Flutter BLoC Tutorial to follow Clean Architecture principles.

## Directory Structure

The new structure organizes code into three layers per feature:

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   └── usecases/
│       └── usecase.dart
├── features/
│   ├── user/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── user_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_users.dart
│   │   │       └── get_users_with_error.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── user_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── user_bloc.dart
│   │       │   ├── user_event.dart
│   │       │   └── user_state.dart
│   │       └── screens/
│   │           └── user_list_screen.dart
│   ├── post/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── post.dart
│   │   │   ├── repositories/
│   │   │   │   └── post_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_posts.dart
│   │   │       └── get_posts_with_error.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── post_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── post_model.dart
│   │   │   └── repositories/
│   │   │       └── post_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── post_cubit.dart
│   │       │   └── post_state.dart
│   │       └── screens/
│   │           └── post_list_screen.dart
│   └── product/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product.dart
│       │   ├── repositories/
│       │   │   └── product_repository.dart
│       │   └── usecases/
│       │       └── get_products.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── product_remote_datasource.dart
│       │   ├── models/
│       │   │   └── product_model.dart
│       │   └── repositories/
│       │       └── product_repository_impl.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── product_bloc.dart
│           │   ├── product_event.dart
│           │   └── product_state.dart
│           └── screens/
│               └── product_list_screen.dart
└── main.dart
```

## Setup Instructions

### 1. Create Directory Structure

Run the following command from the project root to create all necessary directories:

**Windows Command Prompt:**
```batch
cd lib
mkdir core\error core\usecases
mkdir features\user\domain\entities features\user\domain\repositories features\user\domain\usecases
mkdir features\user\data\datasources features\user\data\models features\user\data\repositories
mkdir features\user\presentation\bloc features\user\presentation\screens
mkdir features\post\domain\entities features\post\domain\repositories features\post\domain\usecases
mkdir features\post\data\datasources features\post\data\models features\post\data\repositories
mkdir features\post\presentation\cubit features\post\presentation\screens
mkdir features\product\domain\entities features\product\domain\repositories features\product\domain\usecases
mkdir features\product\data\datasources features\product\data\models features\product\data\repositories
mkdir features\product\presentation\bloc features\product\presentation\screens
cd ..
```

**PowerShell:**
```powershell
$dirs = @(
  "lib\core\error", "lib\core\usecases",
  "lib\features\user\domain\entities", "lib\features\user\domain\repositories", "lib\features\user\domain\usecases",
  "lib\features\user\data\datasources", "lib\features\user\data\models", "lib\features\user\data\repositories",
  "lib\features\user\presentation\bloc", "lib\features\user\presentation\screens",
  "lib\features\post\domain\entities", "lib\features\post\domain\repositories", "lib\features\post\domain\usecases",
  "lib\features\post\data\datasources", "lib\features\post\data\models", "lib\features\post\data\repositories",
  "lib\features\post\presentation\cubit", "lib\features\post\presentation\screens",
  "lib\features\product\domain\entities", "lib\features\product\domain\repositories", "lib\features\product\domain\usecases",
  "lib\features\product\data\datasources", "lib\features\product\data\models", "lib\features\product\data\repositories",
  "lib\features\product\presentation\bloc", "lib\features\product\presentation\screens"
)
foreach ($dir in $dirs) { New-Item -ItemType Directory -Force -Path $dir }
```

**Bash/Git Bash:**
```bash
mkdir -p lib/core/{error,usecases}
mkdir -p lib/features/user/domain/{entities,repositories,usecases}
mkdir -p lib/features/user/data/{datasources,models,repositories}
mkdir -p lib/features/user/presentation/{bloc,screens}
mkdir -p lib/features/post/domain/{entities,repositories,usecases}
mkdir -p lib/features/post/data/{datasources,models,repositories}
mkdir -p lib/features/post/presentation/{cubit,screens}
mkdir -p lib/features/product/domain/{entities,repositories,usecases}
mkdir -p lib/features/product/data/{datasources,models,repositories}
mkdir -p lib/features/product/presentation/{bloc,screens}
```

### 2. File Migration Map

After creating directories, files will be created/moved:

| Old Location | New Location | Action |
|-------------|-------------|--------|
| `lib/models/user.dart` | `lib/features/user/domain/entities/user.dart` | Move & simplify |
| `lib/models/post.dart` | `lib/features/post/domain/entities/post.dart` | Move & simplify |
| `lib/models/product.dart` | `lib/features/product/domain/entities/product.dart` | Move |
| `lib/services/user_api_service.dart` | `lib/features/user/data/datasources/user_remote_datasource.dart` | Rename & refactor |
| `lib/services/post_api_service.dart` | `lib/features/post/data/datasources/post_remote_datasource.dart` | Rename & refactor |
| `lib/services/product_api_service.dart` | `lib/features/product/data/datasources/product_remote_datasource.dart` | Rename & refactor |
| `lib/bloc/user_*.dart` | `lib/features/user/presentation/bloc/user_*.dart` | Move & update imports |
| `lib/cubit/post_*.dart` | `lib/features/post/presentation/cubit/post_*.dart` | Move & update imports |
| `lib/bloc/product_*.dart` | `lib/features/product/presentation/bloc/product_*.dart` | Move & update imports |
| `lib/screens/user_list_screen.dart` | `lib/features/user/presentation/screens/user_list_screen.dart` | Move & update |
| `lib/screens/post_list_screen.dart` | `lib/features/post/presentation/screens/post_list_screen.dart` | Move & update |
| `lib/screens/product_list_screen.dart` | `lib/features/product/presentation/screens/product_list_screen.dart` | Move & update |
| `lib/screens/home_screen.dart` | Keep at `lib/screens/home_screen.dart` (shared) | Update imports only |

### 3. Clean Architecture Layers

#### Domain Layer (Innermost - No Dependencies)
- **Entities**: Pure business objects (User, Post, Product)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single responsibility business logic operations

#### Data Layer (Depends on Domain)
- **Data Sources**: Remote/local data fetching (API services)
- **Models**: DTOs extending entities with JSON serialization
- **Repository Implementations**: Concrete implementations of domain repositories

#### Presentation Layer (Depends on Domain)
- **BLoC/Cubit**: State management using use cases
- **Screens**: UI components
- **Widgets**: Reusable UI elements

### 4. Key Principles

1. **Dependency Rule**: Dependencies only point inward
   - Presentation → Domain ← Data
   - Domain has no dependencies on outer layers

2. **Use Cases**: Each use case represents one business operation
   - GetUsers, GetPosts, GetProducts, etc.
   - Called by BLoC/Cubit instead of services directly

3. **Repository Pattern**: Abstract data access
   - Domain defines interfaces
   - Data implements them
   - Easy to swap implementations (mock/real)

4. **Separation of Concerns**: Each layer has clear responsibility
   - Domain: Business logic
   - Data: Data access
   - Presentation: UI and user interaction

## Next Steps

After running the directory creation script, all the new files will be created with proper Clean Architecture implementation. The old directories (bloc, cubit, models, services, screens) can then be removed.

## Benefits

1. **Testability**: Easy to test each layer independently
2. **Maintainability**: Clear separation makes changes easier
3. **Scalability**: Adding features follows consistent pattern
4. **Flexibility**: Easy to swap implementations
5. **Team Collaboration**: Clear structure for team development
