# Clean Architecture Implementation Files

This document lists all the new files that need to be created for the Clean Architecture restructuring.

## IMPORTANT: Run create_directories.bat first!

Before proceeding, you must run:
```
create_directories.bat
```

This will create all necessary directories. Then you can proceed with creating the files below.

## Core Layer Files

### 1. lib/core/error/failures.dart
### 2. lib/core/usecases/usecase.dart

## User Feature Files

### Domain Layer
- lib/features/user/domain/entities/user.dart
- lib/features/user/domain/repositories/user_repository.dart
- lib/features/user/domain/usecases/get_users.dart
- lib/features/user/domain/usecases/get_users_with_error.dart

### Data Layer
- lib/features/user/data/datasources/user_remote_datasource.dart
- lib/features/user/data/models/user_model.dart
- lib/features/user/data/repositories/user_repository_impl.dart

### Presentation Layer
- lib/features/user/presentation/bloc/user_event.dart
- lib/features/user/presentation/bloc/user_state.dart
- lib/features/user/presentation/bloc/user_bloc.dart
- lib/features/user/presentation/screens/user_list_screen.dart

## Post Feature Files

### Domain Layer
- lib/features/post/domain/entities/post.dart
- lib/features/post/domain/repositories/post_repository.dart
- lib/features/post/domain/usecases/get_posts.dart
- lib/features/post/domain/usecases/get_posts_with_error.dart

### Data Layer
- lib/features/post/data/datasources/post_remote_datasource.dart
- lib/features/post/data/models/post_model.dart
- lib/features/post/data/repositories/post_repository_impl.dart

### Presentation Layer
- lib/features/post/presentation/cubit/post_state.dart
- lib/features/post/presentation/cubit/post_cubit.dart
- lib/features/post/presentation/screens/post_list_screen.dart

## Product Feature Files

### Domain Layer
- lib/features/product/domain/entities/product.dart
- lib/features/product/domain/repositories/product_repository.dart
- lib/features/product/domain/usecases/get_products.dart

### Data Layer
- lib/features/product/data/datasources/product_remote_datasource.dart
- lib/features/product/data/models/product_model.dart
- lib/features/product/data/repositories/product_repository_impl.dart

### Presentation Layer
- lib/features/product/presentation/bloc/product_event.dart
- lib/features/product/presentation/bloc/product_state.dart
- lib/features/product/presentation/bloc/product_bloc.dart
- lib/features/product/presentation/screens/product_list_screen.dart

## Modified Files
- lib/main.dart (update imports and add dependency injection)
- lib/screens/home_screen.dart (update imports only)

## Files to Delete (after verification)
- lib/bloc/ (entire directory)
- lib/cubit/ (entire directory)  
- lib/models/ (entire directory)
- lib/services/ (entire directory)
- Old screen files that were moved

Total new files: ~40 files
