## 安装本技能（LobsterAI）

### 自动安装（推荐，Windows）

1. 下载本仓库的 `install.bat`
2. 双击运行
3. 脚本自动检测 LobsterAI 安装位置 → 复制技能文件 → 更新配置
4. 重启 LobsterAI，完成

### 手动安装

1. 点击 GitHub 页面的绿色 **Code** 按钮 → **Download ZIP**
2. 解压到 LobsterAI 的 `SKILLs` 文件夹内（重命名为 `gongwen`）
3. 打开 `SKILLs/skills.config.json`，在 `defaults` 大括号内添加：
   ```json
   "gongwen": { "order": 11, "enabled": true }
   ```
4. 重启 LobsterAI

### 安装后怎么用

在 LobsterAI 对话框里直接说：

- "帮我写一份关于汛期安全生产检查的通知"
- "起草一个请示，申请增加人员编制20名"
- "拟一个函，请规划局支持项目立项"

然后等几秒钟，`.docx` 文件就生成好了，双击打开即可。
