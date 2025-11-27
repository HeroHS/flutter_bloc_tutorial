# STEP-BY-STEP Clean Architecture Implementation

## STEP 1: Create Directory Structure

Run ONE of these commands based on your environment:

### Windows CMD:
```batch
create_directories.bat
```

### Git Bash / WSL:
```bash
bash create_directories.sh
```

### PowerShell (if available):
```powershell
cd lib
New-Item -ItemType Directory -Force -Path @(
  "core\error", "core\usecases",
  "features\user\domain\entities", "features\user\domain\repositories", "features\user\domain\usecases",
  "features\user\data\datasources", "features\user\data\models", "features\user\data\repositories",
  "features\user\presentation\bloc", "features\user\presentation\screens",
  "features\post\domain\entities", "features\post\domain\repositories", "features\post\domain\usecases",
  "features\post\data\datasources", "features\post\data\models", "features\post\data\repositories",
  "features\post\presentation\cubit", "features\post\presentation\screens",
  "features\product\domain\entities", "features\product\domain\repositories", "features\product\domain\usecases",
  "features\product\data\datasources", "features\product\data\models", "features\product\data\repositories",
  "features\product\presentation\bloc", "features\product\presentation\screens"
)
cd ..
```

## STEP 2: After directory creation, proceed to create files

Once directories exist, I will create all the necessary files with Clean Architecture implementation.

The files are organized as follows:

### Core Files (2 files)
1. lib/core/error/failures.dart
2. lib/core/usecases/usecase.dart

### User Feature (11 files)
**Domain:**
3. lib/features/user/domain/entities/user.dart
4. lib/features/user/domain/repositories/user_repository.dart
5. lib/features/user/domain/usecases/get_users.dart
6. lib/features/user/domain/usecases/get_users_with_error.dart

**Data:**
7. lib/features/user/data/datasources/user_remote_datasource.dart
8. lib/features/user/data/models/user_model.dart
9. lib/features/user/data/repositories/user_repository_impl.dart

**Presentation:**
10. lib/features/user/presentation/bloc/user_event.dart
11. lib/features/user/presentation/bloc/user_state.dart
12. lib/features/user/presentation/bloc/user_bloc.dart
13. lib/features/user/presentation/screens/user_list_screen.dart

### Post Feature (10 files)
**Domain:**
14. lib/features/post/domain/entities/post.dart
15. lib/features/post/domain/repositories/post_repository.dart
16. lib/features/post/domain/usecases/get_posts.dart
17. lib/features/post/domain/usecases/get_posts_with_error.dart

**Data:**
18. lib/features/post/data/datasources/post_remote_datasource.dart
19. lib/features/post/data/models/post_model.dart
20. lib/features/post/data/repositories/post_repository_impl.dart

**Presentation:**
21. lib/features/post/presentation/cubit/post_state.dart
22. lib/features/post/presentation/cubit/post_cubit.dart
23. lib/features/post/presentation/screens/post_list_screen.dart

### Product Feature (11 files)
**Domain:**
24. lib/features/product/domain/entities/product.dart
25. lib/features/product/domain/repositories/product_repository.dart
26. lib/features/product/domain/usecases/get_products.dart

**Data:**
27. lib/features/product/data/datasources/product_remote_datasource.dart
28. lib/features/product/data/models/product_model.dart
29. lib/features/product/data/repositories/product_repository_impl.dart

**Presentation:**
30. lib/features/product/presentation/bloc/product_event.dart
31. lib/features/product/presentation/bloc/product_state.dart
32. lib/features/product/presentation/bloc/product_bloc.dart
33. lib/features/product/presentation/screens/product_list_screen.dart

### Updated Files (2 files)
34. lib/main.dart (updated with dependency injection)
35. lib/screens/home_screen.dart (updated imports)

**Total: 35 files**

## STEP 3: Verify Structure

After all files are created, your lib directory should look like:

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   └── usecases/
│       └── usecase.dart
├── features/
│   ├── user/
│   ├── post/
│   └── product/
├── screens/
│   └── home_screen.dart
└── main.dart
```

## STEP 4: Test

```bash
flutter pub get
flutter run
```

## STEP 5: Clean Up (Optional)

After verification, remove old directories:
```bash
rm -rf lib/bloc lib/cubit lib/models lib/services
```

Or on Windows:
```batch
rmdir /s /q lib\bloc lib\cubit lib\models lib\services
```
