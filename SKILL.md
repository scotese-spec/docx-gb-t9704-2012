---
name: gongwen-skills-gb-t9704-2012
description: "公文skills（GB/T 9704-2012）。党政机关公文全流程技能。用户提供（1）公文类型+（2）事由内容，AI 直接生成排版完成的 .docx（python-docx可用时）或结构化 Markdown（降级模式）。支持模板填充、增量修改、迭代对话完善公文。涵盖：15种文种写作框架+版头版记页码生成+GB/T 9704全要素排版+公文用语规范+标点数字规范+100+质量检查+错误案例对比。WHEN: 写公文, 公文排版, 公文格式, 红头文件, 通知, 报告, 请示, 批复, 函, 纪要, 命令, 决定, 决议, 公报, 公告, 通告, 通报, 意见, 议案, 修改公文, 完善公文, 检查公文, 党政机关公文, GB/T 9704, 政府文件, 党委文件, 排版 docx, 公文模板."
license: MIT
metadata:
  version: "5.2.0"
  input: "公文类型 + 事由内容"
  outputs: [".docx (Word/WPS, 需 python-docx)", ".md (纯文本降级, 总是可用)", "文本预览 (每次生成后同步输出)"]
  modes: ["从零草拟", "分步确认", "模板填充", "增量修改", "迭代完善"]
  auto: "格式自检+自动修复"
  base_standard: "GB/T 9704-2012"
  acknowledgments:
    - "xkonglong/gw — Word/WPS插件功能参考"
    - "KaguraNanaga/official-document-writing-skill — 写作技巧与范例参考"
    - "cj0103/gbt-9704-2012-skills — 格式诊断/标点修复/排版工具参考"
---

# 党政机关公文技能

> **你只需告诉我：什么文种 + 什么事由。其余全部自动完成。**
>
> 依据 **GB/T 9704-2012**，输出排版完成的 .docx（Word/WPS 打开即用）。
> 如环境中缺少 python-docx，自动降级为结构化 Markdown 输出。

---

## 一、核心工作模式

### 四种模式

