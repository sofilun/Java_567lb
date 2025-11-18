<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="com.library.VisitCounter, java.util.Date, java.text.SimpleDateFormat" %>
<%
    // Увеличиваем счетчик при каждом посещении
    VisitCounter.incrementVisitCount(application); //application - встроенный JSP объект, представляющий контекст приложения
    //получает значение с счетчика
    int visitCount = VisitCounter.getVisitCount(application);
    
    Object userObj = session.getAttribute("user"); //получает объект пользователя из сессии
    if (userObj == null) { //не авторизован
        response.sendRedirect("index.jsp"); //перенаправление на главную страницу
        return;
    }
    
    // Получаем текущую дату и время для кабинета
    Date now = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    String currentDateTime = dateFormat.format(now);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Личный кабинет</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: #f9f9f9;
        }
        .header {
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .stats {
            background: white;
            padding: 15px;
            margin: 15px 0;
            border-radius: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .profile-info {
            background: white;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
            border: 1px solid #ddd;
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 3px solid #4CAF50;
            margin: 10px;
        }
        button {
            padding: 10px 20px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        button:hover {
            background: #1976D2;
        }
        .nav {
            text-align: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Личный кабинет</h1>
    </div>
    
    <!-- Статистика в кабинете -->
    <div class="stats">
        <h3>📊 Информация о сессии</h3>
        <p><strong>Текущее время сервера:</strong> <%= currentDateTime %></p>
        <p><strong>Всего посещений сайта:</strong> <%= VisitCounter.getVisitCount(application) %></p>
    </div>
    
    <div class="nav">
        <a href="profile.jsp"><button>Мой профиль</button></a>
        <a href="upload-avatar.jsp"><button>Сменить фото</button></a>
        <% 
        if (userObj != null) {
            //getRole() - метод класса User, возвращающий роль пользователя
            String role = ((com.library.User)userObj).getRole(); //(com.library.User)userObj - приведение Object к конкретному типу User            
            if ("USER".equals(role)) { //методо сравнение role и USER
    %>
                <a><button>Мои книги</button></a>
    <%
            } else if ("MODERATOR".equals(role)) {
    %>
                <a><button>Панель модератора</button></a>
    <%
            } else if ("ADMIN".equals(role)) {
    %>
                <a><button>Панель администратора</button></a>
    <%
            }
        }
    %>
        <a href="index.jsp"><button>На главную</button></a>
        <a href="login?logout=true"><button>Выйти</button></a>
        
    </div>
    
    <div class="profile-info">
        <div style="text-align: center;">
            <img src="images/default-avatar.png" alt="Аватар" class="avatar">
            <h2>${user.fullName}</h2>
            <p><strong>Логин:</strong> ${user.username}</p>
            <p><strong>Email:</strong> ${user.email}</p>
            <p><strong>Роль:</strong> ${user.role}</p>
        </div>
    </div>
    
    <div style="text-align: center; color: #666;">
        <p>Это ваша личная страница в библиотеке</p>
        <p>Здесь вы можете управлять своим профилем</p>
    </div>
</body>
</html>