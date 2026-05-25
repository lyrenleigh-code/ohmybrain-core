# ohmybrain-core — 母仓 / 模板 / 通用 harness

> Ohmybrain Core — Project Template & Universal Harness
>
> 为所有项目提供统一的 Claude Code harness 模板，包含规则、技能、钩子、脚本和工作流。**所有新项目从此派生**。

---

## 三仓架构

```
ohmybrain-core（本仓库 / 母仓 / 模板，2026-05-24 三模板拆分）
  ├── template-engineering/   → 派生工程项目（TechReq/*）
  ├── template-document/      → 派生文档项目（DocProcess/*）
  └── template-tool/          → 派生工具项目（Tools/*）

派生项目（按类别分组）：

TechReq/（template-engineering 派生）：
  ├──派生──► UWAcomm（水声通信仿真，6 体制）
  ├──派生──► USBL（超短基线自定位）
  ├──派生──► UWAnet（组网协议仿真）
  └──派生──► UWAcomm_usbl 🔒（联合仿真，内网）

Tools/（template-tool 派生）：
  ├──派生──► FlowGen 🔒（Mermaid + Visio 流程/架构图工具）
  └──派生──► AnthropicPPT 🔒（FIELDBOOK PPT 模板套件，2026-05-23）

DocProcess/（template-document 派生，全私人）：
  ├──派生──► Pricing 🔒（军用四号文报价）
  ├──派生──► UWAprojDoc 🔒（水声专项方案文档，非 git）
  ├──派生──► CooperativeDetection 🔒（4 专题 12 课题方案，非 git）
  ├──派生──► PaperReview 🔒（学位论文外审，非 git）
  ├──派生──► DigitalTwinGuide 🔒（数字孪生方法论，非 git）
  └──派生──► DigitalTwin1plusN 🔒（1+N 集群数字孪生，非 git）

ohmybrain（知识库 + Hub）
  └── 跨项目知识沉淀（concepts / entities / architecture / topics / source-summaries）
```

**三层职责**：

| 层 | 角色 | 仓库 |
|----|------|------|
| **core** | 模板 / harness 复用 | `ohmybrain-core` |
| **project** | 工程闭环 / 算法实现 | UWAcomm / USBL / UWAnet / ... |
| **hub** | 跨项目知识沉淀 | `Ohmybrain` |

