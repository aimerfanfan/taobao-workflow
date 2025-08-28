# 📚 GitHub Pages 部署教程

## 🎯 准备工作

### 1. 注册GitHub账号
- 访问 https://github.com
- 点击"Sign up"注册新账号
- 验证邮箱地址

### 2. 安装Git（如果还没有）
- Windows: 下载 https://git-scm.com/download/win
- Mac: `brew install git` 或从官网下载
- Linux: `sudo apt install git` 或 `sudo yum install git`

### 3. 配置Git
```bash
git config --global user.name "你的姓名"
git config --global user.email "你的邮箱@example.com"
```

---

## 🚀 部署步骤

### 步骤1：创建GitHub仓库

1. **登录GitHub**
   - 访问 https://github.com
   - 使用账号密码登录

2. **创建新仓库**
   - 点击右上角的"+"号
   - 选择"New repository"
   - 填写仓库信息：
     ```
     Repository name: taobao-workflow-tool
     Description: 淘宝电商工作流工具 - 自动抓取产品信息并生成营销图片
     Public: ✅ (选择公开，免费版必须公开才能使用Pages)
     Add a README file: ❌ (不勾选，我们有自己的文件)
     ```
   - 点击"Create repository"

### 步骤2：上传项目文件

#### 方法一：使用Git命令行（推荐）

1. **在项目目录中打开终端**
   ```bash
   cd 淘宝电商工作流
   ```

2. **初始化Git仓库**
   ```bash
   git init
   ```

3. **添加所有文件**
   ```bash
   git add .
   ```

4. **提交文件**
   ```bash
   git commit -m "初始化淘宝电商工作流工具"
   ```

5. **设置主分支**
   ```bash
   git branch -M main
   ```

6. **添加远程仓库**
   ```bash
   git remote add origin https://github.com/你的用户名/taobao-workflow-tool.git
   ```
   > 注意：将"你的用户名"替换为你的GitHub用户名

7. **推送到GitHub**
   ```bash
   git push -u origin main
   ```

#### 方法二：使用GitHub网页上传

1. **在仓库页面点击"uploading an existing file"**
2. **拖拽项目文件夹中的所有文件到上传区域**
3. **填写提交信息**：
   ```
   Commit message: 初始化淘宝电商工作流工具
   ```
4. **点击"Commit changes"**

### 步骤3：启用GitHub Pages

1. **进入仓库设置**
   - 在仓库页面点击"Settings"标签
   - 在左侧菜单中找到"Pages"

2. **配置Pages设置**
   - Source: 选择"Deploy from a branch"
   - Branch: 选择"main"
   - Folder: 选择"/ (root)"
   - 点击"Save"

3. **等待部署完成**
   - GitHub会显示一个绿色的提示框
   - 部署通常需要1-5分钟

### 步骤4：访问网站

1. **获取访问地址**
   ```
   https://你的用户名.github.io/taobao-workflow-tool/
   ```

2. **测试功能**
   - 打开网站确保正常显示
   - 测试产品链接处理功能
   - 验证图片下载功能

---

## 🔧 常见问题解决

### 问题1：推送代码时要求登录

**解决方案：**
```bash
# 使用个人访问令牌
git remote set-url origin https://你的用户名:你的令牌@github.com/你的用户名/taobao-workflow-tool.git
```

**获取个人访问令牌：**
1. GitHub设置 → Developer settings → Personal access tokens
2. Generate new token → 选择权限 → 复制令牌

### 问题2：网站显示404错误

**检查清单：**
- [ ] 确认仓库是公开的
- [ ] 确认Pages已启用
- [ ] 确认index.html文件在根目录
- [ ] 等待几分钟让部署完成

### 问题3：CDN资源加载失败

**解决方案：**
- 网站可能在某些地区访问CDN受限
- 用户可以正常使用，这是正常现象
- 如需优化，可下载CDN资源到本地

### 问题4：图片下载功能不工作

**解决方案：**
- GitHub Pages使用HTTPS，下载功能正常
- 如有问题，参考"下载问题解决方案.md"

---

## 🎯 优化建议

### 1. 自定义域名（可选）

1. **购买域名**
   - 推荐：阿里云、腾讯云、GoDaddy

2. **配置DNS**
   ```
   类型: CNAME
   名称: www
   值: 你的用户名.github.io
   ```

3. **在GitHub中设置**
   - Pages设置 → Custom domain
   - 输入你的域名
   - 勾选"Enforce HTTPS"

### 2. 添加网站图标

创建 `favicon.ico` 文件并放在根目录：
```html
<!-- 在index.html的<head>中添加 -->
<link rel="icon" type="image/x-icon" href="favicon.ico">
```

### 3. 添加SEO优化

在 `index.html` 的 `<head>` 中添加：
```html
<meta name="description" content="淘宝电商工作流工具 - 自动抓取产品信息并生成营销图片">
<meta name="keywords" content="淘宝,电商,工作流,图片生成,产品信息">
<meta property="og:title" content="淘宝电商工作流工具">
<meta property="og:description" content="自动抓取产品信息并生成营销图片">
<meta property="og:url" content="https://你的用户名.github.io/taobao-workflow-tool/">
```

---

## 📊 部署后的管理

### 更新网站内容

1. **修改本地文件**
2. **提交更改**
   ```bash
   git add .
   git commit -m "更新功能"
   git push
   ```
3. **等待自动部署**（1-5分钟）

### 查看访问统计

添加Google Analytics：
```html
<!-- 在index.html的<head>中添加 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_TRACKING_ID');
</script>
```

### 备份项目

定期备份到其他平台：
```bash
# 添加多个远程仓库
git remote add backup https://gitee.com/你的用户名/taobao-workflow-tool.git
git push backup main
```

---

## ✅ 部署检查清单

部署完成后，请检查以下项目：

- [ ] 网站可以正常访问
- [ ] 所有页面元素显示正常
- [ ] CDN资源加载正常（或有备用方案）
- [ ] 图片下载功能正常工作
- [ ] 移动端显示正常
- [ ] 浏览器控制台无严重错误
- [ ] 网站加载速度可接受

---

## 🎉 恭喜！

您的淘宝电商工作流工具现在已经成功上线！

**网站地址：** `https://你的用户名.github.io/taobao-workflow-tool/`

**下一步建议：**
1. 分享给团队成员使用
2. 收集用户反馈
3. 持续优化功能
4. 考虑添加更多特性

**技术支持：**
- 遇到问题可查看其他文档
- GitHub Issues中提交问题
- 参考官方GitHub Pages文档
