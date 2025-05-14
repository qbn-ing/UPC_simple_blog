<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" import="java.util.*" import="java.text.*"%>
<% 
String pidStr = request.getParameter("pid");
String title = "test";
String author = "test";
String avapth = "img/default.png";//默认头像
String date = "";
String content = "";
int views = 0;
long pid = -1;
long uid = -1;
long aid = -1;
if (session.getAttribute("user_id")!=null)
{
	uid = (Long)session.getAttribute("user_id");
}
SimpleDateFormat sdff=new SimpleDateFormat("yyyy年MM月dd日");
if (pidStr != null) {
	
    pid = Long.parseLong(pidStr);
    try
    {
    	Article article = Article.findById(pid);
    	title = article.getTitle();
    	article.addViews();
    	views = article.getPageviews();
    	aid = article.getAuthorId();
    	date =  sdff.format(article.getPublishTime());
    	content = article.getContent();
    	User user = User.findById(article.getAuthorId());
    	author = user.getName();
    	avapth = user.getAvatar();
    	
    }
    catch(Exception e)
    {
    	//e.printStackTrace();
    }
} else 
{
	response.sendRedirect("index.jsp");
	return;
}
String metainfo = author+" | "+ date +" | 阅读 "+views+" 次";         
         
%>
 <!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title%></title>
    <link rel="stylesheet" href="CSS/article.css">
	<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" />
</head>

<body>
<%@ include file="header.jsp" %>
<br>
    <div class="post-container">
        <article class="post-content">
            <div class="post-header">
                <h1><%=title %></h1>
                <%if(uid == aid) {%>
                <center>
                <a href="new_article.jsp?pid=<%=pid %>"><button class="btn-edit" >编辑</button></a>
                <a href="deleteArticle.jsp?pid=<%=pid %>"><button class="btn-delete" >删除</button></a>
                </center>
                 <% }%>
                <div class="post-meta">
                    <div class="author-info">
                        <span><%= metainfo%></span>
                    </div>
                    <img src="<%=avapth %>" alt="作者头像" class="post-avatar">
                </div>
            </div>
			<div id="display-area" style="width: 750px;"></div>
            

			<br>
			<%
				List<Comment> list = null;
				int num = 0;
				if(pid!=-1)
				{
					list = Comment.findByArticle(pid);
					if(list != null)
						num = list.size();
				}
			%>
            <div class="comments-section">
                <h2>评论区（<span id="commentCount"><%=num %></span>）</h2>
				
                <div id="commentList">
                <%for(int i = 0;i<num;i++) {
                	User comment_user = list.get(i).getAuthor();
                	String imgpth = comment_user.getAvatar();
                	String uname = comment_user.getName();
                	String ucontent = list.get(i).getContent();
                	String utime = sdff.format(list.get(i).getPublishTime());
                
                %>
                    <div class="comment-item">
                        <img src="<%=imgpth %>" alt="用户头像" class="comment-avatar">
                        <div class="comment-content">
                            <div class="comment-meta">
                                <span><%=uname +" | " +utime %></span>
                                <%if(uid == comment_user.getId()) {%>
                                <a href="deleteComment.jsp?cid=<%=list.get(i).getCommentId() %>"><button class="btn-delete" >删除</button></a>
                                <% }%>
                            </div>
                            <div id="comment-area-<%=i %>" style="width: 700px;"></div>
                        </div>
                    </div>
				<%} %>
                </div>
				<div class="editor-container">

                <form class="comment-form" id="commentForm" action="save-comment.jsp?pid=<%=pid %>" method="post">

                    <div class="form-group">
                        <label for="content">写下你的评论...</label>
                        <div class="form-group">
                            <div class="toolbar">
                                <span class="ql-formats">
                                    <button class="ql-bold"></button>
                                    <button class="ql-italic"></button>
                                    <button class="ql-underline"></button>
                                </span>
                                <span class="ql-formats">
                                    <button class="ql-link"></button>
                                    <button class="ql-image"></button>
                                    <button class="ql-formula"></button>
                                </span>
                                <span class="ql-formats">
                                    <select class="ql-header">
                                        <option value="1">标题1</option>
                                        <option value="2">标题2</option>
                                        <option value="">正文</option>
                                    </select>
                                </span>
                                <span class="ql-formats">
                                	<button class="ql-direction" value="rtl"></button>
    								<select class="ql-align"></select>
                                </span>
                                <span class="ql-formats">
	                                <button class="ql-header" value="1"></button>
								    <button class="ql-header" value="2"></button>
								    <button class="ql-blockquote"></button>
								    <button class="ql-code-block"></button>
								</span>
                            </div>
                            <div id="editor" style="height: 300px;"></div>
                            <input type="hidden" name="content" id="hiddenContent">
                        </div>
                    </div>


                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">立即发布</button>
                    </div>
                </form>
                </div>
            </div>
        </article>
    </div>
    <%@ include file="footer.jsp" %>
 <script>
                function imageHandler() {
                    const input = document.createElement('input');
                    input.type = 'file';
                    input.accept = 'image/*';

                    input.onchange = async () => {
                        const file = input.files[0];
                        const formData = new FormData();
                        formData.append('image', file);

                        try {
                            const res = await fetch('/UPClogs/upload-image', {
                                method: 'POST',
                                body: formData
                            });
                            const { url } = await res.json();

                            const range = this.quill.getSelection();
                            this.quill.insertEmbed(range.index, 'image', url, 'user');
                            this.quill.setSelection(range.index + 1, 'silent');

                        } catch (err) {
                            console.error('上传失败:', err);
                            alert('图片上传失败');
                        }
                    };
                    input.click();
                }
                document.querySelector('form').onsubmit = function () {
                    const content = document.querySelector('#hiddenContent');
                    const quillContent = quill.root.innerHTML.trim();
                    if (!quillContent || quillContent === '<p><br></p>') 
                    {
                        alert('评论内容不能为空！');
                        return false; 
                    }

                    content.value = JSON.stringify(quill.getContents());
                    return true; 
                };
                const quill = new Quill('#editor', {
                    theme: 'snow',
                    modules: {
                    	syntax: true,
                        toolbar: {
                            container: '.toolbar',
                            handlers: { image: imageHandler }
                        }
                    }
                });
             	const str = String.raw`<%=content%>`;
                const deltaData = JSON.parse(str); 

                const quillDisplay = new Quill('#display-area', {
                    readOnly: true, 
                    theme: 'bubble' 
                });
                quillDisplay.setContents(deltaData);
                
                document.addEventListener("DOMContentLoaded", function () {
                  
                    const comments = [
                        <% for (int i = 0; i < num; i++) { %>
                            String.raw`<%= list.get(i).getContent() %>`,
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