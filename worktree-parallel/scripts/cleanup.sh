#!/bin/bash
# cleanup.sh — Remove worktrees and delete branches
# Usage: bash .claude/skills/worktree-parallel/scripts/cleanup.sh task1 task2 task3

PROJECT_NAME=$(basename "$(pwd)")
TASKS=("$@")

if [ ${#TASKS[@]} -eq 0 ]; then
    echo "Usage: bash cleanup.sh task1 task2 task3 ..."
    exit 1
fi

echo "Cleaning up ${#TASKS[@]} worktree(s) for project: ${PROJECT_NAME}"
echo ""

ERRORS=0

for task in "${TASKS[@]}"; do
    WORKTREE_PATH="../${PROJECT_NAME}_${task}"
    BRANCH_NAME="worktree/${task}"

    if [ -d "${WORKTREE_PATH}" ]; then
        echo "  Removing worktree: ${WORKTREE_PATH}"
        if git worktree remove "${WORKTREE_PATH}" --force 2>&1; then
            echo "  -> removed"
        else
            echo "  -> failed (manual removal may be needed)"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "  ${WORKTREE_PATH} not found (already removed)"
    fi

    if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
        echo "  Deleting branch: ${BRANCH_NAME}"
        if git branch -d "${BRANCH_NAME}" 2>&1; then
            echo "  -> deleted"
        else
            echo "  -> regular delete failed, trying force delete..."
            git branch -D "${BRANCH_NAME}" && echo "  -> force deleted" || {
                echo "  -> force delete also failed"
                ERRORS=$((ERRORS + 1))
            }
        fi
    else
        echo "  Branch ${BRANCH_NAME} not found (already deleted)"
    fi

    echo ""
done

echo "Current state:"
echo ""
git worktree list
echo ""
git branch

if [ $ERRORS -eq 0 ]; then
    echo ""
    echo "Cleanup complete."
else
    echo ""
    echo "Warning: ${ERRORS} error(s) occurred. Review output above."
fi
