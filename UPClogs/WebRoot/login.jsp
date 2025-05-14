<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*" %>
    <% if (session.getAttribute("user_id") !=null) { response.sendRedirect("index.jsp"); return; } %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <title>登录</title>
            <link rel="stylesheet" href="CSS/login.css">
        </head>

        <body>

            <div class="login">
                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="error">
                        <%= error %>
                    </div>
                    <% } %>
                        <form id="loginForm" method="post" action="postlogin.jsp">
                            <h2>欢迎回来</h2>

                            <div class="error-message" id="errorMsg"></div>

                            <div class="form-group">
                                <label for="name">昵称</label>
                                <input type=text id="name" name="name" placeholder="你叫什么名字呢" required maxlength="16">
                            </div>

                            <div class="form-group">
                                <label for="password">密码</label>
                                <input type="password" id="password" name="password" required minlength="8">
                            </div>

                            <button type="submit" class="btn btn-login">立即登录</button>

                            <p class="toggle-form">
                                新用户？<a href="singup.jsp">立即注册</a>
                            </p>
                        </form>
            </div>
        </body>