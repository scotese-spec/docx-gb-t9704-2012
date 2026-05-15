# 公文skills（GB/T 9704-2012）

[![Version](https://img.shields.io/badge/version-5.2.0-blue)](SKILL.md)
[![Standard](https://img.shields.io/badge/standard-GB%2FT%209704--2012-green)](references/)
[![License](https://img.shields.io/badge/license-MIT-orange)](LICENSE)

> 一个 AI 技能文件。加载后 AI 就能按国标写党政机关公文——你只需说"文种 + 事由"，它出排版完成的 .docx。

---

## 这是什么

一个 `.md` 文件（`SKILL.md`）加上配套的参考资料和工具脚本。支持 OpenCode / Claude Code / OpenClaw 等 AI 平台加载。

加载后，AI 掌握：15 种公文的写作框架、GB/T 9704-2012 排版规范、公文用语、标点数字规范、格式自检修复。

---

## 文件结构

```
├── SKILL.md                      AI 技能核心文件
├── references/                   深度参考
│   ├── document-types.md         15种文种写作指南
│   ├── writing-language.md       公文用语规范
│   ├── writing-techniques.md     写作技巧
│   ├── punctuation-numbers.md    标点数字规范
│   ├── political-terms.md        规范词汇速查
│   ├── common-mistakes.md        常见错误纠正
│   └── font-install.md           字体安装指引
├── checklists/
│   └── quality-checklist.md      100+ 质量检查项
├── scripts/
│   ├── analyzer.py               格式诊断
│   └── punctuation.py            标点修复
├── templates/                    16种文种 Markdown 模板
├── presets/custom.json           格式预设
└── LICENSE                       MIT
```

---

## 支持文种

通知、报告、请示、批复、函、会议纪要、命令、决定、决议、公报、公告、通告、通报、意见、议案（共 15 种）。

---

## 排版规格

生成的 .docx 依 GB/T 9704-2012：

- 页面 A4，页边距上 3.7 / 下 3.5 / 左 2.8 / 右 2.6 cm
- 标题二号小标宋体居中，正文三号仿宋首行缩进 2 字
- 一级标题黑体加粗，二级标题楷体加粗
- 行距固定值 28 磅
- 版头红头发文机关标志 + 发文字号 + 红色分隔线
- 版记抄送机关 + 印发机关和日期
- 页码一字线格式（— 1 —），奇右偶左

---

## 可能帮助到的人

党政机关文秘、国企事业单位行政人员、公文写作初学者。

---

## 致谢

参考以下开源项目：

- [xkonglong/gw](https://github.com/xkonglong/gw) — 小恐龙公文排版助手
- [KaguraNanaga/official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill) — AI 公文写作 Skill
- [cj0103/gbt-9704-2012-skills](https://github.com/cj0103/gbt-9704-2012-skills) — 格式诊断/标点修复工具

遵循 GB/T 9704-2012 · GB/T 15834 · GB/T 15835 · 中办发〔2012〕14号
