<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    User user = (User) userObj;
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Редактирование профиля</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background: #f8f9fa;
        }
        .header {
            background: #007bff;
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
        .btn-secondary { background: #6c757d; color: white; }
        
        .profile-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .avatar-container {
            text-align: center;
            margin: 20px 0;
        }
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 3px solid #007bff;
            object-fit: cover;
        }
        .avatar-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 3px solid #28a745;
            margin: 15px auto;
            display: block;
            object-fit: cover;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.25);
        }
        .success {
            color: #28a745;
            padding: 12px;
            background: #d4edda;
            border-radius: 5px;
            margin: 15px 0;
            text-align: center;
        }
        .error {
            color: #dc3545;
            padding: 12px;
            background: #f8d7da;
            border-radius: 5px;
            margin: 15px 0;
            text-align: center;
        }
        .info-box {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #007bff;
        }
        .tabs {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 2px solid #dee2e6;
        }
        .tab {
            padding: 12px 20px;
            cursor: pointer;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-bottom: none;
            border-radius: 5px 5px 0 0;
            margin-right: 5px;
        }
        .tab.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>✏️ Редактирование профиля</h1>
        <p>Измените свои личные данные</p>
    </div>
    
    <div class="nav">
        <a href="profile.jsp"><button class="btn-secondary">← Назад в кабинет</button></a>
        <a href="index.jsp"><button class="btn-secondary">На главную</button></a>
    </div>
    
    <% if (success != null) { %>
        <div class="success">
            <% 
                if ("info_updated".equals(success)) out.print("✅ Данные успешно обновлены!");
                else if ("avatar_updated".equals(success)) out.print("✅ Аватар успешно обновлен!");
                else if ("avatar_deleted".equals(success)) out.print("✅ Аватар успешно удален!");
            %>
        </div>
    <% } %>
    
    <% if (error != null) { %>
        <div class="error">
            <% 
                if ("missing_fields".equals(error)) out.print("❌ Заполните все обязательные поля!");
                else if ("update_failed".equals(error)) out.print("❌ Ошибка при обновлении данных!");
                else if ("delete_failed".equals(error)) out.print("❌ Ошибка при удалении аватара!");
                else if ("server_error".equals(error)) out.print("❌ Ошибка сервера!");
                else if ("no_file".equals(error)) out.print("❌ Не выбран файл для загрузки!");
                else if ("upload_failed".equals(error)) out.print("❌ Ошибка при загрузке файла!");
                else if ("password_mismatch".equals(error)) out.print("❌ Пароли не совпадают!");
            %>
        </div>
    <% } %>
    
    <div class="profile-box">
        <!-- Вкладки -->
        <div class="tabs">
            <div class="tab active" onclick="switchTab('personal')">📋 Личные данные</div>
            <div class="tab" onclick="switchTab('avatar')">🖼️ Аватар</div>
            <div class="tab" onclick="switchTab('password')">🔐 Смена пароля</div>
        </div>
        
        <!-- Вкладка: Личные данные -->
        <div id="personalTab" class="tab-content active">
            <h3 style="margin-top: 0;">Личная информация</h3>
            
            <div class="avatar-container">
                <img src="images/<%= user.getAvatar() %>" alt="Аватар" class="avatar" 
                     onerror="this.src='images/default-avatar.png'">
                <p><strong><%= user.getFullName() %></strong></p>
                <p>Роль: <%= user.getRole() %></p>
            </div>
            
            <form action="profile-edit" method="post">
                <input type="hidden" name="action" value="updateInfo">
                
                <div class="form-group">
                    <label for="username">Логин:</label>
                    <input type="text" id="username" value="<%= user.getUsername() %>" disabled>
                    <small style="color: #666;">Логин нельзя изменить</small>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="fullName">ФИО *</label>
                    <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="role">Роль:</label>
                    <input type="text" id="role" value="<%= user.getRole() %>" disabled>
                    <small style="color: #666;">Роль может изменить только администратор</small>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn-success">Сохранить изменения</button>
                    <button type="button" class="btn-secondary" onclick="window.location.href='profile.jsp'">Отмена</button>
                </div>
            </form>
        </div>
        
        <!-- Вкладка: Аватар -->
        <div id="avatarTab" class="tab-content">
            <h3 style="margin-top: 0;">Управление аватаром</h3>
            
            <div class="avatar-container">
                <% if ("default-avatar.png".equals(user.getAvatar())) { %>
                    <div style="text-align: center; padding: 20px; border: 2px dashed #ccc; border-radius: 10px;">
                        <div style="font-size: 48px; color: #6c757d;">👤</div>
                        <p style="color: #6c757d;">Аватар не установлен</p>
                    </div>
                <% } else { %>
                    <img src="images/<%= user.getAvatar() %>" alt="Текущий аватар" class="avatar" 
                         onerror="this.src='images/default-avatar.png'">
                    <p><strong>Текущий аватар</strong></p>
                <% } %>
            </div>
            
            <!-- Форма загрузки нового аватара -->
            <div style="margin: 30px 0;">
                <h4>Загрузить новый аватар</h4>
                <form action="profile-edit" method="post" enctype="multipart/form-data" id="avatarForm">
                    <input type="hidden" name="action" value="uploadAvatar">
                    
                    <div class="form-group">
                        <label>Выберите файл:</label>
                        <input type="file" name="avatar" accept="image/*" required 
                               onchange="previewAvatar(this)">
                    </div>
                    
                    <div style="text-align: center; margin: 20px 0;">
                        <img id="avatarPreview" class="avatar-preview" style="display: none;">
                    </div>
                    
                    <div class="info-box">
                        <strong>💡 Требования к файлу:</strong><br>
                        • Форматы: JPG, PNG, GIF<br>
                        • Максимальный размер: 5MB<br>
                        • Рекомендуемый размер: 200x200 пикселей
                    </div>
                    
                    <div style="text-align: center; margin-top: 20px;">
                        <button type="submit" class="btn-success">Загрузить новый аватар</button>
                    </div>
                </form>
            </div>
            
            <!-- Кнопка удаления аватара (только если не дефолтный) -->
            <% if (!"default-avatar.png".equals(user.getAvatar())) { %>
            <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                <h4>Удалить текущий аватар</h4>
                <p style="color: #666; margin-bottom: 20px;">
                    После удаления будет установлен аватар по умолчанию.
                </p>
                <form action="profile-edit" method="post" 
                      onsubmit="return confirm('Вы уверены, что хотите удалить свой аватар?')">
                    <input type="hidden" name="action" value="deleteAvatar">
                    <div style="text-align: center;">
                        <button type="submit" class="btn-danger">🗑️ Удалить аватар</button>
                    </div>
                </form>
            </div>
            <% } %>
        </div>
        
        <!-- Вкладка: Смена пароля -->
        <div id="passwordTab" class="tab-content">
            <h3 style="margin-top: 0;">Смена пароля</h3>
            
            <div class="info-box">
                <strong>💡 Безопасность пароля:</strong><br>
                • Используйте не менее 6 символов<br>
                • Сочетайте буквы, цифры и символы<br>
                • Не используйте простые пароли
            </div>
            
            <form action="profile-edit" method="post" id="passwordForm">
                <input type="hidden" name="action" value="updateInfo">
                
                <div class="form-group">
                    <label for="newPassword">Новый пароль *</label>
                    <input type="password" id="newPassword" name="password" required 
                           minlength="6" oninput="checkPasswordStrength(this.value)">
                    <small id="passwordStrength" style="display: none;"></small>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Подтвердите пароль *</label>
                    <input type="password" id="confirmPassword" required 
                           oninput="checkPasswordMatch()">
                    <small id="passwordMatch" style="display: none;"></small>
                </div>
                
                <div style="margin: 20px 0;">
                    <div class="form-group">
                        <label for="currentEmail">Текущий email (для подтверждения):</label>
                        <input type="email" id="currentEmail" value="<%= user.getEmail() %>" disabled>
                    </div>
                    
                    <div class="form-group">
                        <label for="currentFullName">Текущее ФИО (для подтверждения):</label>
                        <input type="text" id="currentFullName" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn-success" id="changePasswordBtn" disabled>Изменить пароль</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Переключение вкладок
        function switchTab(tabName) {
            // Скрыть все вкладки
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Показать выбранную вкладку
            document.getElementById(tabName + 'Tab').classList.add('active');
            event.target.classList.add('active');
        }
        
        // Превью аватара
        function previewAvatar(input) {
            const preview = document.getElementById('avatarPreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
                preview.src = '';
            }
        }
        
        // Проверка сложности пароля
        function checkPasswordStrength(password) {
            const strengthElement = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strengthElement.style.display = 'none';
                return;
            }
            
            let strength = 0;
            let message = '';
            let color = '';
            
            // Проверка длины
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            
            // Проверка на наличие цифр
            if (/\d/.test(password)) strength++;
            
            // Проверка на наличие букв разного регистра
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            
            // Проверка на наличие специальных символов
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            // Определение уровня сложности
            if (strength <= 2) {
                message = '❌ Слабый пароль';
                color = '#dc3545';
            } else if (strength <= 4) {
                message = '⚠️ Средний пароль';
                color = '#ffc107';
            } else {
                message = '✅ Сильный пароль';
                color = '#28a745';
            }
            
            strengthElement.innerHTML = '<span style="color: ' + color + '">' + message + '</span>';
            strengthElement.style.display = 'block';
        }
        
        // Проверка совпадения паролей
        function checkPasswordMatch() {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchElement = document.getElementById('passwordMatch');
            const submitBtn = document.getElementById('changePasswordBtn');
            
            if (password === '' || confirmPassword === '') {
                matchElement.style.display = 'none';
                submitBtn.disabled = true;
                return;
            }
            
            if (password === confirmPassword) {
                matchElement.innerHTML = '<span style="color: #28a745;">✅ Пароли совпадают</span>';
                matchElement.style.display = 'block';
                submitBtn.disabled = false;
            } else {
                matchElement.innerHTML = '<span style="color: #dc3545;">❌ Пароли не совпадают</span>';
                matchElement.style.display = 'block';
                submitBtn.disabled = true;
            }
        }
        
        // Валидация формы смены пароля
        document.getElementById('passwordForm').addEventListener('submit', function(event) {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                event.preventDefault();
                alert('Пароли не совпадают!');
                return false;
            }
            
            if (password.length < 6) {
                event.preventDefault();
                alert('Пароль должен содержать минимум 6 символов!');
                return false;
            }
            
            return confirm('Вы уверены, что хотите изменить пароль?');
        });
        
        // Валидация формы аватара
        document.getElementById('avatarForm').addEventListener('submit', function(event) {
            const fileInput = document.querySelector('input[name="avatar"]');
            
            if (!fileInput.files || fileInput.files.length === 0) {
                event.preventDefault();
                alert('Выберите файл для загрузки!');
                return false;
            }
            
            const file = fileInput.files[0];
            const maxSize = 5 * 1024 * 1024; // 5MB
            
            if (file.size > maxSize) {
                event.preventDefault();
                alert('Файл слишком большой! Максимальный размер: 5MB');
                return false;
            }
            
            return confirm('Вы уверены, что хотите загрузить новый аватар?');
        });
    </script>
</body>
</html>
