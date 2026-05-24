# 02 · implement（实现）

工具开发闭环 step 02。

## 触发

design 完成。

## 产出

`templates/` 下结构（约定）：

```
templates/
├── design_tokens.py        # 设计常量（颜色 / 字体 / 字号 / 网格）
├── helpers.py              # 通用辅助函数
├── layouts/                # （可选）多种布局 / 模式
│   ├── layout_a.py
│   └── layout_b.py
├── assets/                 # （可选）静态资源（图标 / 样板）
└── examples/               # （可选）参数化使用示例
    └── <demo>.py
```

## 边界

- 只放 templates/ 下的"可复用源码"，不直接生成业务产出
- 业务产出由用户项目自己的 output/ 承接
- 函数命名清晰，参数有 default value，错误信息友好

## 完成判定

- templates/ 结构齐备
- 函数 / 类有 docstring（至少一句）
- 至少 1 个 example 跑通（→ step 03 验证）
