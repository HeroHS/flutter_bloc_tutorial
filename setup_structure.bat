@echo off
REM Create Clean Architecture folder structure

REM Core layer
mkdir lib\core\error 2>nul
mkdir lib\core\usecases 2>nul

REM User feature
mkdir lib\features\user\domain\entities 2>nul
mkdir lib\features\user\domain\repositories 2>nul
mkdir lib\features\user\domain\usecases 2>nul
mkdir lib\features\user\data\datasources 2>nul
mkdir lib\features\user\data\models 2>nul
mkdir lib\features\user\data\repositories 2>nul
mkdir lib\features\user\presentation\bloc 2>nul
mkdir lib\features\user\presentation\screens 2>nul
mkdir lib\features\user\presentation\widgets 2>nul

REM Post feature
mkdir lib\features\post\domain\entities 2>nul
mkdir lib\features\post\domain\repositories 2>nul
mkdir lib\features\post\domain\usecases 2>nul
mkdir lib\features\post\data\datasources 2>nul
mkdir lib\features\post\data\models 2>nul
mkdir lib\features\post\data\repositories 2>nul
mkdir lib\features\post\presentation\cubit 2>nul
mkdir lib\features\post\presentation\screens 2>nul
mkdir lib\features\post\presentation\widgets 2>nul

REM Product feature
mkdir lib\features\product\domain\entities 2>nul
mkdir lib\features\product\domain\repositories 2>nul
mkdir lib\features\product\domain\usecases 2>nul
mkdir lib\features\product\data\datasources 2>nul
mkdir lib\features\product\data\models 2>nul
mkdir lib\features\product\data\repositories 2>nul
mkdir lib\features\product\presentation\bloc 2>nul
mkdir lib\features\product\presentation\screens 2>nul
mkdir lib\features\product\presentation\widgets 2>nul

echo Directory structure created successfully!
