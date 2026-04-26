# ohmybrain-core — 母仓 / 模板 / 通用 harness

> Ohmybrain Core — Project Template & Universal Harness
>
> 为所有项目提供统一的 Claude Code harness 模板，包含规则、技能、钩子、脚本和工作流。**所有新项目从此派生**。

---

## 三仓架构

```
ohmybrain-core（本仓库 / 母仓 / 模板）
  │
  ├──派生──► UWAcomm（水声通信仿真）
  ├──派生──► USBL（超短基线自定位）
  ├──派生──► UWAnet（组网协议仿真）
  ├──派生──► UWAcomm_usbl 🔒（联合仿真，内网）
  ├──派生──► FlowGen 🔒（Mermaid 流程图工具）
  └──派生──► Pricing 🔒（文档处理）

ohmybrain（知识库 + Hub）
  └── 跨项目知识沉淀（concepts / entities / explorations）
```

**三层职责**：

| 层 | 角色 | 仓库 |
|----|------|------|
| **core** | 模板 / harness 复用 | `ohmybrain-core` |
| **project** | 工程闭环 / 算法实现 | UWAcomm / USBL / UWAnet / ... |
| **hub** | 跨项目知识沉淀 | `Ohmybrain` |

详见 [Hub 三仓架构页](https://github.com/lyrenleigh-code/Ohmybrain/blob/main/wiki/architecture/system-overview.md)。

---

## 模板内容

| 目录 | 内容 |
|------|------|
| `template/.claude/rules/` | 4 条路径规则（wiki / raw / engineering / specs） |
| `template/.claude/skills/` | 5 个技能（ingest / plan / implement / lint / promote） |
| `template/.claude/commands/` | Slash commands（`/ingest`, `/promote`） |
| `template/.claude/settings.json` | Python 跨平台 hooks（Pre / Post / Stop） |
| `template/.obsidian/` | Obsidian vault 配置 + 5 个 wiki 页面模板 |
| `template/raw/` | 只读原始资料层（10 个子目录骨架） |
| `template/wiki/` | 知识层（index.md + log.md + concept/entity/architecture 模板） |
| `template/workflows/knowledge/` | 知识闭环 4 步（ingest → query → promote → review） |
| `template/workflows/engineering/` | 开发闭环 4 步（spec → plan → implement → validate） |
| `template/scripts/` | 7+ 个自动化脚本 |
| `template/.github/workflows/` | CI + wiki-check |
| `template/prompts/` | 自主新建项目闭环驱动套件（goal.yaml.tpl / planner / evaluator） |

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

### 方式 A：直接复制目录（旧方法）

```bash
cp -r template/.claude       新项目/
cp -r template/.obsidian     新项目/
cp -r template/.github       新项目/
cp -r template/wiki          新项目/
cp -r template/raw           新项目/
cp -r template/scripts       新项目/
cp -r template/workflows     新项目/
cp -r template/prompts       新项目/
cp template/CLAUDE.md        新项目/
cp template/.gitignore       新项目/
```

修改 `CLAUDE.md` 中的项目名称、目录地图、Hub 引用。

### 方式 B：新项目 SOP（推荐）

完整流程见 `docs/new-project-sop.md`：

```
1. 在 ohmybrain（Hub）的 projects/<slug>/ 下建占位
2. 拷贝 template/ 到目标路径
3. 填 CLAUDE.md 项目特有部分（slug / 路径 / 关联项目 / 启动模式）
4. （可选）填 prompts/goal.yaml 启用自主新建项目闭环
5. git init + 创建 GitHub/GitLab 远端
6. 第一次 commit + push 双推
```

### 方式 C：自主新建项目闭环（实验性）

适合"一行目标 → Phase 0-6 → M1 真装机"的场景：

- `template/prompts/goal.yaml.tpl` — 闭环权威驱动（Phase 0 人工填）
- `template/prompts/planner.md` / `template/prompts/evaluator.md` — agent prompt
- `template/.claude/settings.local.json.example` — 闭环模式 Bash 白名单

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

## 派生项目状态

| 项目 | 派生时间 | 路径 | 状态 |
|------|----------|------|------|
| UWAcomm | 早期 | `D:\Claude\TechReq\UWAcomm` | 🟢 活跃（14 模块 / 6 体制） |
| USBL | 早期 | `D:\Claude\TechReq\USBL` | 🟢 活跃（19 模块 / 4 线） |
| UWAnet | 早期 | `D:\Claude\TechReq\UWAnet` | 🟡 调研 |
| UWAcomm_usbl 🔒 | 2026-04-25 | `D:\Claude\TechReq\UWAcomm_usbl` | 🟢 起步（M0-M1） |
| FlowGen 🔒 | 2026-04-23 | `D:\Claude\Tools\FlowGen` | 🟡 起步 |
| Pricing 🔒 | 早期 | `D:\Claude\DocProcess\Pricing` | 🟢 私人 |

🔒 = 内网 GitLab Internal 可见，不公开。

---

## 远端

- **GitHub**：https://github.com/lyrenleigh-code/ohmybrain-core
- **GitLab 内网**：http://192.168.10.100:8880/lilin/ohmybrain-core

双推同步。

---

## 许可

模板与脚本可自由复用。`template/` 下示例内容仅供参考。
