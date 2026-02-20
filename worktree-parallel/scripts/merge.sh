#!/bin/bash
# merge.sh — Merge worktree branches sequentially
# Usage: bash .claude/skills/worktree-parallel/scripts/merge.sh task1 task2 task3
#
# Merges each branch one at a time.
# Stops and prints instructions on conflict.

set -e

TASKS=("$@")

if [ ${#TASKS[@]} -eq 0 ]; then
    echo "Usage: bash merge.sh task1 task2 task3 ..."
    exit 1
fi

echo "Merging ${#TASKS[@]} branch(es) sequentially..."
echo ""

for task in "${TASKS[@]}"; do
    BRANCH="worktree/${task}"

    echo "  Merging: ${BRANCH}"

    if ! git show-ref --verify --quiet "refs/heads/${BRANCH}"; then
        echo "  -> branch '${BRANCH}' not found, skipping."
        continue
    fi

    if git merge "${BRANCH}" --no-edit 2>&1; then
        echo "  -> merged successfully"
    else
        echo ""
        echo "Conflict detected in: ${BRANCH}"
        echo ""
        echo "To resolve:"
        echo "  1. Edit the conflicting files"
        echo "  2. git add <file>"
        echo "  3. git commit"
        echo "  4. Re-run this script to continue with remaining branches"
        echo ""
        echo "Conflicting files:"
        git status --short | grep "^UU\|^AA\|^DD" || true
        exit 1
    fi
done

echo ""
echo "All branches merged."
echo ""
echo "Recent commit history:"
git log --oneline --graph -10
