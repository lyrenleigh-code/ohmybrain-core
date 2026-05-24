# CLAUDE.md

> **Hub**: `D:\Claude\Ohmybrain` — 跨项目知识中心（查询领域知识/回流结论用 `/promote`）
> **模板**: `D:\Claude\ohmybrain-core` — 项目模板源（template-document 类型）

## 项目名称

{{PROJECT_NAME}} 🔒 — {{PROJECT_DESCRIPTION}}

<!--
占位符清单（scaffold 时替换）：
- {{PROJECT_NAME}}         项目全名
- {{PROJECT_SLUG}}         小写短名
- {{PROJECT_DESCRIPTION}}  一句话描述
- {{DEPENDS_ON}}           依赖项目（可多，逗号分隔）
项目类型：**文档撰写类（document）** — 主交付物 docx / pdf 报告
验证：! grep -qE "\{\{[A-Z_]+\}\}" CLAUDE.md && echo "placeholders: OK"
-->

> 🔒 **私人边界**：DocProcess 系项目默认私人。禁止 `/promote` 公开 Hub wiki；禁止 push 公开远程仓库。需要跨项目复用必须先脱敏。

## 关联项目

- 依赖：{{DEPENDS_ON}}

## 不可违反的规则

- 不得修改 `raw/` 下的文件，除非用户明确要求
- 优先更新 `wiki/` 而非在对话中重复分析
- 每个文档任务先在 `specs/active/` 写章节大纲 / 验收点
- 非平凡撰写（多章节 / 跨模块）先在 `plans/` 写计划
- 文档章节 / 结构变更必须同步对应 `specs/active/` 下的 spec
- 知识变更必须同步更新 `wiki/index.md` 和 `wiki/log.md`
- 交付物不完整时不要停止
- **私人内容标 `<private>`** — hook 强制拦截外泄到公开 wiki

## 项目类型

**Document / 文档撰写类**：主交付物 = docx / pdf 报告 / 方案 / 评审意见。

详见 `Ohmybrain/wiki/architecture/project-types.md` § Type 2。

## 目录地图

| 目录              | 职责                            |
| ---------------- | ----------------------------- |
| `raw/`           | 只读原始资料（论文 / 文章 / 笔记 / 样板）  |
| `wiki/`          | 项目知识层（概念、专题、源摘要）           |
| `specs/active/`  | 当前任务 spec（章节大纲 + 验收点）       |
| `specs/archive/` | 已完成 spec                     |
| `plans/`         | 撰写计划（资料拉齐 / 章节顺序）            |
| `output/`        | **主交付物**（docx / pdf / vsdx 等成品） |
| `scripts/`       | 自动化（pandoc pipeline / 图件生成等）  |
| `workflows/`     | 操作流程文档（knowledge + document） |
| `.claude/`       | harness（rules/skills/hooks）  |
| `.obsidian/`     | Obsidian vault 配置 + wiki 页面模板 |

> ⚠️ 不需要 `src/` `tests/` `evals/`（本类型不写代码）。

## 两个闭环

### 知识闭环

```
raw/（资料源）→ /ingest → wiki/source-summaries/ → query 复用 → 项目 wiki
```

> 私人项目：**不走 `/promote-answer` 到 Hub**。跨项目复用必须先脱敏由用户手动操作。

### 文档撰写闭环（4 步，替代 engineering 闭环）

```
01-spec（章节大纲 + 验收点） → 02-draft（章节初稿） → 03-validate（自查 + 用户终审） → 04-archive
       └── archive 后弱触发新章节 spec ──┘
```

详见 `workflows/document/`。

## 出图工具

**必须**走 `flowgen-*` 8 skill 套件之一（按决策树分流）：

| 图类型 | Skill |
|--------|-------|
| 流程图（Mermaid 文本） | `flowgen` |
| 流程图（Visio .vsdx） | `flowgen-vsdx` |
| 分层架构图 | `flowgen-layered` |
| UML 时序图 | `flowgen-sequence` |
| 系统组成图 | `flowgen-composition` |
| 项目路线图 | `flowgen-roadmap` |
| 四化五层挂图 | `flowgen-archposter` |
| 图片复刻 | `flowgen-replica` |

**禁止** matplotlib mock / 手画 SVG。

## 自动化保障（Hooks）

| 时机 | 检查内容 | 脚本 |
|------|---------|------|
| PreToolUse（Edit/Write） | 拦截 raw/ 写入 | `scripts/check_raw_write.py` |
| PreToolUse（Edit/Write） | **拦截 `<private>` 外泄**（强约束！） | `scripts/check_private_tags.py` |
| PostToolUse（Edit/Write） | Wiki 结构快速检查 | `scripts/lint_wiki.py --quick` |
| Stop | Wiki index/log 同步检查 | `scripts/check_index_log_sync.py` |
| Stop | 任务完整性验证 | `scripts/validate_task.py` |

## 常用命令

| 命令 | 用途 |
|------|------|
| `python scripts/lint_wiki.py` | Wiki 结构检查 |
| `python scripts/sync_index.py` | 同步 index 页面计数 |
| `python scripts/validate_task.py` | 任务完成验证 |
| `python scripts/scrape.py <URL>` | Firecrawl 网页抓取到 raw/ |
| `python scripts/transcribe.py <文件>` | Whisper 音视频转录到 raw/ |

## Hook Exit Code Strategy

参考 template-engineering/CLAUDE.md § Hook Exit Code Strategy（与其他模板一致）。

## 完成标准

- 文档变更已完成
- 图件已生成（如需）
- wiki 已同步更新（如需要）
- output/ 下交付物已生成
- 最终回复明确说明变更内容
