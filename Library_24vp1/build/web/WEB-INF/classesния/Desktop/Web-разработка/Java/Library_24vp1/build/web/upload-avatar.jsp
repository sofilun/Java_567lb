<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Object userObj = session.getAttribute("user"); //проверяется наличие объекта пользователя в сессии
    if (userObj == null) {
        response.sendRedirect("index.jsp"); //если нет, то перенаправляет на главную страницу
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Загрузка фото</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
        }
        .upload-box {
            background: white;
            padding: 30px;
            border: 2px dashed #4CAF50;
            border-radius: 10px;
            text-align: center;
        }
        input[type="file"] {
            margin: 20px 0;
        }
        button {
            padding: 10px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .nav {
            text-align: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="nav">
        <a href="profile.jsp"><button>← Назад в кабинет</button></a>
    </div>
    
    <div class="upload-box">
        <h2>Загрузка фотографии</h2>
        <p>Выберите файл для загрузки</p>
        <!-- action-куда отправлять файлы,upload-на url
        method-метод для отправки файлов, post-подходит для файлов
        enctype-определяет как кодируются данные, multipart/form-data-Разбивка на части с границами(работа с файлами)
        -->
        <form action="upload" method="post" enctype="multipart/form-data">
            <!-- type="file" - поле выбора файла с кнопкой
            name="avatar" - идентификатор поля на сервере
            accept="image/*" - все типы изображений
            required - "Пожалуйста, выберите файл"
            -->
            <input type="file" name="avatar" accept="image/*" required>
            <br>
            <button type="submit">Загрузить фото</button>
        </form>
        
        <p style="color: #666; margin-top: 20px;">
            Поддерживаются форматы: JPG, PNG, GIF<br>
            Максимальный размер: 5MB
        </p>
    </div>
</body>
</html>