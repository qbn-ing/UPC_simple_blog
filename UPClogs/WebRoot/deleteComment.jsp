<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*" import="java.net.*"  import="java.text.*" import="java.util.*" %>
<% if (session.getAttribute("user_id") ==null) 
{ 
	response.sendRedirect("index.jsp"); 
	return; 
} 
String cidStr = request.getParameter("cid");
long cid = -1;
long uid = -1;
uid = (Long)session.getAttribute("user_id");

if (cidStr != null) 
{
    cid = Long.parseLong(cidStr);
    Comment com = Comment.findById(cid);
    long pid = com.getArticleId();
    if(com.getAuthorId()!=uid)
    {
    	response.sendRedirect("index.jsp"); 
    	return; 
    }
    com.delete();
    String from = request.getParameter("from");
    if(from!=null)
    {
    	response.sendRedirect(from); 
    	return; 
    }
    response.sendRedirect("article.jsp?pid="+ URLEncoder.encode(Long.toString(pid), "UTF-8"));
    return;
}
%>