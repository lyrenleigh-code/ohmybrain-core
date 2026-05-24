# 05 · docs（文档化）

工具开发闭环 step 05。

## 触发

skill 注册成功。

## 产出

1. **`wiki/architecture/design-system.md`**：记录设计决策、设计 token、关键 helpers 的设计理由
2. **`CLAUDE.md`**：项目类型、目录地图、设计哲学（user 看了能 onboarding）
3. **`README.md`**：对外接口 + 快速开始
4. **`wiki/concepts/`**：可选，记录工具中涉及的概念（如布局模式、生成算法等）
5. **wiki/log.md**：日期段记录注册的 skill + 主要 design 决策

## 边界

- 文档紧跟代码（CLAUDE.md 是源代码的"读者"入口）
- 不要写"将来要做什么"，写"现在长什么样" + "为什么这样"
- 维护成本：每次 implement 改动后必须更新对应文档

## 知识闭环回流

如果工具产出新概念 / 新方法论 → 考虑写到 Hub wiki：

```
项目 wiki → 评估跨项目可复用 → /promote-answer → Hub wiki
```

例如 AnthropicPPT 产出"FIELDBOOK 设计系统"作为通用 PPT 风格，可考虑 promote 到 Hub `wiki/concepts/fieldbook-design-system.md`。

## 完成判定

- CLAUDE.md + README.md + design-system.md 都齐备
- wiki/log.md 已记录本次工具开发
- 用户能从 README.md 开始上手
