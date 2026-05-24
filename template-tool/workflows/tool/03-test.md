# 03 · test（demo 验证）

工具开发闭环 step 03。

## 触发

implement 完成。

## 产出

`output/sample/` 下至少 1 个**跑通的 demo**：

- 真实输入 + 真实输出
- 覆盖 spec 中验收 demo 场景
- demo 输出文件 commit 到 git（让用户能直接看效果）

## 验证步骤

1. `python templates/examples/<demo>.py` → 检查 exit code
2. 打开 output/sample/<output> → 视觉 / 逻辑检查
3. 如果是 PPT / docx / vsdx → 用对应工具打开看效果
4. 边界场景测试（空输入 / 错误输入 / 大输入）

## 边界

- demo 必须**可复现**：脚本 + 输入 + 输出齐
- demo 不依赖具体业务数据（generic 化）
- 失败 → 回 step 02 implement 修

## 完成判定

- demo 跑通无 error
- 输出文件在 git 中可访问
- 输出文件视觉 / 逻辑通过用户审查