| 模式 | 触发方式 | AI 做什么 |
|------|---------|----------|
| **从零草拟** | "写一份通知，关于XX" | 选文种 → 写正文 → 排版 → 输出 .docx |
| **模板填充** | "用通知模板，写XX内容" | 读取 templates/*.md → 按结构填充 → 输出 .docx |
| **增量修改** | "把第三段删掉" "日期改成5月20日" | 读取已有 .docx → 定位 → 修改 → 保存 |
| **迭代完善** | 多轮对话逐步补充 | 保持上下文，每轮更新同一文件 |

### 迭代对话示例

```
用户: 写一份关于安全生产检查的通知
AI:    [生成 通知_草拟.docx，含标题+开头+四点要求+落款]
       已生成草拟版。请确认以下内容：
       - 发文机关：XX市人民政府？（请确认/修改）
       - 检查范围：全市？（请确认/修改）
       - 时间要求：即日起至7月15日？（请确认/修改）

用户: 发文机关改成市安委会，加上建筑施工、危化品两个重点领域
AI:    [修改 通知_草拟.docx，精确定位→替换→保存]
       已更新。新增变化：
       - 发文机关：XX市人民政府 → 市安委会
       - 新增"建筑施工领域"检查要点
       - 新增"危险化学品领域"检查要点

 用户: 把日期改成2026年6月1日，再附录一个检查表
AI:    [再次修改，追加附件说明]
        已更新。
```

### 分步确认模式（从零草拟时的推荐流程）

从零草拟复杂公文时，不要一口气生成全文，而是分步确认：

```
第1步：AI 先确认发文机关 + 文种 + 标题
         ↓ 用户确认
第2步：AI 拟定正文结构（一级标题）并展示
         ↓ 用户确认/修改
第3步：AI 逐段草拟正文
         ↓ 用户逐段确认/修改
第4步：AI 生成附件说明、落款、版记
         ↓ 用户确认
第5步：AI 输出完整 .docx + 运行 check() 自检
         ↓ 用户审阅，打开 Word 定稿
```

**触发方式**：说"分步草拟一份通知，关于XX"即可激活分步模式。

### 生成后文本预览

每次生成 .docx 后，AI 必须同时输出纯文本预览，让用户不开 Word 就能看到内容：

```
✅ 已生成: 通知_草拟.docx (3.7cm页边距, 28磅行距, 2字缩进)
────────────────────────────────────
关于做好2026年汛期安全生产检查工作的通知

各区县人民政府：
  当前我市已进入主汛期……
  一、提高政治站位……
  二、聚焦重点领域……
特此通知。
                              市安全生产委员会
                               2026年6月1日
────────────────────────────────────
共 12 段 / 标题22pt宋体 / 正文16pt仿宋 / 已通过格式自检
如内容需修改请告知，确认无误后可直接套印红头使用。
```

---

## 二、依赖检测与多格式输出

### 启动时自动检测

```python
try:
    from docx import Document
    HAS_DOCX = True
except ImportError:
    HAS_DOCX = False
```

### 输出策略

| 环境 | 输出格式 | 用户操作 |
|------|---------|---------|
| python-docx 可用 | **.docx** 文件 | 双击在 Word/WPS 打开，直接可用 |
| python-docx 不可用 | **.md 结构化文本** | 复制到 Word → 全选 → 设仿宋三号 → 设首行缩进 |

### python-docx 不可用时提示

```
⚠ 未检测到 python-docx，无法生成 .docx 文件。
  安装命令：pip install python-docx
  当前降级为 Markdown 输出，内容完整，可复制到 Word 后手动设置格式。
  需要我输出 Markdown 吗？或者先安装 python-docx 再重新生成？
```

### Markdown 降级格式

一个完整的公文用 Markdown 输出，保留结构信息：

```markdown
# 关于XXXX的通知

**主送**：各区县人民政府

为贯彻落实……现将有关事项通知如下：

## 一、提高政治站位
正文正文正文……

## 二、聚焦重点领域
正文正文正文……

**特此通知。**

附件：1. XXXXX

<div align="right">XX市人民政府</div>
<div align="right">2026年5月15日</div>
```

---

## 三、文种速选

| 我要…… | 用这个 | 关键特征 |
|--------|--------|---------|
| 向上级要批准/要钱/要人/要政策 | **请示** | 一文一事, 附联系人电话, 结语"妥否请批示" |
| 向上级汇报工作 | **报告** | 不能夹带请示, 上行文有签发人 |
| 向下级布置任务 | **通知** | 适用范围最广, "请遵照执行" |
| 答复下级请示 | **批复** | 必须先引用来文号, "收悉""此复" |
| 平级或不隶属单位沟通 | **函** | 商洽语气, "请予支持为盼" |
| 表彰先进/批评错误 | **通报** | "特此通报" |
| 重要决策/人事任免/奖惩 | **决定** | "自下发之日起施行" |
| 会议决策确认 | **决议** | "会议指出/认为/决定/号召" |
| 会议记录发布 | **纪要** | 含出席名单/议定事项 |
| 面向社会公开(重大) | **公告** | "特此公告" |
| 面向社会公开(一般) | **通告** | "特此通告" |
| 向人大提请审议 | **议案** | "现提请审议" |
| 发表重要观点/方案 | **意见** | 可上行可下行可平行 |

---

## 四、各文种写作框架

### 请示
```
发文机关标志（红头）
X请〔2026〕X号                    签发人：XXX
────────────────────────
关于 XXXXXX 的请示

[上级机关]：
  根据……/为……，现就有关事项请示如下：
  一、请示事由
  二、请示事项
  三、可行性说明
妥否，请批示。
附件：[如有]

[署名]
2026年X月X日
（联系人：XXX　电话：XXX）
```
> **铁律**：一文一事、一个主送、不得越级

### 报告
```
发文机关标志（红头）
X报〔2026〕X号                   签发人：XXX
────────────────────────
关于 XXXXXX 的报告

[上级机关]：
  根据……现将有关情况报告如下：
  一、工作进展
  二、主要做法
  三、存在问题（如有）
  四、下一步打算
特此报告。

[署名] / 2026年X月X日
```
> **铁律**：不夹带请示、上行文有签发人

### 通知
```
发文机关标志（红头）
X发〔2026〕X号
────────────────────────
关于 XXXXXX 的通知

[主送机关]：
  为……/根据……，现将有关事项通知如下：
  一、……
  二、……
  三、……
特此通知。
附件：[如有]

[署名]
2026年X月X日
```

### 批复
```
发文机关标志（红头）
X函〔2026〕X号
────────────────────────
关于 XXXXXX 的批复

[来文单位]：
  你局《关于……的请示》（X请〔2026〕X号）收悉。经研究，现批复如下：
  一、同意/原则同意/不同意……
  二、工作要求
此复。

[署名] / 2026年X月X日
```

### 函
```
发文机关标志（红头）
X府函〔2026〕X号
────────────────────────
关于 XXXXXX 的函

[主送机关]：
  为……/你单位《……》收悉，现函告如下：
  ……
此函。/请予支持为盼。/特此函复。

[署名] / 2026年X月X日
（联系人：XXX　电话：XXX）
```

### 纪要
```
XXXXXX 专题会议纪要
XX专纪〔2026〕X号

时间：2026年X月X日
地点：XXX会议室
主持：XXX
出席：XXX、XXX
列席：XXX
记录：XXX

议定事项：
  一、……
  二、……
  三、……

 出席人员名单：[略]
```
> 纪要不写主送机关。正文后附出席/列席/请假人员名单。

### 信函格式（函的特殊版式）
```
发文机关标志（上边缘距上页边30mm，非标准37mm）
发文字号（顶格居版心右边缘）
═══════════ 红色双线（上粗下细）═══════════
标题
正文
═══════════ 红色双线（上细下粗）═══════════
```
> 首页不显示页码，版记不加印发机关和日期。

### 命令格式
```
XX省人民政府令
第X号
  《XXXXX》已经XX会议通过，现予公布，自X年X月X日起施行。
省长 [签名章]
XXXX年X月X日
```
> 发文机关标志距版心上边缘20mm（非标准35mm），令号居中。

---

## 五、完整公文结构（版头→主体→版记）

```
┌──────────────────────────────────────┐
│ 版 头                                 │
│   份号（如需）         左上角第一行     │
│   密级和保密期限（如需） 左上角第二行    │
│   紧急程度（如需）       左上角         │
│                                       │
│   发文机关标志（红头大字，居中，红色）    │
│   发文字号（居中，下行文）/ 上行文居左   │
│   签发人（上行文，居右）               │
│   ════════════ 红色分隔线 ════════════ │
├──────────────────────────────────────┤
│ 主 体                                 │
│   标题（二号小标宋，居中）              │
│   主送机关（三号仿宋，顶格）            │
│   正文（三号仿宋，首行缩进2字）          │
│   附件说明（正文下空一行）              │
│   发文机关署名（右空二字）              │
│   成文日期（阿拉伯数字，右空四字）       │
│   附注（如需）                         │
├──────────────────────────────────────┤
│ 版 记                                 │
│   ════════════════ 分隔线（粗）════════ │
│   抄送机关（四号仿宋，左右各空一字）      │
│   ──────────────── 分隔线（细）────────  │
│   印发机关和印发日期（四号仿宋）          │
│   ════════════════ 分隔线（粗）════════ │
├─ 版心外 ──────────────────────────────┤
│   页码 — 1 — （四号宋体，奇右偶左）      │
└──────────────────────────────────────┘
```

---

## 六、排版规范（生成 .docx 时自动应用）

| 要素 | 字体 | 字号(pt) | 格式 |
|------|------|---------|------|
| 发文机关标志 | 小标宋体→回退宋体 | — | 红色, 居中 |
| 标题 | 小标宋体→回退宋体 | 22 | 居中 |
| 正文 | 仿宋_GB2312 | 16 | 首行缩进0.74cm |
| 一级标题(一、) | 黑体 | 16 | 加粗 |
| 二级标题((一)) | 楷体_GB2312 | 16 | 加粗 |
| 主送/抄送 | 仿宋_GB2312 | 16/14 | 顶格/左右各空一字 |
| 落款/日期 | 仿宋_GB2312 | 16 | 右对齐 |
| 页码 | 宋体 | 14 | 一字线, 奇右偶左 |

| 页面参数 | 值 |
|---------|-----|
| 纸张 | A4 (210mm×297mm) |
| 页边距 | 上3.7 / 下3.5 / 左2.8 / 右2.6 cm |
| 行距 | 固定值28磅 |
| 每面行数 | 22行 |

---

## 七、.docx 生成完整代码（一次到位）

```python
# -*- coding: utf-8 -*-
"""公文生成工具箱 — 版头/主体/版记/页码 全覆盖"""
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

# ═══ 核心工具函数 ═══
LS = Pt(28)  # 固定行距28磅
INDENT = Cm(0.74)  # 首行缩进2字

def _font(run, name, pt, bold=False, color=None):
    """设置字体/字号/加粗/颜色 + east-asia 字体"""
    run.font.name = name; run.font.size = Pt(pt); run.bold = bold
    if color: run.font.color.rgb = color
    rPr = run._element.get_or_add_rPr()
    rF = rPr.find(qn('w:rFonts'))
    if rF is None:
        rF = OxmlElement('w:rFonts'); rPr.insert(0, rF)
    rF.set(qn('w:eastAsia'), name)
    rF.set(qn('w:ascii'), name)
    rF.set(qn('w:hAnsi'), name)

def new_doc(top=3.7, bottom=3.5, left=2.8, right=2.6):
    """创建符合 GB/T 9704 页边距的新文档"""
    doc = Document()
    for s in doc.sections:
        s.top_margin = Cm(top); s.bottom_margin = Cm(bottom)
        s.left_margin = Cm(left); s.right_margin = Cm(right)
    return doc

def _p(doc, text, font, pt, bold=False, align=None, indent=True, sb=0):
    """通用段落构建"""
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = LS
    p.paragraph_format.space_before = Pt(sb)
    if indent: p.paragraph_format.first_line_indent = INDENT
    if align is not None: p.alignment = align
    r = p.add_run(text); _font(r, font, pt, bold)
    return p

# 快捷函数：T=标题 R=主送 H1=一级标题 H2=二级标题 B=正文 D=落款
T  = lambda d,t: _p(d,t,'宋体',22,True,WD_ALIGN_PARAGRAPH.CENTER,False)
R  = lambda d,t: _p(d,t,'仿宋_GB2312',16,False,indent=False)
H1 = lambda d,t: _p(d,t,'黑体',16,True,sb=6)
H2 = lambda d,t: _p(d,t,'楷体_GB2312',16,True,sb=3)
B  = lambda d,t: _p(d,t,'仿宋_GB2312',16,False)
D  = lambda d,t: _p(d,t,'仿宋_GB2312',16,False,WD_ALIGN_PARAGRAPH.RIGHT,False,sb=12)

# ═══ 版头：红头 + 发文字号 + 签发人 + 红色分隔线 ═══
def red_header(doc, org, docnum, qianfaren=None):
    """版头：发文机关标志(红色大字) + 发文字号 + 签发人 + 红色分隔线"""
    p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(30); p.paragraph_format.line_spacing = LS
    r = p.add_run(org); _font(r, '宋体', 30, True, RGBColor(0xFF,0,0))

    p = doc.add_paragraph(); p.paragraph_format.space_before = Pt(12); p.paragraph_format.line_spacing = LS
    if qianfaren:
        r1 = p.add_run(docnum + '  '); _font(r1, '仿宋_GB2312', 16)
        r2 = p.add_run(' ' * 20 + '签发人：' + qianfaren); _font(r2, '仿宋_GB2312', 16)
    else:
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(docnum); _font(r, '仿宋_GB2312', 16)

    p = doc.add_paragraph(); p.paragraph_format.line_spacing = Pt(4)
    pPr = p._p.get_or_add_pPr(); pBdr = OxmlElement('w:pBdr')
    b = OxmlElement('w:bottom')
    for k,v in [('val','single'),('sz','6'),('space','1'),('color','FF0000')]:
        b.set(qn('w:'+k), v)
    pBdr.append(b); pPr.append(pBdr)

# ═══ 版记：抄送 + 印发 + 分隔线 ═══
def footer_block(doc, copy_to=None, printer='XXX办公室', date='2026年X月X日'):
    """版记：抄送机关 + 印发机关和日期 + 粗细分隔线"""
    def _line(style):
        p = doc.add_paragraph(); p.paragraph_format.line_spacing = Pt(2)
        pPr = p._p.get_or_add_pPr(); b = OxmlElement('w:pBdr')
        bt = OxmlElement('w:bottom')
        for k,v in [('val','single'),('sz','12' if style=='粗' else '6'),('space','1'),('color','000000')]:
            bt.set(qn('w:'+k), v)
        b.append(bt); pPr.append(b)

    _line('粗')
    if copy_to:
        p = doc.add_paragraph(); p.paragraph_format.line_spacing = LS
        r = p.add_run('抄送：' + copy_to + '。'); _font(r, '仿宋_GB2312', 14)
    _line('细')
    p = doc.add_paragraph(); p.paragraph_format.line_spacing = LS
    r1 = p.add_run(printer); _font(r1, '仿宋_GB2312', 14)
    r2 = p.add_run(' ' * 30 + date + '印发'); _font(r2, '仿宋_GB2312', 14)
    _line('粗')

# ═══ 页码：一字线格式，四号宋体，奇右偶左 ═══
def page_numbers(doc):
    """页码: — 1 — 格式, 四号宋体, 奇右偶左, 距版心下缘7mm"""
    for s in doc.sections:
        s.odd_and_even_pages_header_footer = True
        s.footer_distance = Cm(0.7)
        for f in (s.footer, s.even_page_footer):
            f.is_linked_to_previous = False
            for p in f.paragraphs: p.clear()
        def _pgnum(ftr, align, pad):
            p = ftr.paragraphs[0] if ftr.paragraphs else ftr.add_paragraph()
            p.alignment = align
            if pad: _font(p.add_run(' '), '宋体', 14)
            _font(p.add_run('— '), '宋体', 14)
            r = p.add_run()
            fc1 = OxmlElement('w:fldChar'); fc1.set(qn('w:fldCharType'),'begin'); r._r.append(fc1)
            r2 = p.add_run(); it = OxmlElement('w:instrText'); it.text='PAGE'; r2._r.append(it)
            r3 = p.add_run(); fc2 = OxmlElement('w:fldChar'); fc2.set(qn('w:fldCharType'),'end'); r3._r.append(fc2)
            _font(p.add_run(' —'), '宋体', 14)
            if not pad: _font(p.add_run(' '), '宋体', 14)
        _pgnum(s.footer, WD_ALIGN_PARAGRAPH.RIGHT, True)
        _pgnum(s.even_page_footer, WD_ALIGN_PARAGRAPH.LEFT, False)

# ═══ 增量修改 ═══
def modify(docx_path, edits):
    """修改已有文档。edits=[{para:段落号, action:replace/append/delete/insert_after, text:内容}]"""
    doc = Document(docx_path)
    for e in edits:
        i = e['para'] - 1
        if e['action'] == 'replace' and 0 <= i < len(doc.paragraphs):
            doc.paragraphs[i].text = e['text']
        elif e['action'] == 'delete' and 0 <= i < len(doc.paragraphs):
            doc.paragraphs[i]._element.getparent().remove(doc.paragraphs[i]._element)
        elif e['action'] == 'insert_after':
            j = e.get('after', 0) - 1
            if 0 <= j < len(doc.paragraphs):
                np = OxmlElement('w:p'); nr = OxmlElement('w:r'); nt = OxmlElement('w:t')
                nt.text = e['text']; nr.append(nt); np.append(nr)
                doc.paragraphs[j]._element.addnext(np)
    doc.save(docx_path)

# ═══ 自检 + 自动修复 ═══
def check(path, fix=True):
    """检查并修复页边距、英文标点、首行缩进。返回(问题列表, 修复数)"""
    doc = Document(path); issues = []; n = 0
    s = doc.sections[0]
    if abs(s.top_margin.cm - 3.7) > 0.3:
        if fix: s.top_margin = Cm(3.7); n += 1
        else: issues.append('上边距偏离')
    if abs(s.left_margin.cm - 2.8) > 0.3:
        if fix: s.left_margin = Cm(2.8); n += 1
        else: issues.append('左边距偏离')
    pmap = {'(': '（', ')': '）', ':': '：', ';': '；', ',': '，'}
    for p in doc.paragraphs:
        for r in p.runs:
            for en, cn in pmap.items():
                if en in r.text: r.text = r.text.replace(en, cn); n += 1
    for i, p in enumerate(doc.paragraphs):
        if len(p.text.strip()) > 20 and p.paragraph_format.first_line_indent is None:
            if fix: p.paragraph_format.first_line_indent = INDENT; n += 1
            else: issues.append(f'P{i+1}缺缩进')
    if fix and n: doc.save(path)
    return issues or ['OK'], n

---

## 八、公文用语速查

### 四级语言原则
| 原则 | 要求 | ❌ | ✅ |
|------|------|----|----|
| **准确** | 概念明确、判断恰当 | 大概/也许/差不多 | 删去或用确切表述 |
| **平实** | 不用渲染夸张 | 辉煌成就/极大鼓舞 | 实事求是表述 |
| **简洁** | 言简意赅、短句 | "进行认真的研究讨论" | "研究" |
| **庄重** | 书面语、严肃 | 搞定/摆平/一把手 | 完成/解决/主要负责同志 |

### 句式速查
| 位置 | 句式 |
|------|------|
| 开头 | 根据……/为……/按照……/经……研究 |
| 过渡 | 现将有关事项通知如下：/现提出如下意见： |
| 请示结语 | 妥否，请批示。/当否，请审批。 |
| 报告结语 | 特此报告。/专此报告。 |
| 批复结语 | 此复。/特此批复。 |
| 函结语 | 此函。/请予支持为盼。/特此函复。 |

### 避讳词对照
| ❌ | ✅ | ❌ | ✅ |
|----|----|----|----|
| 搞定/摆平 | 完成/解决 | 好好干 | 认真抓好落实 |
| 一把手 | 主要负责同志 | 好多/很多 | 大量/众多 |
| 马上/快点 | 立即/尽快 | 打算 | 拟定/计划 |
| 讲话/发言 | 指出/强调/要求 | 狠抓 | 强化/加大力度 |

---

## 九、标点与数字铁律

- ❌ 公文正文不用英文标点：`, . : ; ""` → `， 。 ： ； ""`
- ❌ 发文字号年份不用 `[]()` → 用 `〔〕`（六角括号）
- ❌ 成文日期不用大写 → 用阿拉伯数字 `2026年5月15日`
- ❌ 月日不编虚位 → `5月` 不写 `05月`
- ❌ 附件名称后不加标点
- ❌ 标题不加书名号

---

## 十、输出前自检与自动修复

生成 .docx 后自动执行 `check()`，发现问题自动修复，无需用户手动干预：

```
check() 检测流程：
  检测上边距 → 若偏离3.7cm → 自动修正
  检测左边距 → 若偏离2.8cm → 自动修正
  扫描英文标点 → 存在 → 自动替换为中文全角标点
  扫描首行缩进 → 缺失 → 自动添加0.74cm缩进
  → 输出自检报告 + 修正数量
```

### 人工复检清单

自动修复后提示用户复核以下项目（无法自动判断的）：

- [ ] 标题二号宋体居中
- [ ] 正文三号仿宋首行缩进2字
- [ ] 一级标题黑体加粗、二级标题楷体加粗
- [ ] 行距固定值28磅、页边距3.7/3.5/2.8/2.6
- [ ] 无英文半角标点
- [ ] 成文日期阿拉伯数字
- [ ] 请示有联系人+电话
- [ ] 上行文有签发人
- [ ] 请示不夹带报告
- [ ] 附件名称后无标点
- [ ] 版头红头+发文字号+红线
- [ ] 版记抄送+印发+分隔线
- [ ] 页码一字线、奇右偶左

---

## 十一、错误案例对比

### 请示：❌ 错误版 vs ✅ 正确版

**❌ 错误版：**
```
东风街道办事处关于申请增设便民早餐店的请示报告
青山区政府、财政局：
……我街道打算新增设……还有两百万元资金没有着落……
要求区政府、财政局给予支持解决。务必批准。
```

**问题**：①标题混用"请示报告" ②多主送 ③口语化 ④结语生硬 ⑤缺联系人

**✅ 正确版：**
```
东风街道办事处关于兴建便民早餐店资金缺口的请示
青山区人民政府：
……我街道决定……拟请区政府予以支持解决。
妥否，请审核批示。
（联系人：张三　电话：12345678901）
```

---

## 十二、文件导航

| 需要什么 | 路径 |
|---------|------|
| 从头写 | 看本文 §四 写作框架 |
| 怎么写得好 | `references/writing-techniques.md` |
| 用语更规范 | `references/writing-language.md` |
| 标点数字规则 | `references/punctuation-numbers.md` |
| 常见错误避免 | `references/common-mistakes.md` |
| 全面质量检查 | `checklists/quality-checklist.md` |
| 字体安装指南 | `references/font-install.md` (含 WPS 操作指引) |
| 规范词汇 | `references/political-terms.md` |
| 格式诊断脚本 | `scripts/analyzer.py` |
| Word 模板文件 | `templates/*.md` (16种) |
| 格式预设 | `presets/custom.json` |

---

> **Acknowledgments**: xkonglong/gw (Word/WPS插件参考), KaguraNanaga/official-document-writing-skill (写作技巧与范例), cj0103/gbt-9704-2012-skills (格式诊断/标点修复/排版工具)
