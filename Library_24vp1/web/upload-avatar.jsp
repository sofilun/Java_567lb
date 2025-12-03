<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
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
        .error {
            color: red;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .success {
            color: green;
            background: #e6ffe6;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="nav">
        <a href="profile.jsp"><button>← Назад в кабинет</button></a>
    </div>
    
    <div class="upload-box">
        <h2>Загрузка фотографии</h2>
        
        <%-- Показываем текущий аватар --%>
        <div style="margin-bottom: 20px;">
            <img src="images/${user.avatar != null ? user.avatar : 'default-avatar.png'}" 
                 alt="Текущий аватар" style="width: 100px; height: 100px; border-radius: 50%; border: 2px solid #4CAF50;">
            <p>Текущее фото</p>
        </div>
        
        <%-- Сообщения об ошибках --%>
        <% if (error != null) { %>
            <div class="error">
                <% 
                    if ("no_file".equals(error)) out.print("Пожалуйста, выберите файл!");
                    else if ("upload_failed".equals(error)) out.print("Ошибка при загрузке файла!");
                    else out.print("Произошла ошибка!");
                %>
            </div>
        <% } %>
        
        <% if (success != null) { %>
            <div class="success">
                Аватар успешно обновлен!
            </div>
        <% } %>
        
        <p>Выберите файл для загрузки</p>
        
        <form action="upload" method="post" enctype="multipart/form-data">
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
