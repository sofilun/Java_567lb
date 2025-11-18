<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Регистрация</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            background: #f0f8ff;
        }
        .register-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input[type="text"], input[type="password"], input[type="email"], select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 0;
        }
        button:hover {
            background: #1976D2;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="register-box">
        <h2 style="text-align: center;">Регистрация в библиотеке</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="login" method="post">
            <input type="hidden" name="action" value="register">
            
            <input type="text" name="username" placeholder="Придумайте логин" required>
            <input type="password" name="password" placeholder="Придумайте пароль" required>
            <input type="email" name="email" placeholder="Ваш email" required>
            <input type="text" name="fullName" placeholder="Ваше ФИО" required>
            
            <label>Выберите тип аккаунта:</label>
            <select name="role">
                <option value="USER">Читатель</option>
                <option value="MODERATOR">Модератор</option>
                <option value="ADMIN">Администратор</option>
            </select>
            
            <button type="submit">Зарегистрироваться</button>
        </form>
        
        <div class="links">
            <a href="index.jsp">← Назад на главную</a>
        </div>
    </div>
</body>
</html>