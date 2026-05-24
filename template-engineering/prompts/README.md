# prompts/ — 闭环驱动套件（模板）

自主新建项目闭环的完整驱动：goal.yaml 权威源 + Planner/Evaluator prompt 协议。

**方法论全文**：`D:/Claude/Ohmybrain/wiki/explorations/autonomous-new-project-workflow.md`

## 文件

| 文件 | 用途 | 何时用 |
|---|---|---|
| [goal.yaml.tpl](goal.yaml.tpl) | 闭环权威驱动（Jinja 占位符） | Phase 0 人工填写 |
| [planner.md](planner.md) | `gan-planner` 的工作协议 | Phase 3 启动 Planner |
| [evaluator.md](evaluator.md) | `gan-evaluator` 的工作协议（含 v2 约束） | Phase 3/4 Evaluator |
| README.md | 本文件 | - |

## 启动流程

### Phase 0 — 人工填 goal.yaml

```bash
cp prompts/goal.yaml.tpl goal.yaml
# 编辑 goal.yaml，替换所有 {{PLACEHOLDER}}
```

**必填占位符**：
- `{{PROJECT_NAME}}` / `{{PROJECT_SLUG}}` / `{{PROJECT_TYPE}}` / `{{PROJECT_DOMAIN}}` / `{{PROJECT_DESCRIPTION}}`
- `{{TECH_STACK}}` / `{{LANGUAGES}}` / `{{OS}}`
- `{{WORKTREE_ROOT}}`

**可选填**：
- `seed_materials[]` — 种子资料
- `pre_ingested_summaries[]` — 已摘要的 wiki 页（跳 Phase 2）
- `cross_project_refs[]` — 交叉项目引用
- `rubric.dependencies.must_identify` — 关键依赖名
- **`rubric.first_sprint`** — 首个里程碑的具体验收（**项目化，必须填**）
- `red_lines.never_touch[]` — 绝对路径红线

### Phase 1 — 激活 Bash 白名单（修 Pitfall #7）

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

**闭环模式下必做**。否则 Evaluator 的 `bash -n` / `python` / `grep` 会被 deny，Verification Loop 退化为 code review。

### Phase 2-4 — 按方法论跑

核心 Agent 调用：

```
# Phase 3 Planner
Agent({
  subagent_type: "gan-planner", model: "opus",
  prompt: "按 <worktree>/prompts/planner.md 协议 + goal.yaml 执行..."
})

# Phase 3 Evaluator
Agent({
  subagent_type: "gan-evaluator", model: "sonnet",
  prompt: "按 <worktree>/prompts/evaluator.md 协议 + goal.yaml 执行..."
})

# Phase 4 Generator
Agent({
  subagent_type: "gan-generator", model: "sonnet",
  prompt: "按 goal.yaml.rubric.first_sprint 生成三件套..."
})
```

详细 prompt 示例：见 UWAnet 首次 dry-run 的启动 prompts（主会话历史）。

## 完整参考实例

UWAnet 首例（2026-04-21）：

- `D:/Claude/Ohmybrain/projects/uwanet/prompts/goal.yaml` — 填好的示例
- `D:/Claude/worktrees/uwanet-redo/` — 全套 worktree（specs/plans/src/tests）
- `D:/Claude/worktrees/uwanet-redo/run-report.md` — 实测数据
- `D:/Claude/Ohmybrain/wiki/log.md` §[2026-04-21] phase4-5 dry-run — 高层总结

## 实测预算（UWAnet 首例）

| 阶段 | 时间 | Token | 费用 |
|---|---|---|---|
| P3 两轮迭代 | 28 min | ~400k | ~$4.7 |
| P4 Gen+Eval | 8 min | ~140k | ~$1.2 |
| P4 真装机 | 45 min | - | - |
| **全闭环** | **75 min** | **~530k** | **~$7** |

## 本模板已规避的坑

- **#7 Bash 权限**：`.claude/settings.local.json.example` 随项目分发
- **#3 worktree 隔离**：`paths.worktree_root` 占位符强制
- **#2 rubric 模糊**：v2 rubric 已加 4 项硬约束（wikilink_resolvable / exit_criteria_format / success_criteria_rules / interface_table_rules）

## 待你注意的坑

- **#8 Upstream 兼容**：真装机才暴露；`rubric.first_sprint` 应加"最小装机验证"
- **#9 版本锁定**：upstream 依赖在 `rubric.first_sprint` 锁定到具体 tag

## 不适用场景

- 项目探索性强、目标摇摆 → 先做设计再考虑闭环
- 短平快单一任务 → 闭环太重
- 无明确 rubric（无验收标准） → 闭环无法收敛
