# 新项目启动 SOP

## 0. 先选启动模式

**本 SOP 有两条路径**，动手前先选：

| 你的情况 | 模式 | 走 |
|---|---|---|
| 目标清晰 + rubric 可量化 + 想省时间 | **闭环** | §1 派生 + §8 启动（跳过 §2-7 的手动编辑）|
| 探索性研究 / 长周期 / 需深度理解 | **手动** | §1-7 走完 |
| 不确定 / 先试试 | **混合**：闭环跑 M0-M1，M2+ 切手动 | §1 + §8，M1 通后再回 §2-7 收尾 |

### 模式判据

**闭环适合**：
- 目标一句话讲得清
- 有**机器可判的 rubric**（命令 / grep 命中数 / 文件存在 / 数值阈值 / exit code）
- 外部依赖可锁版本
- 项目是"从零到 M1"冷启动，有明确交付物

**手动适合**：
- 项目探索性强、目标还在摇摆（如 UWAcomm 多体制联合仿真）
- 长周期迭代（几个月到几年）
- 需要人**深度理解**（文献阅读、算法调试）
- 主导动作是"理解"而非"产出"

**混合最现实**：闭环擅长"从零到 M1 冷启动"，手动擅长"M1 之后的持续推进"。UWAnet 首例就是混合：闭环把脚手架+PRD+环境装机一次性搞定，M2+ 切回手动做源码阅读。

### 模式差异速查

| 维度 | 手动 | 闭环 |
|---|---|---|
| 谁推进 Phase 3-4 | 人 | Agent（你只在 Phase 0 / 5 confirm）|
| 输入主体 | 人的判断 + 调研 | goal.yaml + rubric |
| 产出主体 | 按节奏迭代 spec/plan/code | 一次性 PRD + M1 装机 |
| 成本模式 | 分摊到月/季度 | 集中 ~$5-10 / 1-2 小时 |
| 成功判据 | 人感觉够了 | Evaluator 打分 ≥ 80 |
| 前置 | §2-7 的手动编辑 | goal.yaml + `.claude/settings.local.json` |

两种模式都从同一个 `ohmybrain-core/template/` 派生；差异只在于**是否启用 `prompts/` 套件和 `settings.local.json`**。

**方法论全文**：`D:/Claude/Ohmybrain/wiki/explorations/autonomous-new-project-workflow.md`

---

## 前置条件

- Python 3.10+ 已安装（`python --version`）
- Git 已安装
- Obsidian 已安装（可选但推荐）

## 步骤

### 1. 从模板派生

```bash
# 创建项目目录
mkdir -p D:\Claude\TechReq\新项目名

# 复制模板内容（单条命令覆盖全部含隐藏目录）
cp -r D:/Claude/ohmybrain-core/template/. D:/Claude/TechReq/新项目名/
```

等效但显式的分步版本（若 shell 不支持 `.` 结尾）：

```bash
cd D:\Claude\ohmybrain-core
cp -r template/.claude     D:\Claude\TechReq\新项目名/
cp -r template/.obsidian   D:\Claude\TechReq\新项目名/
cp -r template/.github     D:\Claude\TechReq\新项目名/
cp -r template/wiki        D:\Claude\TechReq\新项目名/
cp -r template/raw         D:\Claude\TechReq\新项目名/
cp -r template/scripts     D:\Claude\TechReq\新项目名/
cp -r template/workflows   D:\Claude\TechReq\新项目名/
cp template/CLAUDE.md      D:\Claude\TechReq\新项目名/
cp template/.gitignore     D:\Claude\TechReq\新项目名/
```

### 1.5. 补齐 Phase 1 必需空目录（template 未含）

CLAUDE.md 的"目录地图"声明了 `specs/ plans/ src/ tests/ evals/`，但 template 未带。显式补齐：

```bash
cd D:\Claude\TechReq\新项目名
mkdir -p specs/active specs/archive plans src tests evals
```

**若走闭环模式**（使用 Hub `projects/<slug>/prompts/` 下的 goal.yaml 套件），额外补：

```bash
mkdir -p raw/seed prompts .checkpoint
```

> **发现来源**：2026-04-21 UWAnet-Redo Phase 1 dry-run 暴露（见 Ohmybrain `wiki/explorations/autonomous-new-project-workflow.md` §Pitfalls）。

### 2. 配置 CLAUDE.md

编辑 `CLAUDE.md`，机器可验地替换占位符（**建议 Jinja 风格**，scaffold-agent 可规则化处理）：

