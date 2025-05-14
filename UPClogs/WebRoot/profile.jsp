<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
if (session.getAttribute("user_id")==null)
{
	response.sendRedirect("index.jsp"); 
	return;
}
long uid = (Long)session.getAttribute("user_id");
String url11 = null; 
String name = "test";
List<Article> alist = null;
List<Comment> clist = null;
SimpleDateFormat sdff=new SimpleDateFormat("yyyy年MM月dd日");

try
{
    User user = User.findById(uid);
    url11 = user.getAvatar();
    name = user.getName();
    alist = Article.findByAuthor(uid);
    clist = Comment.findByAuthor(uid);
    
} catch(Exception e) 
{ 
	
} 
if(url11==null)
	url11="img/default.png" ;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心</title>
    <link rel="stylesheet" href="CSS/profile.css">
	<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" />
</head>
<body>
<%@ include file="header.jsp" %>
    <div class="profile-container">
        <aside class="profile-sidebar">
            <div class="profile-header">
                <img src="<%=url11 %>" 
                     alt="用户头像" 
                     class="user-avatar" id="userAvatar">
                <div class="user-info">
                    <h2 id="userName"><%=name %></h2>
                </div>
            </div>

            <div class="nav-links">
                <a href="#" class="active" data-target="articles">
                    <span class="icon">📝</span> 我的文章
                </a>
                <a href="#" class="active" data-target="comments">
                    <span class="icon">💬</span> 我的评论
                </a>
                <a href="#" data-target="settings">
                    <span class="icon">⚙️</span> 账户设置
                </a>
            </div>
        </aside>

        <main class="content-section">
            <div id="articlesSection" class="section-content">
                <h2 class="section-title">我的文章</h2>
                <div id="articlesList">
                 <% 
                   if(alist == null||alist.size()==0)
                        {
                        %>
                        <div>
                            <center>
                                <h3>还没有文章呢~(￣▽￣)~*</h3>
                            </center>
                        </div>
                        <%}else{ %>
                            <% for (int i = alist.size() - 1; i >= 0; i--) 
                            {
                                Article article = alist.get(i);  %>
                                <article class="post-card">
                                    <h2>
                                        <%= article.getTitle() %>
                                    </h2>
                                    </a>
                                    <p>
                                        <%= article.getText() %>...
                                    </p>
                                    <center>
                <a href="new_article.jsp?pid=<%=article.getId() %>"><button class="btn-edit" >编辑</button></a>
                <a href="deleteArticle.jsp?pid=<%=article.getId() %>"><button class="btn-delete" >删除</button></a>
                </center>
                                </article>
                                <% } %>
                                    <% } %>
                </div>
            </div>

            <div id="commentsSection" class="section-content" style="display: none;">
                <h2 class="section-comment">我的评论</h2>
                <div id="commentsList">
                <% 
                   if(clist == null||clist.size()==0)
                        {
                        %>
                        <div>
                            <center>
                                <h3>还没有评论呢~(￣▽￣)~*</h3>
                            </center>
                        </div>
                        <%}else{%>
                        <%
                        int num = clist.size();
                        for(int i = 0;i<num;i++) {
                	
                	String ucontent = clist.get(i).getContent();
                	String utime = sdff.format(clist.get(i).getPublishTime());
                
                %>
                         <div class="comment-item">
                        <img src="<%=url11 %>" alt="用户头像" class="comment-avatar">
                        <div class="comment-content">
                            <div class="comment-meta">
                                <span><%=Article.findById(clist.get(i).getArticleId()).getTitle() +" | "+name +" | " +utime %></span>
                                <center>
                                <a href="article.jsp?pid=<%= clist.get(i).getArticleId() %>" class="btn"><button class="btn-edit" >阅读全文</button></a>
                                <a href="deleteComment.jsp?cid=<%=clist.get(i).getCommentId() %>&from=profile.jsp"><button class="btn-delete" >删除</button></a>
                            	</center>
                            </div>
                            <div id="comment-area-<%=i %>" style="width: 600px;"></div>
                        </div>
                    </div>
                <%} %>
                </div>
                <div class="editor-container">
                        <%} %>
                </div>
            </div>

            <div id="settingsSection" class="section-content" style="display: none;">
                <h2 class="section-title">账户设置</h2>
                <div class="settings-form">
                    <div class="form-group">
                        <label>头像</label>
                        <div class="avatar-upload">
                        <center>
                            <img id="avatarPreview" src="<%=url11 %>" 
                                 alt="头像预览" >
                                 <br>
                            <input type="file" id="avatarUpload" accept="img/*" style="display: none;">
                            <button type="button" class="btn btn-upload" onclick="document.getElementById('avatarUpload').click()">
                                上传新头像
                            </button></center>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>修改密码</label>
                        <div class="password-form">
                            <input type="password" id="newPassword" placeholder="新密码" minlength="8" required>
                            <input type="password" id="confirmPassword" placeholder="确认密码"  minlength="8" required>
                            <a href="editPsd.jsp" id="updatePasswordLink"><button type="button" class="btn-upload" >修改密码</button></a>
                            <p id="errorMessage" style="color: red; font-size: 12px; display: none;">两次输入的密码不一致，请重新输入。</p>
                            
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    
    <%@ include file="footer.jsp" %>
    <script>
    function setupEventListeners() 
    {
    	document.querySelectorAll('.nav-links a').forEach(link => {
    		link.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.nav-links a').forEach(item => {
                    item.classList.remove('active');
                });
                this.classList.add('active');
                
                const targetSection = this.dataset.target + 'Section';
                console.log(targetSection);
                document.querySelectorAll('.section-content').forEach(section => {
                    section.style.display = 'none';
                });
                document.getElementById(targetSection).style.display = 'block';
        });
    })
    }

        document.getElementById('avatarUpload').addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const avatarPreview = document.getElementById('avatarPreview');
                    avatarPreview.src = e.target.result; 
                };
                reader.readAsDataURL(file);

                const formData = new FormData();
                formData.append('image', file);

                fetch('/UPClogs/upload-avatar', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.url) {
                            console.log('头像上传成功:', data.url);
                            window.location.reload();
                        } else {
                            alert('头像上传失败，请稍后重试！');
                        }
                    })
                    .catch(error => {
                        console.error('上传失败:', error);
                        alert('头像上传失败，请检查网络连接！');
                    });
            }
        });
        
        document.getElementById('updatePasswordLink').addEventListener('click', function (event) {
            event.preventDefault();
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const errorMessage = document.getElementById('errorMessage');
            if (newPassword !== confirmPassword) {
                errorMessage.style.display = 'block';
                return; 
            }

            errorMessage.style.display = 'none';
            window.location.href = this.href;
        });
    setupEventListeners();
    document.addEventListener("DOMContentLoaded", function () {
        
        const comments = [
            <% int num = clist.size(); %>
            <%for (int i = 0; i < num; i++) { %>
                String.raw`<%= clist.get(i).getContent() %>`,
            <% } %>
        ];
		
        comments.forEach((content, index) => {
        	console.log(index);
        	console.log(content);
            const commentArea = document.getElementById(`comment-area-`+ index);
            console.log(`comment-area-`+ index);
            if (commentArea) 
            {
                try {
                    const deltaData = JSON.parse(content); 
                    const quillComment = new Quill(commentArea, {
                        readOnly: true, 
                        theme: 'bubble' 
                    });
                    const formattedContent = {
                        ops: deltaData.ops.map(op => {
                            if (op.insert) {
                                return {
                                    insert: op.insert,
                                    attributes: {
                                        ...op.attributes,
                                        background: "#F8F9FA" 
                                    }
                                };
                            }
                            return op;
                        })
                    };
                    quillComment.setContents(formattedContent); // 设置评论内容
                } catch (error) {
                    console.error(`解析评论内容失败 (索引 ${index}):`, error);
                    commentArea.innerHTML = "<p>评论内容无法加载。</p>";
                }
            }
            else{
            	console.log("没找到");
            }
        });
    });
    </script>
</body>
</html>