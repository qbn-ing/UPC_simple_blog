<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" import="java.util.*" import="java.text.*"%>
<% 
if (session.getAttribute("user_id") ==null) 
{ 
	response.sendRedirect("index.jsp"); 
	return; 
} 
String pidStr = request.getParameter("pid");
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
    	if(article.getAuthorId()==uid)
    	{
    		article.delete();
    	}
    	
    	response.sendRedirect("index.jsp");
		return;
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
       
         
%>