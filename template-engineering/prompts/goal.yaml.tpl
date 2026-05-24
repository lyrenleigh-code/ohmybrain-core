# ==============================================================================
# goal.yaml.tpl — 闭环驱动文件模板
#
# 使用：
#   1. cp 到 worktree 根目录 as goal.yaml
#   2. 替换所有 {{PLACEHOLDER}}
#   3. 填 seed_materials / cross_project_refs / rubric.first_sprint 按项目定义
#   4. 完整参考示例：D:/Claude/Ohmybrain/projects/uwanet/prompts/goal.yaml
#
# 方法论：D:/Claude/Ohmybrain/wiki/explorations/autonomous-new-project-workflow.md
# ==============================================================================
schema_version: "1.0"

project:
  name: {{PROJECT_NAME}}               # 例：UWAnet
  slug: {{PROJECT_SLUG}}               # 例：uwanet
  type: {{PROJECT_TYPE}}               # research-simulation / web-app / library / cli-tool
  domain: {{PROJECT_DOMAIN}}
  description: |
    {{PROJECT_DESCRIPTION}}            # 2-3 句话定性
  tech_stack:
    primary: [{{TECH_STACK}}]          # 例：[ns-3, Aqua-Sim-NG]
    languages: [{{LANGUAGES}}]
    os: [{{OS}}]
  depends_on: []                       # TODO: 按实际依赖填
    # - project: {{DEP_NAME}}
    #   role: {{DEP_ROLE}}
    #   path: {{DEP_PATH}}

# ------------------------------------------------------------------------------
# 路径（Phase 1 后所有 agent 只读 worktree 内副本）
# ------------------------------------------------------------------------------
paths:
  worktree_root: {{WORKTREE_ROOT}}     # 例：D:/Claude/worktrees/{{PROJECT_SLUG}}-redo
  hub_root: D:/Claude/Ohmybrain
  template_root: D:/Claude/ohmybrain-core/template
  seed_dir: raw/seed
  spec_dir: specs/active
  plan_dir: plans

# ------------------------------------------------------------------------------
# 种子材料 & 交叉引用（按项目填，可为空）
# ------------------------------------------------------------------------------
seed_materials: []
  # - src: {{ABSOLUTE_SEED_PATH}}
  #   dst: raw/seed/{{FILENAME}}
  #   role: {{ROLE}}

pre_ingested_summaries: []
  # - {{HUB_OR_PROJECT_WIKI_PATH}}     # 已 ingest 的 summary，可跳 Phase 2

cross_project_refs: []
  # - path: {{PROJECT_WIKI_INDEX}}
  #   role: {{ROLE}}

# ==============================================================================
# Rubric v2（2026-04-21 升级，4 项新约束，通用部分保留）
# 项目特定的 first_sprint 段见本段末尾
# ==============================================================================
rubric:
  planner_output:
    charter_completeness:
      required_sections: ["## 项目定位", "## 范围界定", "## 非目标", "## 成功标准"]
      success_criteria_rules:
        - "每条必须独立可判"
        - "禁止循环引用 Planner / Evaluator 自评"
      weight: 15
    architecture:
      required_items:
        - "架构图 ≥ 5 层 / 5 模块（Mermaid 或 ASCII）"
        - "每层 / 每模块选型理由"
        - "与外部依赖的接口定义（≥ 1 张表格或图）"
      interface_table_rules:
        - "每行必须是接口/信号"
        - "禁止混入内部参数等无关项"
      weight: 25
    milestones:
      min_count: 4
      required_per_milestone: ["exit_criteria", "依赖", "预估工时"]
      exit_criteria_format:
        allowed: ["具体命令", "文件路径存在检查", "grep 命中数", "数值阈值", "exit code"]
        forbidden: ["散文化要求（如 '回答两问' / '理解透' / '讨论清晰'）"]
        penalty_per_violation_pct: 10
      weight: 20
    risks:
      min_count: 5
      required_categories: [技术风险, 外部依赖, 时间风险]
      weight: 15
    dependencies:
      must_identify: []                # TODO: 项目关键依赖 slug 数组
      weight: 10
    traceability:
      must_cite_seed: true
      min_wikilinks: 5
      wikilink_resolvable: fs
      bare_wikilink_penalty_pct: 10
      dead_link_penalty_pct: 10
      weight: 15
    pass_threshold: 80

  # ----------------------------------------------------------------------------
  # first_sprint — 首个里程碑（M1）的具体验收 rubric，必须项目化
  # 示例：见 UWAnet goal.yaml 的 m1_environment 段
  # ----------------------------------------------------------------------------
  first_sprint: {}
    # setup_script:
    #   path: src/setup/{{SETUP_SCRIPT_PATH}}
    #   must_contain: [{{KEY1}}, {{KEY2}}]
    # smoke_test:
    #   path: tests/smoke/{{SMOKE_PATH}}
    #   exit_code: 0
    #   must_output_keys: [{{KEY}}]
    # documentation:
    #   path: workflows/01-{{TOPIC}}.md
    #   min_lines: 30
    #   must_reference: [{{WIKI_SUMMARY}}]
    # pass_threshold: 90

# ------------------------------------------------------------------------------
# 预算 + 模型分配（2026-04-21 UWAnet 实测值调整）
# ------------------------------------------------------------------------------
budget:
  tokens_total: 500000                 # 实测全闭环 ~530k（原 300k 偏紧，上调）
  usd_max: 10.00                       # 实测全闭环 ~$7
  wall_clock_min: 90
  max_iterations_per_phase: 3
  convergence_delta_min: 5
  stale_iterations_kill: 2

models:
  scaffold: claude-haiku-4-5
  ingest: claude-sonnet-4-6
  planner: claude-opus-4-7
  generator: claude-sonnet-4-6
  evaluator: claude-sonnet-4-6
  registrar: claude-haiku-4-5

thinking:
  planner_budget: 20000
  generator_budget: 8000
  evaluator_budget: 4000

# ------------------------------------------------------------------------------
# 红线
# ------------------------------------------------------------------------------
red_lines:
  never_touch: []                      # TODO: 绝对路径数组，如主项目仓、Hub raw/
    # - D:/Claude/TechReq/{{MAIN_REPO}}
    # - D:/Claude/Ohmybrain/raw
  never_execute:
    - "git push"
    - "rm -rf"
    - "git reset --hard"
    - "sudo"
  confirm_before:
    - "commit to main"
    - "write Ohmybrain/projects/"
    - "edit Ohmybrain/CLAUDE.md"

# ------------------------------------------------------------------------------
# 升级 + 通知
# ------------------------------------------------------------------------------
escalation:
  channels: [PushNotification]
  checkpoint_path: .checkpoint/
  snapshot_on: [iteration_exceed, budget_warn, rubric_fail_3x]
  stop_on_uncertainty:
    rubric_ambiguous: ask_user_question
    seed_incomplete: halt_and_notify
    external_dep_missing: halt_and_notify

notify:
  on_complete:
    summary_path: run-report.md
    include: [壁钟时间, token 消耗, USD 消耗, 迭代次数, rubric 最终分]
  on_failure:
    include: [失败阶段, 最后产物路径, checkpoint 路径, 建议人工操作]
