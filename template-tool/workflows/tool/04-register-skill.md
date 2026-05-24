# 04 · register-skill（skill 注册）

工具开发闭环 step 04。

## 触发

test 通过。

## 产出

`~/.claude/skills/<name>/SKILL.md` 含：

```yaml
---
name: <slug>
description: <一句话 + 关键词触发短语>
keywords:
  - <关键词 1>
  - <关键词 2>
---

# <工具名称>

## 何时触发

用户提到任意以下：
- <关键词 / 短语>

## 项目路径

`D:\Claude\Tools\<ProjectName>\`

## 工作流程

Step 1: …
Step 2: …
Step N: …

## FIELDBOOK / 设计哲学（如适用）

…

## 反例 · 不要做的

- ❌ …

## 完成标准

- …
```

## 注册步骤

1. 决定 skill 名（kebab-case，与 templates/ 中函数命名风格一致）
2. 写 SKILL.md（用本项目 templates/ 作为实现源）
3. 把 SKILL.md 放到 `C:\Users\<user>\.claude\skills\<slug>\SKILL.md`
4. **重启 Claude Code** 让全局 skill 注册生效（关闭重开会话）
5. 测试触发：在新会话中说 "<关键词>" 看是否 skill 唤起

## 边界

- skill 触发关键词不要太宽泛（避免误触发）
- skill 内引用本项目路径必须用绝对路径 `D:\Claude\Tools\<name>\`
- skill 不能引用 raw/ 下私人数据

## 完成判定

- SKILL.md 已部署到 ~/.claude/skills/
- 关键词触发实测成功
- skill 在新会话中可用
