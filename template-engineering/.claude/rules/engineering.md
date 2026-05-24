---
paths:
  - src/**
  - modules/**
  - simulation/**
  - specs/**
  - plans/**
---

# 工程代码规则

- 每个代码任务必须先有 `specs/active/` 下的 spec，非平凡实现必须先有 `plans/` 下的计划
- 代码放在项目约定的代码目录中（具体目录见项目 CLAUDE.md）：
  - 模块化项目：`modules/xx/src/`
  - 仿真类项目：`simulation/{子目录}/`
  - 通用项目：`src/`
- 代码变更必须附带测试，或说明为何不需要
- 函数保持小而可测试，命名清晰
- 实现完成后更新模块 README（接口表、算法描述、测试覆盖、使用示例）
- 当模块接口或系统架构变化时，同步更新 wiki/
