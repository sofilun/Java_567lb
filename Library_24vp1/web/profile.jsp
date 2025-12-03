<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User, java.util.Date, java.text.SimpleDateFormat" %>
<%
    // Увеличиваем счетчик при каждом посещении
    com.library.VisitCounter.incrementVisitCount(application);
    int visitCount = com.library.VisitCounter.getVisitCount(application);
    
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    User user = (User) userObj;
    
    // Получаем текущую дату и время для кабинета
    Date now = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    String currentDateTime = dateFormat.format(now);
    
    // Проверяем сообщения об успехе/ошибке
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Личный кабинет</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: #f0f2f5;
            min-height: 100vh;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: #4CAF50;
            color: white;
            padding: 25px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        .header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .stats {
            background: #f8f9fa;
            padding: 15px;
            margin: 15px;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
        }
        .stats h3 {
            margin-top: 0;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .profile-info {
            padding: 25px;
        }
        .profile-header {
            display: flex;
            align-items: center;
            gap: 25px;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid #eee;
        }
        .avatar-section {
            position: relative;
        }
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #4CAF50;
            object-fit: cover;
        }
        .user-details {
            flex-grow: 1;
        }
        .user-details h2 {
            margin: 0 0 10px;
            color: #333;
            font-size: 22px;
        }
        .user-details p {
            margin: 5px 0;
            color: #666;
        }
        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 8px;
        }
        .role-admin {
            background: #f44336;
            color: white;
        }
        .role-moderator {
            background: #2196F3;
            color: white;
        }
        .role-user {
            background: #4CAF50;
            color: white;
        }
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
        }
        .info-card h4 {
            margin: 0 0 15px;
            color: #333;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-card p {
            margin: 8px 0;
            color: #666;
        }
        .nav {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 25px;
            justify-content: center;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-success { 
            background: #2196F3; 
            color: white; 
        }
        .btn-success:hover { 
            background: #1976D2; 
        }
        .btn-danger { 
            background: #f44336; 
            color: white; 
        }
        .btn-danger:hover { 
            background: #d32f2f; 
        }
        .btn-secondary { 
            background: #6c757d; 
            color: white; 
        }
        .btn-secondary:hover { 
            background: #5a6268; 
        }
        .btn-catalog {
            background: #4CAF50;
            color: white;
        }
        .btn-catalog:hover {
            background: #45a049;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin: 15px;
            text-align: center;
            border-left: 4px solid #28a745;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin: 15px;
            text-align: center;
            border-left: 4px solid #dc3545;
        }
        .footer {
            text-align: center;
            padding: 15px;
            color: #666;
            font-size: 14px;
            border-top: 1px solid #eee;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Личный кабинет</h1>
            <p>Добро пожаловать в ваш персональный раздел</p>
        </div>
        
        <!-- Сообщения об успехе/ошибке -->
        <% if (success != null) { %>
            <div class="success">
                <% 
                    if ("info_updated".equals(success)) out.print("✅ Ваши данные успешно обновлены!");
                    else if ("avatar_updated".equals(success)) out.print("✅ Аватар успешно обновлен!");
                    else if ("avatar_deleted".equals(success)) out.print("✅ Аватар успешно удален!");
                    else if ("profile_updated".equals(success)) out.print("✅ Профиль успешно обновлен!");
                %>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="error">
                <% 
                    if ("update_failed".equals(error)) out.print("❌ Ошибка при обновлении данных!");
                    else if ("delete_failed".equals(error)) out.print("❌ Ошибка при удалении!");
                    else if ("upload_failed".equals(error)) out.print("❌ Ошибка при загрузке файла!");
                %>
            </div>
        <% } %>
        
        <!-- Статистика -->
        <div class="stats">
            <h3>📊 Информация о системе</h3>
            <p><strong>Всего посещений сайта:</strong> <%= visitCount %></p>
            <p><strong>Текущая дата и время:</strong> <%= currentDateTime %></p>
        </div>
        
        <!-- Основная информация профиля -->
        <div class="profile-info">
            <div class="profile-header">
                <div class="avatar-section">
                    <img src="images/<%= user.getAvatar() %>" alt="Аватар" class="avatar" 
                         onerror="this.src='images/default-avatar.png'">
                </div>
                <div class="user-details">
                    <h2><%= user.getFullName() %></h2>
                    <p><strong>Логин:</strong> <%= user.getUsername() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                    <p><strong>Роль:</strong> 
                        <span class="role-badge <%= 
                            "ADMIN".equals(user.getRole()) ? "role-admin" : 
                            "MODERATOR".equals(user.getRole()) ? "role-moderator" : "role-user" %>">
                            <%= user.getRole() %>
                        </span>
                    </p>
                </div>
            </div>
            
            <!-- Информация о профиле -->
            <div class="info-card">
                <h4>Информация о профиле</h4>
                <p><strong>Полное имя:</strong> <%= user.getFullName() %></p>
                <p><strong>Email адрес:</strong> <%= user.getEmail() %></p>
                <p><strong>Учетная запись:</strong> <%= user.getUsername() %></p>
                <p><strong>Статус:</strong> Активен</p>
            </div>
        </div>
        
        <!-- Навигация -->
        <div class="nav">
            <a href="catalog.jsp"><button class="btn-catalog">📚 В каталог</button></a>
            <a href="profile-edit"><button class="btn-success">✏️ Редактировать профиль</button></a>
            
            <% 
            if ("USER".equals(user.getRole())) {
            %>
                <a href="#"><button class="btn-secondary">📚 Мои книги</button></a>
            <%
            } else if ("MODERATOR".equals(user.getRole())) {
            %>
                <a href="#"><button class="btn-secondary">👨‍💼 Панель модератора</button></a>
            <%
            } else if ("ADMIN".equals(user.getRole())) {
            %>
                <a href="admin"><button class="btn-secondary">👑 Панель администратора</button></a>
            <%
            }
            %>
            
            <a href="index.jsp"><button class="btn-secondary">🏠 Главная страница</button></a>
            <a href="login?logout=true"><button class="btn-danger">🚪 Выйти</button></a>
        </div>
        
        <!-- Футер -->
        <div class="footer">
            <p>Личный кабинет пользователя • Библиотечная система</p>
        </div>
    </div>
</body>
</html> 
