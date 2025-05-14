<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
if (session.getAttribute("user_id") ==null) 
{ 
	response.sendRedirect("manage.jsp"); 
	return; 
} 
long uid = (Long)session.getAttribute("user_id");

    String username = request.getParameter("newName");
    String password = request.getParameter("newPWD");
    System.out.println(username);
    if (username == null) {
        request.setAttribute("error", "用户名不能为空"+username);
        request.getRequestDispatcher("manage.jsp").forward(request, response);
		return;
    } else if (password == null) {
        request.setAttribute("error", "密码至少需要8位");
        request.getRequestDispatcher("manage.jsp").forward(request, response);
		return;
    } 
    else if(User.checkUser(username))
    {
    	request.setAttribute("error", "该昵称已存在");
    	request.getRequestDispatcher("manage.jsp").forward(request, response);
		return;
    }else
    {
    	
    	User user = new User(username,password,null);
    	try{
    		User user1 = User.findById(uid);
    		 if(!user1.getRole().equals("admin"))
    		 {
    		 	 response.sendRedirect("index.jsp"); 
    		 	 return;
    		 }
    		user.save();
    		response.sendRedirect("manage.jsp");
    		return;
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    		request.setAttribute("error", "服务器出现问题，注册失败！");
    		request.getRequestDispatcher("manage.jsp").forward(request, response);
    		return;
    	}
    	
    }
    //response.sendRedirect("manage.jsp");
    //return;
%>