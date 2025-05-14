<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <title>用户登录</title>
        <link rel="stylesheet" href="CSS/singup.css">
    </head>

    <body>
        <div class="singup">
            <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                <div class="error">
                    <%= error %>
                </div>
                <% } %>
                    <form id="registerForm" method="post" action="postsingup.jsp">
                        <h2>创建账户</h2>

                        <div class="error-message" id="regErrorMsg"></div>

                        <div class="form-group">
                            <label for="username">昵称</label>
                            <input type="text" id="username" name="name" placeholder="你叫什么名字呢" required minlength="3">
                        </div>

                        <div class="form-group">
                            <label for="password">密码</label>
                            <input type="password" id="password" name="password" required minlength="8">
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">确认密码</label>
                            <input type="password" id="confirmPassword" name="password2" required minlength="8">
                        </div>

                        <button type="submit" class="btn btn-register">立即注册</button>

                        <p class="toggle-form">
                            已有账号？<a href="login.jsp"">立即登录</a>
                        </p>
                    </form>
        </div>
    </body>

    </html>