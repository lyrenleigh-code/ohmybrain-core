# 02 · draft（章节初稿）

文档撰写闭环 step 02。

## 触发

spec 完成并用户认可。

## 产出

`output/<doc>.docx` 或 `output/<doc>.md`（→ 后续 pandoc → docx）含：

- spec 中大纲对应章节
- 引用 wiki/source-summaries/ 内容（标 [[wikilink]]）
- 图件（走 flowgen-* skill 生成 + 嵌入）
- 表格、公式、列表按需

## 工具

| 内容 | 工具 |
|------|------|
| Markdown 主稿 | 直接 Edit |
| docx 导出 | `pandoc` 或 `scripts/build_docx.py`（项目定义） |
| 图件 | `flowgen-*` 8 skill 套件按决策树选 |
| 数据图 | matplotlib（仅算法/实验数据图，**不画流程图**） |

## 边界

- 不要在 raw/ 下创建文件
- `<private>` 内容不进 wiki/，留在 output/ 或本地
- 图件遵守"视觉差异化"约定（参 [[../../../Ohmybrain/wiki/concepts/anti-patterns#方案文档约定]]）

## 完成判定

- 大纲所有 section 都有内容
- 所有声明的图件都已生成
- output/ 下能找到初稿
