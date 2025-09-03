#!/bin/bash

echo "🔍 Checking for updates..."

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Fetch latest changes
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Already up to date ($BRANCH)"
else
    echo "⬇️ Update available on branch: $BRANCH"
    echo "⚡ Pulling updates..."
    git pull origin $BRANCH

    echo ""
    echo "📜 Files updated:"
    git diff --name-only $LOCAL $REMOTE

    echo ""
    if [ -f "README.md" ]; then
        echo "📖 Latest README.md content:"
        echo "------------------------------------"
        cat README.md
        echo "------------------------------------"
    else
        echo "ℹ️ No README.md found in project."
    fi

    echo "🚀 Update complete!"
fi