| 占位符 | 含义 | 示例 |
|---|---|---|
| `{{PROJECT_NAME}}` | 项目全名 | UWAnet |
| `{{PROJECT_SLUG}}` | 小写短名 | uwanet |
| `{{PROJECT_DESCRIPTION}}` | 一句话描述 | 水声通信组网协议仿真 |
| `{{DEPENDS_ON}}` | 依赖项目（可多） | UWAcomm |

过渡期（当前 template 仍用自然语言占位符）也必须手动替换：

- 项目名称段（当前占位符：`（从 ohmybrain-core 模板派生，请替换为实际项目名）`）
- 目录地图（按项目实际目录调整）
- 常用命令（添加项目特有命令）
- Hooks 表（若使用非默认 hook，同步更新）

**验证占位符已全清**：

```bash
! grep -qE "请替换|\\{\\{[A-Z_]+\\}\\}" CLAUDE.md && echo "placeholders: OK"
```

### 3. 初始化 Git

```bash
cd D:\Claude\TechReq\新项目名
git init
git add .
git commit -m "init: 从 ohmybrain-core 模板初始化"
```

### 4. 注册到 Ohmybrain Hub

在 `D:\Claude\Ohmybrain\projects\` 下创建导航页：

```bash
mkdir -p D:\Claude\Ohmybrain\projects\新项目名
```

创建 `README.md`：

```markdown
# 新项目名

> 一句话描述

- **仓库**：D:\Claude\TechReq\新项目名
- **状态**：活跃开发中
```

更新 `D:\Claude\Ohmybrain\CLAUDE.md` 的项目仓库映射表。

### 5. 配置 .env（如需要）

如果项目用到 Firecrawl 抓取或其他 API：

```bash
echo "FIRECRAWL_API_KEY=your_key" > .env
```

### 6. 验证

```bash
# 结构完整
test -d .claude && test -d wiki && test -d raw && test -d specs/active && test -d plans && echo "dirs: OK"

# 占位符已清空
! grep -qE "请替换|\\{\\{[A-Z_]+\\}\\}" CLAUDE.md && echo "placeholders: OK"

# 脚本通过
python scripts/lint_wiki.py        # 应该通过
python scripts/validate_task.py    # 应该通过
python scripts/sync_index.py       # 应该显示 0 页面
```

**若走闭环模式**，额外检查：

```bash
test -f goal.yaml && test -d raw/seed && test -d prompts && echo "closed-loop dirs: OK"
```

### 7. 在 Obsidian 中打开（可选）

D:\Claude 已注册为 Obsidian vault，新项目会自动可见。

## 8. 闭环模式启动流程（与 §2-7 二选一，见 §0 选择）

> 前置：已执行 §1 从模板派生。本节替代 §2-7 的手动编辑。

本模板自带完整闭环驱动套件（`prompts/` + `.claude/settings.local.json.example`）。

### 启动

```bash
# 1. 在独立 worktree 启动（不污染主仓）
mkdir -p D:/Claude/worktrees/<project_slug>-redo
cp -r D:/Claude/ohmybrain-core/template/. D:/Claude/worktrees/<project_slug>-redo/

# 2. 补齐闭环附加目录
cd D:/Claude/worktrees/<project_slug>-redo
mkdir -p raw/seed prompts .checkpoint

# 3. Phase 0 填 goal.yaml
cp prompts/goal.yaml.tpl goal.yaml
# 编辑：替换所有 {{PLACEHOLDER}}，填 seed_materials / rubric.first_sprint

# 4. 激活 Bash 白名单（闭环必需，修 Pitfall #7）
cp .claude/settings.local.json.example .claude/settings.local.json
```

### 后续 Phase 1-6

按 **方法论**执行：`D:/Claude/Ohmybrain/wiki/explorations/autonomous-new-project-workflow.md`

核心 Agent 调用模式见 `prompts/README.md`。

### 实测成本（UWAnet 首例）

| 全闭环 | 时间 | Token | 费用 |
|---|---|---|---|
| Phase 0-5 dry-run（含真装机）| ~75 min | ~530k | ~$7 |

### 何时**不**用闭环模式

- 项目探索性强、目标摇摆
- 短平快单一任务（小工具、单个 bug fix）
- 没有可机器判的 rubric（无法验收）

---

## 日常工作流

```
新资料 → raw/（只读存储）
       → /ingest-source（提炼到 wiki/）
       → wiki/index.md + wiki/log.md 同步更新

新功能 → specs/active/（写 spec）
       → plans/（写计划）
       → src/（实现）
       → tests/（测试）
       → wiki/（更新知识）

有价值结论 → /promote-answer（写回 Ohmybrain Hub wiki）
```
