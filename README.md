# ohmybrain-core

> 母仓 / 模板 / 通用 harness

为所有项目提供统一的 Claude Code harness 模板，包含规则、技能、钩子、脚本和工作流。

## 架构

```
ohmybrain-core（本仓库）     → 提供模板
  ├→ project-*（子项目）     → 从模板派生，自包含
  └→ ohmybrain（知识库+hub）  → 个人知识 + 项目导航
```

## 使用方式

### 创建新项目

将 `template/` 目录下的内容复制到新项目中：

```bash
cp -r template/.claude     新项目/
cp -r template/.obsidian   新项目/
cp -r template/.github     新项目/
cp -r template/wiki        新项目/
cp -r template/raw         新项目/
cp -r template/scripts     新项目/
cp -r template/workflows   新项目/
cp template/CLAUDE.md      新项目/
cp template/.gitignore     新项目/
```

然后修改 `CLAUDE.md` 中的项目名称和目录地图。

### 经验回流

项目中沉淀的通用规则、技能或脚本改进，回写到本仓库的 `template/` 中。

## 模板内容

| 目录 | 内容 |
|------|------|
| `template/.claude/rules/` | 4 个路径规则（wiki/raw/engineering/specs） |
| `template/.claude/skills/` | 5 个技能（ingest/plan/implement/lint/promote） |
| `template/.claude/settings.json` | Python 跨平台 hooks（Pre/Post/Stop） |
| `template/.obsidian/` | Obsidian vault 配置 + 5 个 wiki 页面模板 |
| `template/raw/` | 只读原始资料层（10 个子目录骨架） |
| `template/wiki/` | 知识层（index.md + log.md） |
| `template/workflows/knowledge/` | 知识闭环 4 步（ingest→query→promote→review） |
| `template/workflows/engineering/` | 开发闭环 4 步（spec→plan→implement→validate） |
| `template/scripts/` | 7 个自动化脚本 |
| `template/.github/workflows/` | CI + wiki-check |

### 脚本清单

| 脚本 | 用途 | 调用方式 |
|------|------|---------|
| `lint_wiki.py` | Wiki 结构检查 | 手动 / PostToolUse hook |
| `sync_index.py` | 同步 index 页面计数 | 手动 |
| `validate_task.py` | 任务完成验证 | Stop hook |
| `check_raw_write.py` | 拦截 raw/ 写入 | PreToolUse hook |
| `check_index_log_sync.py` | Wiki index/log 同步检查 | Stop hook |
| `scrape.py` | Firecrawl 网页抓取 | 手动（需 FIRECRAWL_API_KEY） |
| `transcribe.py` | Whisper 音视频转录 | 手动（需 openai-whisper + ffmpeg） |
