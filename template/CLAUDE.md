# CLAUDE.md

## 项目名称

（从 ohmybrain-core 模板派生，请替换为实际项目名）

## 不可违反的规则

- 不得修改 `raw/` 下的文件，除非用户明确要求
- 优先更新 `wiki/` 而非在对话中重复分析
- 每个代码任务先在 `specs/active/` 写 spec
- 非平凡实现先在 `plans/` 写计划
- 代码变更必须附带测试，或说明为何不需要
- 知识变更必须同步更新 `wiki/index.md` 和 `wiki/log.md`
- 交付物不完整时不要停止

## 目录地图

| 目录 | 职责 |
|------|------|
| `wiki/` | 项目知识层（概念、架构、模块、决策、摘要） |
| `specs/active/` | 当前任务 spec |
| `specs/archive/` | 已完成 spec |
| `plans/` | 实现计划 |
| `src/` | 源代码 |
| `tests/` | 自动化测试 |
| `evals/` | 评测 |
| `scripts/` | 自动化脚本 |
| `workflows/` | 操作流程文档 |
| `.claude/` | harness（rules/skills/hooks） |

## 两个闭环

### 知识闭环

```
raw/ → ingest → wiki/ → query → promote → wiki/
```

### 开发闭环

```
spec → plan → implement → test → validate → archive
```

## 常用命令

| 命令 | 用途 |
|------|------|
| `python3 scripts/lint_wiki.py` | Wiki 结构检查 |
| `python3 scripts/sync_index.py` | 同步 index 页面计数 |
| `python3 scripts/validate_task.py` | 任务完成验证 |

## 完成标准

- 代码变更已完成
- 相关测试通过
- wiki 已同步更新（如需要）
- 最终回复明确说明了变更内容
