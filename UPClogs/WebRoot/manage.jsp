<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Mybean.*"  import="java.text.*" import="java.util.*" %>
<% if (session.getAttribute("user_id") ==null) 
{ 
	response.sendRedirect("index.jsp"); 
	return; 
} 
long uid = (Long)session.getAttribute("user_id");
SimpleDateFormat sdff=new SimpleDateFormat("yyyy年MM月dd日");
String url11=null; 
List<User> list = null;
try
{
    User user = User.findById(uid);
    if(!user.getRole().equals("admin"))
    {
    	 response.sendRedirect("index.jsp"); 
    	 return;
    }
   list = User.getAll(); 	
    
} catch(Exception e) 
{ 
	
} 
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理</title>
    <link rel="stylesheet" href="CSS/manage.css">
</head>
<body>
<%@ include file="header.jsp" %>
    <div class="user-management">
        <aside class="sidebar">
            <h3>用户管理</h3>
            <div class="nav-links">
                <a href="#" class="active" data-target="userList">
                    <span class="icon">👥</span> 用户列表
                </a>
                <a href="#" data-target="addUser">
                    <span class="icon">➕</span> 添加用户
                </a>
            </div>
        </aside>

        <main class="content-section">
        <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="error">
                        <%= error %>
                    </div>
                    <% } %>
            <div id="userListSection" class="section-content">
                <h2 class="section-title">用户列表</h2>
                <div id="userList">
                <%if(list == null) 
                {
                %>
                        <div>
                            <center>
                                <h2>还没有用户呢~(￣▽￣)~*</h2>
                            </center>
                        </div>
                <%}
                else
                {
                	for(User __ :list)
                	{
                %>
                <div class="user-card">
                    <div class="user-avatar">
                        <img src="<%=__.getAvatar() %>">
                    </div>
                    <div class="user-info">
                        <h3><%=__.getName() %></h3>
                        <p>角色：<%= (__.getRole().equals("admin")? "管理员" : "普通用户")%></p>
                        <p>注册时间：<%= sdff.format(__.getRegTime())%></p>
                    </div>
                    <div class="user-actions">
                    
                        <a><button class="btn-action btn-edit" onclick="editUser('<%=__.getId()%>', '<%=__.getName()%>', '<%=__.getRole()%>')">编辑</button></a>
                        <a href="deleteUser.jsp?uid=<%=__.getId()%>"><button class="btn-action btn-delete" >删除</button></a>
                    </div>
                </div>
                <%}} %></div>
            </div>
				
            <div id="addUserSection" class="section-content" style="display: none;">
            
                <h2 class="section-title">添加新用户</h2>
                <form id="addUserForm" method = "post" action="addNewUser.jsp">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" id="username" name="newName" required maxlength="16">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" id="newPassword" name="newPWD" required minlength="8">

                    </div>
                    <button type="submit" class="btn-save">创建用户</button>
                </form>
            </div>

            <div id="editUserSection" class="section-content" style="display: none;">
                <h2 class="section-title">编辑用户</h2>
				<form id="editUserForm" method="post" action="editUser.jsp">
				    <div class="form-group">
				        <label>用户名</label>
				        <input type="text" id="editUsername" name="username" required>
				    </div>
				    <div class="form-group">
				        <label>角色</label>
				        <select id="editRole" name="role">
				            <option value="user">普通用户</option>
				            <option value="admin">管理员</option>
				        </select>
				    </div>
				    <input type="hidden" id="editUserId" name="userId">
				    <button type="submit" class="btn-save">保存修改</button>
				    <button type="button" class="btn-action btn-delete" onclick="hideModal()">取消</button>
				</form>
            </div>
        </main>
        
    </div>
    <%@ include file="footer.jsp" %>
    <script>
    function setupEventListeners() 
    {
    	document.querySelectorAll('.nav-links a').forEach(link => {
    		link.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.nav-link').forEach(item => {
                    item.classList.remove('active');
                });
                this.classList.add('active');
                
                const targetSection = this.dataset.target + 'Section';
                console.log(targetSection);
                document.querySelectorAll('.section-content').forEach(section => {
                    section.style.display = 'none';
                });
                document.getElementById(targetSection).style.display = 'block';
        });
    })
    }
    function editUser(userId, userName, userRole) {
    	document.getElementById('userListSection').style.display = 'none';
        document.getElementById('editUserSection').style.display = 'block';

        document.getElementById('editUsername').value = userName; 
        document.getElementById('editRole').value = userRole;     
        document.getElementById('editUserId').value = userId;
        const userIdField = document.createElement('input');
        userIdField.type = 'hidden';
        userIdField.name = 'userId'; 
        userIdField.value = userId;
        const form = document.getElementById('editUserForm');
        const existingUserIdField = form.querySelector('input[name="userId"]');
        if (existingUserIdField) {
            existingUserIdField.remove(); 
        }
        form.appendChild(userIdField); 
    }

    function hideModal() {
    	document.getElementById('userListSection').style.display = 'block';
        document.getElementById('addUserSection').style.display = 'none';
        document.getElementById('editUserSection').style.display = 'none';
    }
    setupEventListeners();
    hideModal();
    </script>
    </body>
</html>