# 公文skills（GB/T 9704-2012）

[![Version](https://img.shields.io/badge/version-5.2.0-blue)](SKILL.md)
[![Standard](https://img.shields.io/badge/standard-GB%2FT%209704--2012-green)](references/)
[![License](https://img.shields.io/badge/license-MIT-orange)](LICENSE)

> 一个 AI 技能（Skill）：告诉 AI 你要写什么公文，它直接生成排版完成的 `.docx` 文件。
>
> 依据 GB/T 9704-2012《党政机关公文格式》国家标准，覆盖 15 种党政机关公文文种。

---

## 这是什么

这是一个给 AI 用的技能文件。把 `SKILL.md` 加载到支持的 AI 平台后，AI 就学会了怎么写党政机关公文——从格式排版到内容撰写，从版头红头到版记页码，全部按国标来。

**核心能力**：你只需告诉 AI 两件事——什么文种、什么事由，它直接输出一个排版完成的 `.docx` 文件，在 Word 或 WPS 里打开就能用。

如果运行环境没有安装 `python-docx`，AI 会自动降级为结构化的 Markdown 文本输出。

### 推荐平台：LobsterAI

[LobsterAI](https://github.com/netease-youdao/LobsterAI)（网易有道出品，5.2k⭐）是一个桌面端 AI 助手，Windows 版内置 Python 运行环境，支持通过 QQ/微信/钉钉远程控制。

**安装本技能到 LobsterAI**：
1. 将本仓库整个目录复制到 LobsterAI 的 `SKILLs/` 文件夹
2. 编辑 `SKILLs/skills.config.json`，在 `defaults` 中添加：`"gongwen": { "order": 11, "enabled": true }`
3. 重启 LobsterAI，即可对话使用

**其他兼容平台**：OpenCode、Claude Code、OpenClaw 均原生支持此技能格式。

---

## 怎么用

加载技能后，用自然语言告诉 AI：

### 从零草拟
```
"帮我写一份关于汛期安全生产检查的通知"
"起草请示，申请增加人员编制20名"
"拟一个函，请规划局支持项目立项"
```

AI 会：选文种 → 按框架写正文 → 套用 GB/T 9704 排版 → 输出 `.docx`。

### 模板参考
项目内置 16 种 Markdown 模板（`templates/` 目录），每种包含适用场景、结构框架和常用句式，AI 可以参照模板结构填充内容。

### 增量修改
```
"把第三段改成..."
"日期改成 2026年6月1日"
"在第二部分加一段关于XX的内容"
```

AI 读取已有 `.docx` → 定位段落 → 修改 → 保存。

### 迭代完善
多轮对话逐步打磨：先确认文种和标题 → 拟定正文结构 → 逐段充内容 → 加落款附件 → 最终输出。

### 格式检查
```bash
python scripts/analyzer.py 文件.docx
```
自动检测英文标点、层级跳跃、首行缩进缺失、字体问题等。

---

## 支持哪些文种

通知、报告、请示、批复、函、会议纪要、命令、决定、决议、公报、公告、通告、通报、意见、议案，共 15 种。

每种文种都有完整的写作框架（发文依据 → 主体事项 → 执行要求 → 结束语），详见 `references/document-types.md`。

---

## 排版规格

所有生成的 `.docx` 自动套用 GB/T 9704-2012 标准：

- 页面：A4，页边距上 3.7 / 下 3.5 / 左 2.8 / 右 2.6 cm
- 标题：二号小标宋体（22pt），居中
- 正文：三号仿宋（16pt），首行缩进 2 字
- 一级标题：三号黑体加粗；二级标题：三号楷体加粗
- 行距：固定值 28 磅
- 版头：红头发文机关标志 + 发文字号 + 红色分隔线
- 版记：抄送机关 + 印发机关和日期 + 分隔线
- 页码：一字线格式（— 1 —），四号宋体，奇右偶左

---

## 还有什么

- **规范词汇速查** (`references/political-terms.md`) — 常用政治规范表述，源自 www.gov.cn 真实公文
- **公文用语规范** (`references/writing-language.md`) — 四原则 + 100+ 句式 + 避讳词
- **写作技巧** (`references/writing-techniques.md`) — 标题拟定六查法、经验提炼四步法
- **标点数字规范** (`references/punctuation-numbers.md`) — GB/T 15834 + GB/T 15835
- **常见错误** (`references/common-mistakes.md`) — 80+ 条错例纠正
- **质量检查清单** (`checklists/quality-checklist.md`) — 100+ 项检查点
- **字体安装指南** (`references/font-install.md`) — 含 WPS 操作指引
- **Python 工具** (`scripts/`) — 格式诊断、标点修复

---

## 文件结构

```
├── SKILL.md                         AI 技能核心文件
├── references/                      深度参考文档
│   ├── document-types.md            15种文种写作指南
│   ├── writing-language.md          公文用语规范
│   ├── writing-techniques.md        写作技巧
│   ├── punctuation-numbers.md       标点数字规范
│   ├── political-terms.md           规范词汇速查
│   ├── common-mistakes.md           常见错误纠正
│   └── font-install.md              字体安装与WPS指引
├── checklists/
│   └── quality-checklist.md         100+质量检查项
├── scripts/
│   ├── analyzer.py                  格式诊断
│   └── punctuation.py               标点修复
├── templates/                       16种文种Markdown模板
├── presets/custom.json              可自定义格式预设
└── LICENSE                          MIT
```

---

## 可能帮助到的人

- 党政机关文秘人员 — 快速草拟规范公文
- 国企/事业单位行政人员 — 向上级报送请示/报告
- 公文写作初学者 — 学习标准格式和规范用语

---

## 致谢

本技能参考了以下优秀开源项目：

- [xkonglong/gw](https://github.com/xkonglong/gw) — 小恐龙公文排版助手 for Word/WPS
- [KaguraNanaga/official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill) — AI 公文写作 Skill
- [cj0103/gbt-9704-2012-skills](https://github.com/cj0103/gbt-9704-2012-skills) — 格式诊断/标点修复/排版工具

遵循标准：GB/T 9704-2012、GB/T 15834、GB/T 15835、中办发〔2012〕14号
