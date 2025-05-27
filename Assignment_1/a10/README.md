# a10 - Git Basics

# Create and Switch to a New Branch
git checkout -b feature-branch

# Make Changes and Commit
echo "Some changes" > file.txt
git add file.txt
git commit -m "Add changes to file.txt"

# Switch Back to Master and Merge
git checkout master
git merge feature-branch

# Resolve Merge Conflicts
<<<<<<< HEAD
Your changes
=======
Incoming changes
>>>>>>> feature-branch

# Add and Commit Resolved Files
git add file.txt
git commit -m "Resolve merge conflict in file.txt"

# Push Changes to Remote Repository
git push origin master
