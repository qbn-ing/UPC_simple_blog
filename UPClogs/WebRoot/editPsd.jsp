<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
 if (session.getAttribute("user_id") ==null) 
 { 
 	response.sendRedirect("manage.jsp"); 
 	return; 
 } 
 long uid = (Long)session.getAttribute("user_id");
 String newPsd = request.getParameter("newPassword");
 String newPsd2 = request.getParameter("confirmPassword");
 String role = request.getParameter("role");
 try
 {
	 User user1 = User.findById(uid);
	 
    user1.save();
    response.sendRedirect("index.jsp"); 
 	return;
 } catch(Exception e) 
 { 
 	
 } 
%>        