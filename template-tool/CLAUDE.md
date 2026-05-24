# CLAUDE.md

> **Hub**: `D:\Claude\Ohmybrain` — 跨项目知识中心（查询领域知识/回流结论用 `/promote`）
> **模板**: `D:\Claude\ohmybrain-core` — 项目模板源（template-tool 类型）

## 项目名称

{{PROJECT_NAME}} — {{PROJECT_DESCRIPTION}}

<!--
占位符清单（scaffold 时替换）：
- {{PROJECT_NAME}}         项目全名，如 AnthropicPPT / FlowGen
- {{PROJECT_SLUG}}         小写短名
- {{PROJECT_DESCRIPTION}}  一句话描述
- {{DEPENDS_ON}}           依赖项目（可多，逗号分隔）
项目类型：**工具类（tool）** — 主交付物 可复用 skill / template
验证：! grep -qE "\{\{[A-Z_]+\}\}" CLAUDE.md && echo "placeholders: OK"
-->

## 关联项目

- 依赖：{{DEPENDS_ON}}

## 不可违反的规则

- 不得修改 `raw/` 下的文件，除非用户明确要求
- 优先更新 `wiki/` 而非在对话中重复分析
- 非平凡实现先在 `plans/` 写计划
- 工具开发先在 `specs/active/` 定义接口 / 参数 / 输出形态
- 知识变更必须同步更新 `wiki/index.md` 和 `wiki/log.md`
- **本项目仅作模板 / skill 库，不在自身生成具体业务产出** — 用户项目的产出走用户项目自己的 output/

## 项目类型

**Tool / 工具类**：主交付物 = 可复用 skill (`~/.claude/skills/<name>/SKILL.md`) + template 套件。

详见 `Ohmybrain/wiki/architecture/project-types.md` § Type 3。

## 目录地图

| 目录                | 职责                            |
| ----------------- | ----------------------------- |
| `raw/`            | 只读原始资料（参考文献 / 设计源）         |
| `wiki/`           | 项目知识层（概念、架构、源摘要）         |
| `specs/active/`   | 当前任务 spec（接口设计 / 参数定义）     |
| `specs/archive/`  | 已完成 spec                     |
| `plans/`          | 实现计划                         |
| `templates/`      | **主产出**（模板源码 + design tokens + helpers + layouts）|
| `output/sample/`  | 演示输出（demo PPT / demo flow / 等） |
| `scripts/`        | 自动化脚本                       |
| `workflows/`      | 操作流程文档（knowledge + tool）   |
| `.claude/`        | harness（rules/skills/hooks）  |
| `.obsidian/`      | Obsidian vault 配置 + wiki 页面模板 |

> ⚠️ 不需要 `src/` `tests/` `evals/`（轻量工具，验证靠 sample/）

## 两个闭环

### 知识闭环

```
raw/（参考 / 设计源）→ /ingest → wiki/source-summaries/ → query 复用
```

### 工具开发闭环（5 步，替代 engineering 闭环）

```
01-design → 02-implement → 03-test → 04-register-skill → 05-docs
                                            ↓
                                    skill 注册到 ~/.claude/skills/<name>/
```

详见 `workflows/tool/`。

## Skill 注册流程

工具产出的 skill 注册到 **全局** `~/.claude/skills/<name>/SKILL.md`：

- `name`: 与项目 slug 一致或更具体
- `description`: 含**关键词触发短语**（如"PPT / 幻灯片 / 演讲"）
- 引用本项目 `templates/` 路径作为实现源
- 在 wiki/architecture/design-system.md 记录设计 token

## 自动化保障（Hooks）

| 时机 | 检查内容 | 脚本 |
|------|---------|------|
| PreToolUse（Edit/Write） | 拦截 raw/ 写入 | `scripts/check_raw_write.py` |
| PreToolUse（Edit/Write） | 拦截 `<private>` 标签外泄 | `scripts/check_private_tags.py` |
| PostToolUse（Edit/Write） | Wiki 结构快速检查 | `scripts/lint_wiki.py --quick` |
| Stop | Wiki index/log 同步检查 | `scripts/check_index_log_sync.py` |
| Stop | 任务完整性验证 | `scripts/validate_task.py` |

## 常用命令

| 命令 | 用途 |
|------|------|
| `python scripts/lint_wiki.py` | Wiki 结构检查 |
| `python scripts/sync_index.py` | 同步 index 页面计数 |
| `python scripts/validate_task.py` | 任务完成验证 |
| `python templates/examples/<demo>.py` | 跑 demo 验证 |

## Hook Exit Code Strategy

参考 template-engineering/CLAUDE.md § Hook Exit Code Strategy（与其他模板一致）。

## 完成标准

- skill 已注册到 `~/.claude/skills/<name>/SKILL.md`
- templates/ 下模板源码 + helpers + design tokens 齐备
- output/sample/ 下至少 1 个跑通的 demo
- wiki/architecture/design-system.md 记录设计决策
- 最终回复明确说明变更内容