详见 [Hub 三仓架构页](https://github.com/lyrenleigh-code/Ohmybrain/blob/main/wiki/architecture/system-overview.md)。

---

## 模板内容（三模板，2026-05-24 拆分）

### 共性目录（三模板均含）

| 目录 | 内容 |
|------|------|
| `<template>/.claude/rules/` | 路径规则（wiki / raw / specs 等） |
| `<template>/.claude/skills/` | 通用技能（ingest / plan / implement / lint / promote） |
| `<template>/.claude/commands/` | Slash commands（`/ingest`, `/promote`） |
| `<template>/.claude/agents/` | 通用 agents（如 wiki-ingester，2026-05-24 下沉） |
| `<template>/.claude/settings.json` | Python 跨平台 hooks（Pre / Post / Stop） |
| `<template>/.obsidian/` | Obsidian vault 配置 + wiki 页面模板 |
| `<template>/raw/` | 只读原始资料层 |
| `<template>/wiki/` | 知识层（index.md + log.md + concept/entity/architecture 模板） |
| `<template>/scripts/` | 自动化脚本（lint / sync / hooks 等 7+ 个） |
| `<template>/prompts/` | 自主新建项目闭环驱动套件（可选） |

### 三模板差异

| 模板 | 派生目标 | 特有目录 |
|------|---------|----------|
| **template-engineering/** | `TechReq/*`（算法/仿真） | `src/` + `tests/` + `evals/` + `workflows/engineering/`（spec → plan → implement → validate 4 步） |
| **template-document/** | `DocProcess/*`（文档撰写，私人） | `output/` 占位 + `workflows/document/`（4 步：spec → draft → validate → archive）；CLAUDE.md 强调私人约束 |
| **template-tool/** | `Tools/*`（CLI / skill 工具） | `templates/` + `output/sample/` + `workflows/tool/`（5 步：design → implement → test → register-skill → docs） |

---

## 脚本清单

| 脚本 | 用途 | 调用方式 |
|------|------|----------|
| `lint_wiki.py` | Wiki 结构检查（frontmatter / 链接 / 死链） | 手动 / PostToolUse hook（`--quick`） |
| `sync_index.py` | 同步 wiki/index.md 页面计数 | 手动 |
| `validate_task.py` | 任务完成验证 | Stop hook |
| `check_raw_write.py` | 拦截 raw/ 写入 | PreToolUse hook |
| `check_private_tags.py` | 拦截 `<private>` 标签外泄到公开 wiki | PreToolUse hook |
| `check_index_log_sync.py` | Wiki index/log 同步检查 | Stop hook |
| `scrape.py` | Firecrawl 网页抓取到 raw/ | 手动（需 FIRECRAWL_API_KEY） |
| `transcribe.py` | Whisper 音视频转录到 raw/ | 手动（需 openai-whisper + ffmpeg） |

---

## 使用方式

### 方式 A：直接复制目录（旧方法，按项目类型选模板）

```bash
# 三模板任选其一（按项目分类）：
TEMPLATE=template-engineering   # 算法/仿真项目
# TEMPLATE=template-document    # 文档撰写项目（私人）
# TEMPLATE=template-tool        # CLI / skill 工具

cp -r $TEMPLATE/.claude       新项目/
cp -r $TEMPLATE/.obsidian     新项目/
cp -r $TEMPLATE/wiki          新项目/
cp -r $TEMPLATE/raw           新项目/
cp -r $TEMPLATE/scripts       新项目/
cp -r $TEMPLATE/workflows     新项目/
cp -r $TEMPLATE/prompts       新项目/
cp $TEMPLATE/CLAUDE.md        新项目/
cp $TEMPLATE/.gitignore       新项目/
```

修改 `CLAUDE.md` 中的项目名称、目录地图、Hub 引用。

### 方式 B：新项目 SOP（推荐）

完整流程见 `docs/new-project-sop.md`：

```
1. 在 ohmybrain（Hub）的 projects/<slug>/ 下建占位
2. 按项目类别拷贝 template-engineering / template-document / template-tool 到目标路径
3. 填 CLAUDE.md 项目特有部分（slug / 路径 / 关联项目 / 启动模式）
4. （可选）填 prompts/goal.yaml 启用自主新建项目闭环
5. `git init -b main` + 创建 GitHub/GitLab 远端（默认主分支统一为 `main`）
6. 第一次 commit + push 双推
```

### 方式 C：自主新建项目闭环（实验性）

适合"一行目标 → Phase 0-6 → M1 真装机"的场景：

- `<template>/prompts/goal.yaml.tpl` — 闭环权威驱动（Phase 0 人工填，三模板均含）
- `<template>/prompts/planner.md` / `<template>/prompts/evaluator.md` — agent prompt
- `<template>/.claude/settings.local.json.example` — 闭环模式 Bash 白名单

方法论全文：[`autonomous-new-project-workflow`](https://github.com/lyrenleigh-code/Ohmybrain/blob/main/wiki/explorations/autonomous-new-project-workflow.md)

首例参考：UWAnet 重建（2026-04-21）。

---

## 经验回流

项目中沉淀的通用规则、技能或脚本改进，回写到本仓库的 `template/`：

```
项目实战 ─► 发现可复用模式 ─► 写到 ohmybrain-core/template/
       │
       └─► 跨项目知识 ─► 写到 ohmybrain/wiki/
```

新建项目派生时自动获得最新模板。

---

## 两个闭环

模板内置两条标准化工作流：

### 知识闭环

```
raw/ ──► /ingest ──► wiki/source-summaries/ ──► query ──► /promote ──► Hub wiki/
                                                               │
                                                               └──► 项目内 wiki/concepts/
```

### 开发闭环

```
01-spec(specs/active/<MOD>.md)
   │
   ▼
02-plan(plans/<MOD>.md)
   │
   ▼
03-implement(代码 + 测试)
   │
   ▼
04-validate(验证 + 同步 wiki + 归档 spec → archive/ + commit)
```

详见 `template/workflows/`。

---

## Hook Exit Code 策略

所有 `template/scripts/*.py` 遵循 Claude Code 的 exit code 契约：

| Exit | 含义 | 触发效果 |
|------|------|----------|
| **0** | 成功 / 优雅放行 | 继续执行，stdout 可见 |
| **1** | 非阻断错误 | stderr 显示给用户，继续执行 |
| **2** | 阻断错误 | stderr 喂回 Claude，阻止工具调用 |

**设计原则**：宽松优先（未知输入 exit 0 放行）、阻断谨慎（仅安全性/一致性被破坏时 exit 2）、提醒用 0 + stdout、Windows Terminal 下大量非 0 exit 注意 tab 累积。

**当前阻断型 hook**：`check_raw_write.py` / `check_private_tags.py` / `check_index_log_sync.py`

---

## 派生项目状态（2026-05-25）

### template-engineering 派生

| 项目 | 派生时间 | 路径 | 状态 |
|------|----------|------|------|
| UWAcomm | 早期 | `D:\Claude\TechReq\UWAcomm` | 🟢 活跃（14 模块 / 6 体制 / 286 commits） |
| USBL | 早期 | `D:\Claude\TechReq\USBL` | 🟢 活跃（19 模块 / 4 线 / D-OQ-X 跨项目回流） |
| UWAnet | 早期 | `D:\Claude\TechReq\UWAnet` | 🟡 Phase 1（M0+M1 装机三件套已 push） |
| UWAcomm_usbl 🔒 | 2026-04-25 | `D:\Claude\TechReq\UWAcomm_usbl` | 🟢 活跃（V0.8 大纲 / 整机原型） |

### template-tool 派生

| 项目 | 派生时间 | 路径 | 状态 |
|------|----------|------|------|
| FlowGen 🔒 | 2026-04-23 | `D:\Claude\Tools\FlowGen` | 🟢 活跃（7 skill 实装 / Visio + Mermaid 双模式） |
| AnthropicPPT 🔒 | 2026-05-23 | `D:\Claude\Tools\AnthropicPPT` | 🟡 起步（design_tokens + helpers 已就绪，layouts/ 待封装） |

### template-document 派生（全私人）

| 项目 | 派生时间 | 路径 | 状态 |
|------|----------|------|------|
| Pricing 🔒 | 早期 | `D:\Claude\DocProcess\Pricing` | 🟢 私人活跃（git）|
| UWAprojDoc 🔒 | 2026-04-28 | `D:\Claude\DocProcess\UWAprojDoc` | 🟢 v17 final（非 git）|
| CooperativeDetection 🔒 | 2026-05-08 | `D:\Claude\DocProcess\CooperativeDetection` | 🟢 活跃（非 git）|
| PaperReview 🔒 | 2026-05-09 | `D:\Claude\DocProcess\PaperReview` | 🟢 活跃（非 git）|
| DigitalTwinGuide 🔒 | 2026-05-13 | `D:\Claude\DocProcess\DigitalTwinGuide` | 🟢 首版完成（非 git）|
| DigitalTwin1plusN 🔒 | 2026-05-25 | `D:\Claude\DocProcess\DigitalTwin1plusN` | 🟡 起步（非 git，新派生）|

🔒 = 内网 GitLab Internal 可见或本地私人，不公开。所有 git 远端项目主分支统一为 `main`（2026-05-25 完成迁移，UWAcomm 同步）。

---

## 远端

- **GitHub**：https://github.com/lyrenleigh-code/ohmybrain-core
- **GitLab 内网**：http://192.168.10.100:8880/lilin/ohmybrain-core

双推同步。

---

## 许可

内部项目，仅供本人 + 授权内部协作者使用。
