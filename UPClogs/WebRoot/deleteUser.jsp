<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
 <%
 if (session.getAttribute("user_id") ==null) 
 { 
 	response.sendRedirect("manage.jsp"); 
 	return; 
 } 
 long uid = (Long)session.getAttribute("user_id");

 String uidStr = request.getParameter("uid");
 if(uidStr == null)
 {
	 response.sendRedirect("index.jsp"); 
	 	return; 
 }
 try
 {
	 User user1 = User.findById(uid);
	 if(!user1.getRole().equals("admin"))
	 {
	 	 response.sendRedirect("index.jsp"); 
	 	 return;
	 }
	 long uuid = Long.parseLong(uidStr);
	 if(uuid==uid)//不能删除自己
	 {
		 response.sendRedirect("manage.jsp"); 
     	 return;
	 }
     User user = User.findById(uuid);
     user.delete();
     response.sendRedirect("manage.jsp"); 
 	 return;
 } catch(Exception e) 
 { 
 	
 } 
%>        