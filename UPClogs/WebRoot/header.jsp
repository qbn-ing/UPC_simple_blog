<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*" %>
    <!DOCTYPE html>
    <html>

    <head>
        <link rel="stylesheet" type="text/css" href="CSS/header.css">
    </head>

    <nav class="nav">
        <h1> <a href="index.jsp" class="index">我的极简博客</a></h1>
        <div>
            <%if (session.getAttribute("user_id")==null){%>
                <a href="login.jsp">登录</a>
                <% } else { long id=(Long)session.getAttribute("user_id"); String url1=null; try{
                    url1=User.findById(id).getAvatar(); } catch(Exception e) { } if(url1==null)url1="img/default.png" ;
                    %>
                    <a href="profile.jsp">
                        <img src="<%= url1 %>" class="avatar">
                    </a>
                    <a href="logout.jsp" class="btn btn-logout">退出</a>
                    <%} %>
        </div>
    </nav>

    </html>