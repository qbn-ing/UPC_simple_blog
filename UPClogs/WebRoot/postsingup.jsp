<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8" import="Mybean.*" %>
<%
    String username = request.getParameter("name");
    String password = request.getParameter("password");
    String password2 = request.getParameter("password2");
    if (username == null) {
        request.setAttribute("error", "用户名不能为空"+username);
    } else if (password == null || password.length() < 8||password2 == null||password2.length()<8) {
        request.setAttribute("error", "密码至少需要8位");
    } else if(!password.equals(password2))
    {
    	request.setAttribute("error", "两次密码不一致");
    }
    else if(User.checkUser(username))
    {
    	request.setAttribute("error", "该昵称已存在");
    }else
    {
    	
    	User user = new User(username,password,null);
    	try{
    		user.save();
    	}
    	catch(Exception e)
    	{
    		//e.printStackTrace();
    		request.setAttribute("error", "服务器出现问题，注册失败！");
    		request.getRequestDispatcher("singup.jsp").forward(request, response);
    		return;
    	}
    	long id = user.getId();
    	if(id != -1)
    	{
    		session.setAttribute("user_id", id);
            response.sendRedirect("index.jsp");
            return;
    	}
    	request.setAttribute("error", "服务器出现问题，注册失败");
    	
    }
    request.getRequestDispatcher("singup.jsp").forward(request, response);
    return;
%>