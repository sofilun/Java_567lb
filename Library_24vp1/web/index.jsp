<%@page contentType="text/html" pageEncoding="UTF-8"%> <!-- JSP директива, которая задает параметры страницы -->

<%@page import="com.library.VisitCounter, java.util.Date, java.text.SimpleDateFormat" %> <!-- импортирует Java-классы -->
<%
    
    HttpSession Usersession = request.getSession(false);
    if (session != null) {
        session.invalidate();
    }

    //увеличиваем счетчик при каждом посещении
    VisitCounter.incrementVisitCount(application); //application - встроенный JSP объект, представляющий контекст приложения
    //получает значение с счетчика
    int visitCount = VisitCounter.getVisitCount(application);
    
    // Получаем текущую дату и время сервера
    Date now = new Date();
    //объект для форматирования даты по приведенному шаблону
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    //преобразует дату в строку по формату
    String currentDateTime = dateFormat.format(now);
    
    // Проверяем параметр ошибки, получает значение параметра "error" из URL запроса    
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Библиотека - Главная</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f0f8ff;
        }
        .header {
            text-align: center;
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .stats {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid #ddd;
        }
        .login-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin: 20px 0;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 0;
        }
        button:hover {
            background: #45a049;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .error {
            color: red;
            text-align: center;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 Библиотека "Читай-Город"</h1>
        <p>Добро пожаловать в нашу онлайн-библиотеку!</p>
    </div>
    
    <!-- Блок со статистикой -->
    <div class="stats">
        <h3>📊 Статистика сайта</h3>
        <p><strong>Всего посещений:</strong> <%= visitCount %></p>
        <p><strong>Текущая дата и время:</strong> <%= currentDateTime %></p>
    </div>

    <div class="login-box">
        <h2>Вход в систему</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error">Неверный логин или пароль!</div>
        <% } %>
        
        <form action="login" method="post">
            <input type="text" name="username" placeholder="Введите логин" required>
            <input type="password" name="password" placeholder="Введите пароль" required>
            <button type="submit">Войти</button>
        </form>
        
        <div class="links">
            <p>Нет аккаунта? <a href="register.jsp">Зарегистрироваться</a></p>
        </div>
    </div>

    <div style="text-align: center; margin-top: 30px;">
        <h3>О нашей библиотеке</h3>
        <p>Мы предлагаем книги различных жанров для всех возрастов.</p>
        <p>Присоединяйтесь к нашему сообществу читателей!</p>
    </div>
</body>
</html>