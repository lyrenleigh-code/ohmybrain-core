# 04 · archive（归档）

文档撰写闭环 step 04。

## 触发

用户终审通过。

## 产出

- spec 从 `specs/active/` → `specs/archive/`（保留完整历史）
- output/<doc>.docx 标 final / 版本号（如 v17_final）
- wiki/log.md 追加变更日志条目

## 步骤

1. `git mv specs/active/<spec>.md specs/archive/<spec>.md`
2. output 下 final docx 重命名（如 `v17_final.docx`）
3. 更新 wiki/log.md：
   ```markdown
   ## [YYYY-MM-DD] document | <文档标题> v<N> 完成

   - spec archive: specs/archive/<spec>.md
   - 交付物: output/<doc>_v<N>_final.docx (<size>)
   - 总字数 / 章节 / 图件数量
   ```
4. wiki/index.md 同步更新（如有新页面）
5. `git add` + `git commit -m "docs(<area>): v<N> final"`

## 跨项目可复用结论？

如果本次文档产生跨项目可复用结论（如新的写作方法论 / 自动化 pipeline）：

- **私人项目**：不进公开 Hub，留在项目 wiki 或 `<private>` 标记后保存
- **公开项目**：评估是否走 `/promote-answer` 到 Hub wiki

## 弱触发新章节

archive 完成后，如有后续章节计划：

```
04 archive → (弱触发) → 01 spec 新章节
```

不是强依赖。如本次文档已完结，闭环关闭。

## 完成判定

- spec 在 archive 区
- output 标 final
- wiki log/index 同步
- commit 完成
