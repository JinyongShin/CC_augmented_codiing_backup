#!/bin/bash
# setup.sh — Create all worktrees at once
# Usage: bash .claude/skills/worktree-parallel/scripts/setup.sh task1 task2 task3
#
# For each task:
#   1. Creates a git worktree (branch: worktree/<task>)
#   2. Creates a tests/.test_env symlink if the file exists
#   3. Creates a .env symlink if the file exists

set -e

BASE_DIR=$(pwd)
PROJECT_NAME=$(basename "$BASE_DIR")
TASKS=("$@")

if [ ${#TASKS[@]} -eq 0 ]; then
    echo "Usage: bash setup.sh task1 task2 task3 ..."
    exit 1
fi

if [ ! -d ".git" ]; then
    echo "Error: not a git repository."
    exit 1
fi

echo "Creating ${#TASKS[@]} worktree(s) for project: ${PROJECT_NAME}"
echo ""

for task in "${TASKS[@]}"; do
    WORKTREE_PATH="../${PROJECT_NAME}_${task}"
    BRANCH_NAME="worktree/${task}"

    echo "  Creating: ${WORKTREE_PATH} (branch: ${BRANCH_NAME})"

    if [ -d "${WORKTREE_PATH}" ]; then
        echo "  -> already exists, skipping."
        continue
    fi

    git worktree add "${WORKTREE_PATH}" -b "${BRANCH_NAME}"

    if [ -f "tests/.test_env" ]; then
        mkdir -p "${WORKTREE_PATH}/tests"
        ln -sf "${BASE_DIR}/tests/.test_env" "${WORKTREE_PATH}/tests/.test_env"
        echo "  -> symlinked tests/.test_env"
    fi

    if [ -f ".env" ]; then
        ln -sf "${BASE_DIR}/.env" "${WORKTREE_PATH}/.env"
        echo "  -> symlinked .env"
    fi

    echo "  -> done"
done

echo ""
echo "All worktrees created:"
git worktree list
echo ""
echo "Next steps for each task:"
for task in "${TASKS[@]}"; do
    echo "  cd ../${PROJECT_NAME}_${task} && claude"
done
