<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*"  import="java.net.*"%>
 <%if (session.getAttribute("user_id")==null){response.sendRedirect("login.jsp");return;}%>
<%
String pidStr = request.getParameter("pid");
long pidd = -1;
long uid = (Long)session.getAttribute("user_id");
long aid = -1;
String title = "test";
String author = "test";
String avapth = "img/default.png";//默认头像
String date = "";
String content = "";
if (pidStr != null)
{
	pidd = Long.parseLong(pidStr);
	 try
	    {
	    	Article article = Article.findById(pidd);
	    	title = article.getTitle();
	    	article.addViews();
	    	aid = article.getAuthorId();
	    	if(aid!=uid)
	    	{
	    		response.sendRedirect("article.jsp?pid="+ URLEncoder.encode(Long.toString(pidd), "UTF-8"));
	    		return;
	    	}
	    	content = article.getContent();
	    	User user = User.findById(article.getAuthorId());
	    	author = user.getName();
	    	avapth = user.getAvatar();
	    	
	    }
	    catch(Exception e)
	    {
	    	//e.printStackTrace();
	    }
}
%>               
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
		<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
		<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
		<link
		  rel="stylesheet"
		  href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css"
		/>
		<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" />
        <title>博文编辑器</title>
        <link rel="stylesheet" href="CSS/new_article.css">
    </head>

    <body>
    
        <%@ include file="header.jsp" %>

            <div class="editor-container">
                <h2>编辑博文</h2>

                <form id="postForm" action="save-article.jsp" method="post">
                    <div class="form-group">
                        <label for="title">文章标题</label>
                        <input type="text" name="title" id="title" placeholder="请输入文章标题" required>
                    </div>

                    <div class="form-group">
                        <input type="hidden" name="pid" value="<%=pidd %>">
                    
                        <label for="content">文章内容</label>
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
                        <a href="index.jsp"><button type="button" class="btn btn-delete">取消</button></a>
                    </div>
                </form>
            </div>

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
                document.querySelector('form').onsubmit = function () 
                {
                    const content = document.querySelector('#hiddenContent');
                    const quillContent = quill.root.innerHTML.trim();
                    if (!quillContent || quillContent === '<p><br></p>') 
                    {
                        alert('博文内容不能为空！');
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
                const aid = `<%=aid%>`;
                if(aid !=-1)
                {
                	const ocontent =String.raw `<%=content%>`;
                	const otitle = `<%=title%>`;
                	document.getElementById('title').value = otitle;
                	const deltaData = JSON.parse(ocontent); 
                	 quill.setContents(deltaData);
                }
            </script>
    </body>

    <%@ include file="footer.jsp" %>

    </html>