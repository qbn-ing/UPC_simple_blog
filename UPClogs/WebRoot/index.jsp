<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*"  import="java.util.*" %>
<%
String role = "user";

if (session.getAttribute("user_id") !=null) 
{ 
	long uid = (Long)session.getAttribute("user_id");
	try
	{
	    User user = User.findById(uid);
	    role = user.getRole();	    
	} catch(Exception e) 
	{ 
		
	} 
} 
%>

    <!DOCTYPE html>
    <html>

    <head>
        <title>博客首页</title>
        <link rel="stylesheet" href="CSS/index.css">
    </head>

    <body>
        <%@ include file="header.jsp" %>
            <div class="container">
                <div class="new-article">
                	<%if (session.getAttribute("user_id") !=null) { %>
                    <center><a href="new_article.jsp" class="btn-publish">发布新文章</a>
                    
                    <%} if(role.equals("admin")) {%>
                    <a href="manage.jsp" class="btn-publish">管理用户</a></center>
                    <%} %>
                </div>
                <section class="post-list">
                    <% List<Article> list = null;
                        try{
                        list = Article.getAll();
                        }catch(Exception e)
                        {

                        }
                        if(list == null)
                        {
                        %>
                        <div>
                            <center>
                                <h2>还没有文章呢~(￣▽￣)~*</h2>
                            </center>
                        </div>
                        <%}else{ %>
                            <% for (int i = list.size() - 1; i >= 0; i--) {
                                Article article = list.get(i);  %>
                                <article class="post-card">
                                    <h2>
                                        <%= article.getTitle() %>
                                    </h2>
                                    </a>
                                    <p>
                                        <%= article.getText() %>...
                                    </p>
                                    <a href="article.jsp?pid=<%= article.getId() %>" class="btn">阅读全文</a>
                                </article>
                                <% } %>
                                    <% } %>

                </section>
            </div>
            
            <center>
            	<button id="playButton" class="btn-publish" >播放背景音乐</button>
    		</center>
    		<audio id="bgmMusic" loop="loop">
        		<source src="bgm.mp3" type="audio/mpeg">
    		</audio>
            <%@ include file="footer.jsp" %>
	<script>
	const audio = document.getElementById("bgmMusic");
    const playButton = document.getElementById("playButton");
    playButton.addEventListener("click", () => {
        audio.play();
        playButton.style.display = "none";
    });
	</script>
    </body>

    </html>