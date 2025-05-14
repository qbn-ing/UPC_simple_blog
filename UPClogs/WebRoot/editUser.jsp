<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
 if (session.getAttribute("user_id") ==null) 
 { 
 	response.sendRedirect("manage.jsp"); 
 	return; 
 } 
 long uid = (Long)session.getAttribute("user_id");
 String userId = request.getParameter("userId");
 String username = request.getParameter("username");
 String role = request.getParameter("role");
 try
 {
	 User user1 = User.findById(uid);
	 if(!user1.getRole().equals("admin"))
	 {
	 	 response.sendRedirect("index.jsp"); 
	 	 return;
	 }
	 long uuid = Long.parseLong(userId);
	 if(uuid==uid&&role.equals("user"))//不能编辑自己自己为普通用户
	 {
		 response.sendRedirect("manage.jsp"); 
     	 return;
	 }
	 
     User user = User.findById(uuid);
    String existname = user.getName();
    if(!existname.equals(username)&&!User.checkUser(username))//不能重名
    {
    	user.setName(username);
    }
    user.setRole(role);
    user.save();
    response.sendRedirect("manage.jsp"); 
 	return;
 } catch(Exception e) 
 { 
 	
 } 
%>        