# ⚠️ IMPORTANT: Manual Execution Required

Due to PowerShell environment limitations, please follow these manual steps:

## Step 1: Create Directory Structure

Open **Command Prompt** or **PowerShell** in the project root directory and run:

```batch
create_directories.bat
```

This will create all necessary folders for Clean Architecture.

## Step 2: Notify AI Assistant

After running the batch file successfully, please respond with:
**"Directories created, proceed with files"**

Then I will create all ~35 Clean Architecture files automatically.

## Alternative: Manual Directory Creation

If the batch file doesn't work, create directories manually:

### Using File Explorer:
Navigate to `d:\flutter_projects\flutter_bloc_tutorial\lib\` and create these folders:

```
core/
  error/
  usecases/
features/
  user/
    domain/
      entities/
      repositories/
      usecases/
    data/
      datasources/
      models/
      repositories/
    presentation/
      bloc/
      screens/
  post/
    domain/
      entities/
      repositories/
      usecases/
    data/
      datasources/
      models/
      repositories/
    presentation/
      cubit/
      screens/
  product/
    domain/
      entities/
      repositories/
      usecases/
    data/
      datasources/
      models/
      repositories/
    presentation/
      bloc/
      screens/
```

Then respond with: **"Directories created manually, proceed with files"**

## What Happens Next?

Once directories exist, I will:
1. Create all core files (failures, use cases)
2. Create all User feature files (11 files)
3. Create all Post feature files (10 files)  
4. Create all Product feature files (11 files)
5. Update main.dart with dependency injection
6. Update home_screen.dart with new imports

Total: ~35 files following Clean Architecture principles

## Why This Approach?

The AI environment cannot execute PowerShell commands directly due to configuration issues. By having you create the directories manually, we can then proceed with automated file creation.

---

**👉 ACTION REQUIRED: Please run `create_directories.bat` and confirm when done!**
