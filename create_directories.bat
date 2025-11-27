@echo off
echo Creating Clean Architecture Directory Structure...
echo.

cd lib

REM Core layer
mkdir core\error 2>nul
mkdir core\usecases 2>nul

REM User feature
mkdir features\user\domain\entities 2>nul
mkdir features\user\domain\repositories 2>nul
mkdir features\user\domain\usecases 2>nul
mkdir features\user\data\datasources 2>nul
mkdir features\user\data\models 2>nul
mkdir features\user\data\repositories 2>nul
mkdir features\user\presentation\bloc 2>nul
mkdir features\user\presentation\screens 2>nul

REM Post feature
mkdir features\post\domain\entities 2>nul
mkdir features\post\domain\repositories 2>nul
mkdir features\post\domain\usecases 2>nul
mkdir features\post\data\datasources 2>nul
mkdir features\post\data\models 2>nul
mkdir features\post\data\repositories 2>nul
mkdir features\post\presentation\cubit 2>nul
mkdir features\post\presentation\screens 2>nul

REM Product feature
mkdir features\product\domain\entities 2>nul
mkdir features\product\domain\repositories 2>nul
mkdir features\product\domain\usecases 2>nul
mkdir features\product\data\datasources 2>nul
mkdir features\product\data\models 2>nul
mkdir features\product\data\repositories 2>nul
mkdir features\product\presentation\bloc 2>nul
mkdir features\product\presentation\screens 2>nul

cd ..

echo.
echo ================================================================================
echo Directory structure created successfully!
echo ================================================================================
echo.
echo Next steps:
echo 1. Run 'apply_clean_architecture.bat' to move/create all files
echo 2. Test the application with 'flutter run'
echo 3. Remove old directories after verification
echo.
pause
