<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User, java.util.List" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null || !"ADMIN".equals(((User)userObj).getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    List<User> allUsers = (List<User>) request.getAttribute("allUsers");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Панель администратора</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .header {
            background: #dc3545;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }
        .nav {
            text-align: center;
            margin: 20px 0;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        
        .users-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #343a40;
            color: white;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .success { color: #28a745; padding: 10px; background: #d4edda; border-radius: 5px; }
        .error { color: #dc3545; padding: 10px; background: #f8d7da; border-radius: 5px; }
        .form-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
            z-index: 1000;
            width: 400px;
        }
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        .avatar-container {
            text-align: center;
            margin: 10px 0;
        }
        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 2px solid #007bff;
        }
        .no-avatar {
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>⚙️ Панель администратора</h1>
        <p>Управление пользователями системы</p>
    </div>
    
    <div class="nav">
        <a href="profile.jsp"><button class="btn-secondary">← В кабинет</button></a>
        <a href="book-manager"><button class="btn-success">📚 Управление книгами</button></a>
        <a href="index.jsp"><button class="btn-secondary">На главную</button></a>
    </div>
    
    <% if (success != null) { %>
        <div class="success">
            <% 
                if ("role_updated".equals(success)) out.print("Роль пользователя успешно обновлена!");
                else if ("user_updated".equals(success)) out.print("Данные пользователя успешно обновлены!");
                else if ("user_deleted".equals(success)) out.print("Пользователь успешно удален!");
                else if ("avatar_deleted".equals(success)) out.print("Аватар пользователя успешно удален!");
                else if ("avatar_changed".equals(success)) out.print("Аватар пользователя успешно изменен!");
                else if ("user_created".equals(success)) out.print("Пользователь успешно создан!");
            %>
        </div>
    <% } %>
    
    <% if (error != null) { %>
        <div class="error">
            <% 
                if ("missing_fields".equals(error)) out.print("Заполните все обязательные поля!");
                else if ("username_exists".equals(error)) out.print("Пользователь с таким логином уже существует!");
                else if ("create_failed".equals(error)) out.print("Ошибка при создании пользователя!");
                else if ("update_failed".equals(error)) out.print("Ошибка при обновлении данных!");
                else if ("delete_failed".equals(error)) out.print("Ошибка при удалении!");
                else if ("cannot_delete_self".equals(error)) out.print("Нельзя удалить собственный аккаунт!");
                else if ("server_error".equals(error)) out.print("Ошибка сервера!");
                else if ("no_username".equals(error)) out.print("Не указано имя пользователя!");
                else if ("user_not_found".equals(error)) out.print("Пользователь не найден!");
                else if ("no_file".equals(error)) out.print("Не выбран файл для загрузки!");
                else if ("upload_failed".equals(error)) out.print("Ошибка при загрузке файла!");
            %>
        </div>
    <% } %>
    
    <div class="users-table">
        <h2 style="padding: 20px; margin: 0;">Список пользователей</h2>
        <table>
            <thead>
                <tr>
                    <th>Логин</th>
                    <th>ФИО</th>
                    <th>Email</th>
                    <th>Роль</th>
                    <th>Аватар</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <% for (User u : allUsers) { %>
                <tr>
                    <td><strong><%= u.getUsername() %></strong></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td>
                        <form action="admin" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="updateRole">
                            <input type="hidden" name="username" value="<%= u.getUsername() %>">
                            <select name="role" onchange="this.form.submit()">
                                <option value="USER" <%= "USER".equals(u.getRole()) ? "selected" : "" %>>USER</option>
                                <option value="MODERATOR" <%= "MODERATOR".equals(u.getRole()) ? "selected" : "" %>>MODERATOR</option>
                                <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>ADMIN</option>
                            </select>
                        </form>
                    </td>
                    <td>
                        <div class="avatar-container">
                            <% if ("default-avatar.png".equals(u.getAvatar())) { %>
                                <div class="no-avatar">Аватар не установлен</div>
                            <% } else { %>
                                <img src="images/<%= u.getAvatar() %>" alt="Аватар" class="avatar">
                            <% } %>
                        </div>
                    </td>
                    <td>
                        <button class="btn-primary" onclick="openEditForm(
                            '<%= u.getUsername() %>', 
                            '<%= u.getEmail() %>', 
                            '<%= u.getFullName() %>',
                            '<%= u.getAvatar() %>'
                        )">Редактировать</button>
                        
                        <% if (!"default-avatar.png".equals(u.getAvatar())) { %>
                        <form action="admin" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="deleteAvatar">
                            <input type="hidden" name="username" value="<%= u.getUsername() %>">
                            <button type="submit" class="btn-warning" onclick="return confirm('Удалить аватар пользователя <%= u.getUsername() %>?')">
                                Удалить аватар
                            </button>
                        </form>
                        <% } %>
                        
                        <% if (!u.getUsername().equals(((User)userObj).getUsername())) { %>
                        <form action="admin" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="username" value="<%= u.getUsername() %>">
                            <button type="submit" class="btn-danger" onclick="return confirm('Удалить пользователя <%= u.getUsername() %>?')">
                                Удалить
                            </button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Форма редактирования пользователя -->
    <div id="overlay" class="overlay" onclick="closeEditForm()"></div>
    <div id="editForm" class="form-popup">
        <h3>Редактирование пользователя</h3>
        
        <div class="avatar-container">
            <div id="currentAvatarInfo"></div>
        </div>
        
        <form action="admin" method="post">
            <input type="hidden" name="action" value="updateUser">
            <input type="hidden" name="username" id="editUsername">
            
            <div style="margin: 10px 0;">
                <label>Email:</label>
                <input type="email" name="email" id="editEmail" required style="width: 100%; padding: 8px; margin: 5px 0;">
            </div>
            
            <div style="margin: 10px 0;">
                <label>ФИО:</label>
                <input type="text" name="fullName" id="editFullName" required style="width: 100%; padding: 8px; margin: 5px 0;">
            </div>
            
            <div style="margin: 10px 0;">
                <label>Новый пароль (оставьте пустым, чтобы не менять):</label>
                <input type="password" name="password" id="editPassword" style="width: 100%; padding: 8px; margin: 5px 0;">
                <small style="color: #666;">Минимум 6 символов</small>
            </div>
            
            <div style="text-align: center; margin-top: 20px;">
                <button type="submit" class="btn-success">Сохранить</button>
                <button type="button" class="btn-secondary" onclick="closeEditForm()">Отмена</button>
            </div>
        </form>
    </div>

    <script>
        function openEditForm(username, email, fullName, avatar) {
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editPassword').value = '';
            
            // Показываем информацию об аватаре
            const avatarInfo = document.getElementById('currentAvatarInfo');
            if (avatar === 'default-avatar.png') {
                avatarInfo.innerHTML = '<div class="no-avatar">Аватар не установлен</div>';
            } else {
                avatarInfo.innerHTML = '<img src="images/' + avatar + '" alt="Аватар" class="avatar"><br><small>Текущий аватар</small>';
            }
            
            document.getElementById('editForm').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }
        
        function closeEditForm() {
            document.getElementById('editForm').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }
    </script>
</body>
</html>
