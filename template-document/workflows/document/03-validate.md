# 03 · validate（自查 + 用户终审）

文档撰写闭环 step 03。

## 触发

draft 完成。

## 产出

更新 spec 的"验收"段落标 ✓ 或 ✗，附自查报告。

## 自查清单

- [ ] 字数 / 页数达标（per spec 验收点）
- [ ] 所有必含图件都已嵌入
- [ ] 引用源 wiki source-summary 已 cross-ref
- [ ] 无 `<private>` 标签外泄到公开内容
- [ ] 表格 / 公式 / 列表格式统一
- [ ] 错别字 / 标点 / 排版（pandoc 转换后再扫一遍）
- [ ] docx 在 Word 中打开看是否正常（页眉页脚 / 表格边框 / 字体）

## 用户终审

> ⚠️ **不代下"完成 / OK"结论**。文档质量由用户主观判定（参 [[../../../Ohmybrain/wiki/concepts/anti-patterns#build-阶段反模式]]）。

输出给用户：

- 完整 draft（output/<doc>.docx）
- 自查报告
- 已知未满足项（如有）
- 等用户明确说"通过 / 终审 OK / archive"才进 step 04

## 不通过怎么办

- 部分章节返工 → 回 step 02 draft 改局部
- 整篇结构问题 → 回 step 01 spec 重新规划
- 单个 fact 错 → 直接 patch + 重新 validate

## 完成判定

- 用户明确终审通过
