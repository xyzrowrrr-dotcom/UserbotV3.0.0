#!/bin/bash

# Color definitions using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
NC=$(tput sgr0)

# Type animation
type_text() {
  text="$1"
  for ((i=0;i<${#text};i++)); do
    echo -n "${text:$i:1}"
    sleep 0.02
  done
  echo ""
}

# Loading bar for each step
loading_bar() {
  msg="$1"
  duration="$2"
  bar_size=20
  step_sleep=$(awk "BEGIN {print $duration/$bar_size}")
  for ((i=0;i<=bar_size;i++)); do
    bar=$(printf "%-${i}s" "" | tr ' ' '=')
    empty=$(printf "%-$((bar_size-i))s")
    percent=$((i*100/bar_size))
    echo -ne "\r${YELLOW}[!]${NC} $msg [${bar}${empty}] ${percent}%"
    sleep $step_sleep 2>/dev/null || sleep 0.1
  done
  echo -ne "\r${GREEN}[√]${NC} $msg [${bar}] DONE\n"
}

clear
type_text "${WHITE}> Checking system status...${NC}"
echo -e "\n${CYAN}================ [ SYSTEM STATUS ] =================${NC}"

loading_bar "Checking network connection" 2
loading_bar "Checking Git repository" 2
loading_bar "Checking permissions" 1

echo -e "${CYAN}===================================================${NC}\n"

type_text "${WHITE}> Checking for latest updates from server...${NC}"
loading_bar "Fetching remote data" 3

if ! git fetch origin &>/dev/null; then
  echo -e "\n${RED}================== [ FETCH FAILED ] ===================${NC}"
  type_text "${RED}> ERROR: Could not connect to remote repository.${NC}"
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

echo ""
if [ "$LOCAL" = "$REMOTE" ]; then
  loading_bar "Latest Version" 3
  echo -e "${CYAN}> Current branch: ${YELLOW}$BRANCH${NC}"
  echo -e "${CYAN}> Last commit: ${YELLOW}$(git log -1 --pretty=%h)${NC}"
  echo -e "${CYAN}> Commit message: \"$(git log -1 --pretty=%s)\"${NC}"
else
  loading_bar "Updating to new version" 5

  # 🔥 Auto-backup session sebelum reset
  BACKUP_DIR="$HOME/session_backup_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  find . -maxdepth 1 -type f -name "*.session" -exec cp {} "$BACKUP_DIR" \;

  echo -e "${YELLOW}[!]${NC} Session files backed up to: ${GREEN}$BACKUP_DIR${NC}"

  # 👉 Update paksa (buang commit lokal)
  if git fetch origin && git reset --hard origin/$BRANCH; then
    loading_bar "Update successful" 3
    echo -e "${CYAN}Changed files:${NC}"
    git diff --name-only $LOCAL $REMOTE | while read file; do
      echo -e "${GREEN}  + $file${NC}"
    done
  else
    loading_bar "Update failed" 2
    type_text "${RED}> ERROR: An error occurred during the update.${NC}"
  fi
fi