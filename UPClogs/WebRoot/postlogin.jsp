<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
    String username = request.getParameter("name");
    String password = request.getParameter("password");
    if (username == null) {
        request.setAttribute("error", "用户名不能为空");
    } else if (password == null || password.length() < 8) {
        request.setAttribute("error", "密码至少需要8位");
    } else  {
    	long id = User.checkUser(username, password);
    	if(id != -1)
    	{
    		session.setAttribute("user_id", id);
            response.sendRedirect("index.jsp");
            return;
    	}
    	request.setAttribute("error", "用户名或密码错误");
    }
    request.getRequestDispatcher("login.jsp").forward(request, response);
    return;
%>