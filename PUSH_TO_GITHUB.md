# 🚀 Push TaskMate to GitHub

## Quick Commands

```bash
# 1. Initialize Git (if not already done)
git init

# 2. Add remote repository
git remote add origin https://github.com/Ampexqt/TaskMate.git

# 3. Add all files
git add .

# 4. Commit
git commit -m "Initial commit: TaskMate app with Firebase backup"

# 5. Push to GitHub
git push -u origin main
```

---

## 📋 Step-by-Step Guide

### **Step 1: Check Git Status**

```bash
# Check if git is initialized
git status
```

If you see "not a git repository", continue to Step 2.
If you see file changes, skip to Step 3.

### **Step 2: Initialize Git**

```bash
# Initialize git in your project
git init

# Set your name and email (if not set globally)
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### **Step 3: Add Remote Repository**

```bash
# Add your GitHub repository
git remote add origin https://github.com/Ampexqt/TaskMate.git

# Verify remote was added
git remote -v
```

### **Step 4: Create .gitignore**

Make sure you have a `.gitignore` file to exclude build files and secrets.

### **Step 5: Add Files**

```bash
# Add all files to staging
git add .

# Check what will be committed
git status
```

### **Step 6: Commit**

```bash
# Commit with a message
git commit -m "Initial commit: TaskMate app with Firebase backup and restore"
```

### **Step 7: Push to GitHub**

```bash
# Push to main branch
git push -u origin main
```

If you get an error about "main" vs "master", try:
```bash
# Rename branch to main
git branch -M main

# Push again
git push -u origin main
```

---

## 🔐 Authentication

If GitHub asks for credentials:

### **Option 1: Personal Access Token (Recommended)**

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (full control)
4. Copy the token
5. Use token as password when pushing

### **Option 2: GitHub CLI**

```bash
# Install GitHub CLI first, then:
gh auth login
```

### **Option 3: SSH Key**

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub: https://github.com/settings/keys
# Change remote to SSH
git remote set-url origin git@github.com:Ampexqt/TaskMate.git
```

---

## 📝 Important Files to Check

Before pushing, make sure these are in `.gitignore`:

```
# Build outputs
build/
.dart_tool/

# IDE
.idea/
.vscode/
*.iml

# Firebase secrets
lib/firebase_options.dart  # If it contains secrets
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

# Keys
*.jks
*.keystore
key.properties
android/key.properties

# Local files
.flutter-plugins
.flutter-plugins-dependencies
.packages
pubspec.lock
```

---

## ⚠️ Security Checklist

Before pushing:

- [ ] Remove any API keys or secrets
- [ ] Check `firebase_options.dart` doesn't have sensitive data
- [ ] Ensure `key.properties` is in `.gitignore`
- [ ] Remove any `google-services.json` if it has secrets
- [ ] Check for any hardcoded passwords

---

## 🎯 Complete Workflow

```bash
# Navigate to project
cd d:\applications\task_mate

# Initialize git (if needed)
git init

# Add remote
git remote add origin https://github.com/Ampexqt/TaskMate.git

# Check .gitignore exists
# (I'll create one for you)

# Add all files
git add .

# Commit
git commit -m "Initial commit: TaskMate - Task management app with Firebase cloud backup"

# Set branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## 🔄 Future Updates

After initial push, to update:

```bash
# Add changes
git add .

# Commit
git commit -m "Your commit message"

# Push
git push
```

---

## 📊 Useful Git Commands

```bash
# Check status
git status

# View commit history
git log --oneline

# View remote
git remote -v

# Pull latest changes
git pull

# Create new branch
git checkout -b feature-name

# Switch branch
git checkout main
```

---

## 🚨 Troubleshooting

### **Error: "remote origin already exists"**

```bash
# Remove existing remote
git remote remove origin

# Add again
git remote add origin https://github.com/Ampexqt/TaskMate.git
```

### **Error: "failed to push some refs"**

```bash
# Pull first, then push
git pull origin main --rebase
git push -u origin main
```

### **Error: "Authentication failed"**

- Use Personal Access Token instead of password
- Or use GitHub CLI: `gh auth login`

---

## 📱 What Will Be Pushed

Your repository will include:
- ✅ All source code
- ✅ Assets and icons
- ✅ Configuration files
- ✅ Documentation (README, guides)
- ❌ Build outputs (excluded by .gitignore)
- ❌ IDE files (excluded by .gitignore)
- ❌ Secrets and keys (excluded by .gitignore)

---

**Ready to push your code!** 🚀
