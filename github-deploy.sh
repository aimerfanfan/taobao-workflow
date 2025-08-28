#!/bin/bash

# GitHub Pages 自动部署脚本
# 淘宝电商工作流工具专用

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 打印函数
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_title() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# 检查必要工具
check_requirements() {
    print_title "检查环境"
    
    # 检查git
    if ! command -v git &> /dev/null; then
        print_error "Git未安装，请先安装Git"
        echo "下载地址：https://git-scm.com/downloads"
        exit 1
    fi
    
    print_info "Git已安装：$(git --version)"
    
    # 检查git配置
    if ! git config user.name &> /dev/null; then
        print_warning "Git用户名未配置"
        read -p "请输入您的姓名: " username
        git config --global user.name "$username"
    fi
    
    if ! git config user.email &> /dev/null; then
        print_warning "Git邮箱未配置"
        read -p "请输入您的邮箱: " email
        git config --global user.email "$email"
    fi
    
    print_info "Git配置完成"
}

# 获取GitHub信息
get_github_info() {
    print_title "GitHub仓库配置"
    
    # 如果已经是git仓库，尝试获取现有信息
    if [ -d ".git" ]; then
        existing_remote=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ $existing_remote == *"github.com"* ]]; then
            print_info "检测到现有GitHub仓库：$existing_remote"
            read -p "是否使用现有仓库？(y/n): " use_existing
            if [[ $use_existing == "y" || $use_existing == "Y" ]]; then
                return 0
            fi
        fi
    fi
    
    echo "请提供GitHub仓库信息："
    read -p "GitHub用户名: " github_username
    read -p "仓库名称 (默认: taobao-workflow-tool): " repo_name
    repo_name=${repo_name:-taobao-workflow-tool}
    
    # 构建仓库URL
    repo_url="https://github.com/$github_username/$repo_name.git"
    
    print_info "仓库URL: $repo_url"
    
    # 询问是否需要创建仓库
    echo ""
    print_warning "请确保已在GitHub上创建了仓库：$repo_name"
    echo "如果还没有创建，请："
    echo "1. 访问 https://github.com/new"
    echo "2. Repository name: $repo_name"
    echo "3. 选择 Public"
    echo "4. 点击 Create repository"
    echo ""
    read -p "仓库已创建，按回车继续..."
}

# 初始化Git仓库
init_git_repo() {
    print_title "初始化Git仓库"
    
    if [ ! -d ".git" ]; then
        print_info "初始化新的Git仓库..."
        git init
    else
        print_info "使用现有Git仓库"
    fi
    
    # 检查是否有文件需要提交
    if [ -z "$(git status --porcelain)" ]; then
        print_warning "没有文件需要提交"
    else
        print_info "添加文件到Git..."
        git add .
        
        # 生成提交信息
        commit_message="部署淘宝电商工作流工具 - $(date '+%Y-%m-%d %H:%M:%S')"
        print_info "提交信息: $commit_message"
        git commit -m "$commit_message"
    fi
    
    # 确保在main分支
    current_branch=$(git branch --show-current)
    if [ "$current_branch" != "main" ]; then
        print_info "切换到main分支..."
        git checkout -b main 2>/dev/null || git checkout main
    fi
}

# 配置远程仓库
setup_remote() {
    print_title "配置远程仓库"
    
    # 检查是否已有远程仓库
    if git remote get-url origin &> /dev/null; then
        existing_url=$(git remote get-url origin)
        print_info "现有远程仓库: $existing_url"
        
        if [ "$existing_url" != "$repo_url" ]; then
            print_info "更新远程仓库URL..."
            git remote set-url origin "$repo_url"
        fi
    else
        print_info "添加远程仓库..."
        git remote add origin "$repo_url"
    fi
}

# 推送到GitHub
push_to_github() {
    print_title "推送到GitHub"
    
    print_info "推送代码到GitHub..."
    
    # 首次推送可能需要设置上游分支
    if ! git push -u origin main 2>/dev/null; then
        print_warning "推送失败，可能需要身份验证"
        echo ""
        echo "如果需要身份验证，请选择以下方式之一："
        echo "1. 使用GitHub CLI: gh auth login"
        echo "2. 使用个人访问令牌"
        echo "3. 使用SSH密钥"
        echo ""
        
        read -p "是否重试推送？(y/n): " retry
        if [[ $retry == "y" || $retry == "Y" ]]; then
            git push -u origin main
        else
            print_error "推送取消"
            exit 1
        fi
    fi
    
    print_info "代码推送成功！"
}

# 配置GitHub Pages
setup_github_pages() {
    print_title "GitHub Pages配置"
    
    echo ""
    print_info "请手动启用GitHub Pages："
    echo "1. 访问仓库页面：https://github.com/$github_username/$repo_name"
    echo "2. 点击 Settings 标签"
    echo "3. 在左侧菜单中找到 Pages"
    echo "4. Source 选择：Deploy from a branch"
    echo "5. Branch 选择：main"
    echo "6. Folder 选择：/ (root)"
    echo "7. 点击 Save"
    echo ""
    
    read -p "GitHub Pages已配置，按回车继续..."
    
    # 预测网站URL
    website_url="https://$github_username.github.io/$repo_name/"
    print_info "您的网站地址将是：$website_url"
    
    echo ""
    print_warning "部署可能需要1-5分钟时间"
    print_info "部署完成后，请访问上面的网址测试功能"
}

# 部署后检查
post_deploy_check() {
    print_title "部署后检查"
    
    echo "请检查以下项目："
    echo "□ 网站可以正常访问"
    echo "□ 页面显示正常"
    echo "□ 输入产品链接功能正常"
    echo "□ 图片下载功能正常"
    echo "□ 移动端显示正常"
    echo ""
    
    echo "测试用例："
    echo "1. 访问：$website_url"
    echo "2. 输入测试链接：https://item.taobao.com/item.htm?id=123456789"
    echo "3. 点击'开始处理'"
    echo "4. 验证图片下载"
    echo ""
}

# 主函数
main() {
    clear
    print_title "淘宝电商工作流工具 - GitHub Pages 部署"
    echo ""
    
    # 检查当前目录
    if [ ! -f "index.html" ]; then
        print_error "未找到index.html文件"
        print_error "请在项目根目录中运行此脚本"
        exit 1
    fi
    
    print_info "检测到项目文件，开始部署..."
    echo ""
    
    # 执行部署步骤
    check_requirements
    get_github_info
    init_git_repo
    setup_remote
    push_to_github
    setup_github_pages
    post_deploy_check
    
    # 完成提示
    print_title "部署完成！"
    print_info "您的淘宝电商工作流工具已成功部署到GitHub Pages"
    print_info "网站地址：$website_url"
    echo ""
    print_warning "请等待1-5分钟让GitHub完成部署，然后访问网站测试功能"
    echo ""
    
    # 询问是否打开网站
    read -p "是否现在打开网站？(y/n): " open_site
    if [[ $open_site == "y" || $open_site == "Y" ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$website_url"
        elif command -v open &> /dev/null; then
            open "$website_url"
        else
            print_info "请手动访问：$website_url"
        fi
    fi
}

# 运行主函数
main "$@"
