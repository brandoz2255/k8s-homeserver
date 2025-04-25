# Learned more about git commands

```bash
git reset --hard HEAD~1
```

- This command resets the current branch to the previous commit, discarding all changes in the working directory and staging area. Use with caution as it will permanently delete any uncommitted changes

```bash
git rm --cached -r <file>
```

- this command removes the specified file from the staging area and the working directory

Helpful when you want to remove a file from the repository but not delete it from your local machine
