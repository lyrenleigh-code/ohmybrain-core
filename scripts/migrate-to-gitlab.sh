#!/usr/bin/env bash
# migrate-to-gitlab.sh — 给 D:/Claude 下 8 个项目添加 GitLab 远程（方案 B 双远程）
#
# 用法：
#   bash D:/Claude/scripts/migrate-to-gitlab.sh add        # 仅添加 remote（dry-run，不 push）
#   bash D:/Claude/scripts/migrate-to-gitlab.sh push <项目名>   # 推单个项目
#   bash D:/Claude/scripts/migrate-to-gitlab.sh push-all   # 推全部（凭据已缓存后执行）
#   bash D:/Claude/scripts/migrate-to-gitlab.sh status     # 查看每个项目 remote -v + branch + HEAD
#   bash D:/Claude/scripts/migrate-to-gitlab.sh remove     # 仅移除 gitlab remote（回滚用）
#
# 前置：
#   git config --global credential.helper manager-core   （已配）
#   GitLab 8 仓库已建好且 Initialize=OFF                 （已建）
#
# 首次 push 会弹 Windows 凭据窗：username=lilin, password=PAT

set -e

GITLAB_BASE="http://192.168.10.100:8880/lilin"

# 路径 仓库名 visibility（仅备注用）
PROJECTS=(
  "D:/Claude/Ohmybrain                Ohmybrain          Internal"
  "D:/Claude/ohmybrain-core           ohmybrain-core     Internal"
  "D:/Claude/TechReq/UWAcomm          UWAcomm            Internal"
  "D:/Claude/TechReq/USBL             USBL               Internal"
  "D:/Claude/TechReq/UWAnet           UWAnet             Internal"
  "D:/Claude/TechReq/UWAcomm_usbl     UWAcomm_usbl       Internal"
  "D:/Claude/DocProcess/Pricing       Pricing            Private"
  "D:/Claude/Tools/FlowGen            FlowGen            Private"
)

cmd="${1:-status}"
target="${2:-}"

print_header() {
  printf '\n=== %-60s [%s] ===\n' "$1" "$2"
}

iter_projects() {
  local action="$1"
  for entry in "${PROJECTS[@]}"; do
    read -r path repo vis <<< "$entry"
    print_header "$repo @ $path" "$vis"
    cd "$path"
    "$action" "$path" "$repo" "$vis"
  done
}

action_add() {
  local path="$1" repo="$2"
  local url="${GITLAB_BASE}/${repo}.git"
  if git remote | grep -q '^gitlab$'; then
    local cur
    cur=$(git remote get-url gitlab)
    if [ "$cur" = "$url" ]; then
      echo "  ✓ gitlab remote 已存在且 URL 正确"
    else
      echo "  ⚠ gitlab remote 已存在但 URL 不同：$cur"
      echo "    更新到 $url"
      git remote set-url gitlab "$url"
    fi
  else
    git remote add gitlab "$url"
    echo "  + 已添加 gitlab remote"
  fi
  git remote -v | grep gitlab
}

action_status() {
  echo "  remotes:"
  git remote -v | sed 's/^/    /'
  echo "  branch: $(git branch --show-current)"
  echo "  HEAD:   $(git log -1 --oneline 2>&1)"
  echo "  tags:   $(git tag | wc -l) 个"
}

action_push() {
  local path="$1" repo="$2"
  if ! git remote | grep -q '^gitlab$'; then
    echo "  ✗ gitlab remote 不存在，先跑 add"
    return 1
  fi
  echo "  push --all..."
  git push -u gitlab --all
  echo "  push --tags..."
  git push gitlab --tags
  echo "  ✓ done"
}

action_remove() {
  if git remote | grep -q '^gitlab$'; then
    git remote remove gitlab
    echo "  - 已移除 gitlab remote"
  else
    echo "  ✓ 无 gitlab remote"
  fi
}

case "$cmd" in
  add)
    iter_projects action_add
    ;;
  status)
    iter_projects action_status
    ;;
  remove)
    iter_projects action_remove
    ;;
  push-all)
    iter_projects action_push
    ;;
  push)
    if [ -z "$target" ]; then
      echo "用法: bash $0 push <项目名>"
      echo "可选项目名:"
      for entry in "${PROJECTS[@]}"; do
        read -r _ repo _ <<< "$entry"
        echo "  $repo"
      done
      exit 1
    fi
    found=0
    for entry in "${PROJECTS[@]}"; do
      read -r path repo vis <<< "$entry"
      if [ "$repo" = "$target" ]; then
        print_header "$repo @ $path" "$vis"
        cd "$path"
        action_push "$path" "$repo"
        found=1
        break
      fi
    done
    [ "$found" = "0" ] && { echo "未找到项目: $target"; exit 1; }
    ;;
  *)
    echo "用法: bash $0 {add|status|push <项目名>|push-all|remove}"
    exit 1
    ;;
esac
