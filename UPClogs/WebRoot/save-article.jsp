<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" import="java.net.*" %>
<%if (session.getAttribute("user_id")==null){response.sendRedirect("login.jsp");return;}%>
<%
request.setCharacterEncoding("UTF-8");
String title = request.getParameter("title");
String content = request.getParameter("content");
long id=(Long)session.getAttribute("user_id");
String pidStr = request.getParameter("pid");
System.out.println(pidStr);
long pid = -1;
if (pidStr != null && !pidStr.isEmpty())
	pid = Long.parseLong(pidStr);
if (pid!=-1) {
    
    
    Article article = Article.findById(pid);
    if (article != null) {
        article.setTitle(request.getParameter("title"));
        article.setContent(request.getParameter("content"));
        article.save(); // 保存修改后的文章
        response.sendRedirect("article.jsp?pid="+ URLEncoder.encode(Long.toString(pid), "UTF-8"));
    	return;
    }
} else 
{
Article at = new Article(id,title,content);
try
{
	at.save();
	pid = at.getId();
	System.out.println(pid);
	response.sendRedirect("article.jsp?pid="+ URLEncoder.encode(Long.toString(pid), "UTF-8"));
	return;
}
catch(Exception e)
{
	e.printStackTrace();
}}
%>
         