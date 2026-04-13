# 新项目启动 SOP

## 前置条件

- Python 3.10+ 已安装（`python --version`）
- Git 已安装
- Obsidian 已安装（可选但推荐）

## 步骤

### 1. 从模板派生

```bash
# 创建项目目录
mkdir -p D:\Claude\TechReq\新项目名

# 复制模板内容
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

### 2. 配置 CLAUDE.md

编辑 `CLAUDE.md`，替换以下内容：
- 项目名称
- 目录地图（根据项目实际目录调整）
- 常用命令（添加项目特有命令）

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
python scripts/lint_wiki.py        # 应该通过
python scripts/validate_task.py    # 应该通过
python scripts/sync_index.py       # 应该显示 0 页面
```

### 7. 在 Obsidian 中打开（可选）

D:\Claude 已注册为 Obsidian vault，新项目会自动可见。

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
