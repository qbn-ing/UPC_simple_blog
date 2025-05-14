<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" import="java.net.*" %>
<%if (session.getAttribute("user_id")==null){response.sendRedirect("login.jsp");return;}%>
<%
request.setCharacterEncoding("UTF-8");
String content = request.getParameter("content");
long id=(Long)session.getAttribute("user_id");
String pidStr = request.getParameter("pid");
long pid = -1;
if (pidStr != null) {
	
    pid = Long.parseLong(pidStr);
    Comment comment = new Comment(pid,id,content);
    try
    {
    	comment.save();
    	response.sendRedirect("article.jsp?pid="+ URLEncoder.encode(Long.toString(pid), "UTF-8"));
    	return;
    }
    catch(Exception e)
    {
    	e.printStackTrace();
    }
}
%>