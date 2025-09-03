#!/bin/bash

# ==============================
# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
# ==============================

clear
echo -e "${CYAN}🔍 Checking for updates...${NC}"

# Loading animation
spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
i=0
while git fetch origin &>/dev/null; do
    i=$(( (i+1) %10 ))
    printf "\r${YELLOW}⏳ Fetching updates ${spin:$i:1}${NC}"
    sleep 0.1
    break
done
echo ""

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✅ Already up to date ($BRANCH)${NC}"
    echo ""
    echo -e "${CYAN}📌 Last commit:${NC}"
    git log -1 --pretty=format:"%h | %an | %s (%cr)"
else
    echo -e "${YELLOW}⬇️ Update found on branch $BRANCH!${NC}"
    echo -e "${CYAN}⚡ Pulling updates...${NC}"
    git pull origin $BRANCH

    echo ""
    echo -e "${CYAN}📜 Files updated:${NC}"
    git diff --name-only $LOCAL $REMOTE | while read file; do
        echo -e "${GREEN}- $file${NC}"
    done

    echo ""
    if [ -f "README.md" ]; then
        echo -e "${CYAN}📖 Latest README.md preview:${NC}"
        echo "------------------------------------"
        cat README.md
        echo "------------------------------------"
    else
        echo -e "${RED}ℹ️ No README.md found in project.${NC}"
    fi

    echo -e "${GREEN}🚀 Update complete!${NC}"
fi