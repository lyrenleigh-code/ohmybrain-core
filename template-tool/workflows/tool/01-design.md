# 01 · design（接口设计）

工具开发闭环 step 01。

## 触发

新工具想法 / 想从现有项目沉淀通用能力为 skill。

## 产出

`specs/active/YYYY-MM-DD-<slug>.md` 含：

- 工具名称 + 一句话描述
- 用户调用入口（关键词触发 / 显式 / 路径触发）
- 输入参数 + 输入形态
- 输出形态（文件 / docx / pptx / vsdx / 等）
- 与现有 skill 的边界（避免重复造）
- 验收 demo 场景（至少 1 个 input → 1 个 output）

## 边界

- 一个工具一个 skill，不做"瑞士军刀"
- 关键词触发短语先想清楚（用户怎么唤起？）
- 如果输出比 1 步多 → 拆成 helper + main skill

## 完成判定

- spec 被用户认可
- 与现有 skill 边界清楚
- 至少 1 个 demo 场景已定义
