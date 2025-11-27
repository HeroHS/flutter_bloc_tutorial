import os

# Base directory
base_dir = r'd:\flutter_projects\flutter_bloc_tutorial\lib'

# Create Clean Architecture folder structure
directories = [
    # Core layer
    'core/error',
    'core/usecases',
    
    # User feature
    'features/user/domain/entities',
    'features/user/domain/repositories',
    'features/user/domain/usecases',
    'features/user/data/datasources',
    'features/user/data/models',
    'features/user/data/repositories',
    'features/user/presentation/bloc',
    'features/user/presentation/screens',
    'features/user/presentation/widgets',
    
    # Post feature
    'features/post/domain/entities',
    'features/post/domain/repositories',
    'features/post/domain/usecases',
    'features/post/data/datasources',
    'features/post/data/models',
    'features/post/data/repositories',
    'features/post/presentation/cubit',
    'features/post/presentation/screens',
    'features/post/presentation/widgets',
    
    # Product feature
    'features/product/domain/entities',
    'features/product/domain/repositories',
    'features/product/domain/usecases',
    'features/product/data/datasources',
    'features/product/data/models',
    'features/product/data/repositories',
    'features/product/presentation/bloc',
    'features/product/presentation/screens',
    'features/product/presentation/widgets',
]

for directory in directories:
    path = os.path.join(base_dir, directory)
    os.makedirs(path, exist_ok=True)
    print(f'Created: {path}')

print('\nDirectory structure created successfully!')
