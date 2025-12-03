<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.Book, com.library.User, java.util.*" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null || !"ADMIN".equals(((User)userObj).getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    List<Book> allBooks = (List<Book>) request.getAttribute("allBooks");
    List<String> allGenres = (List<String>) request.getAttribute("allGenres");
    Integer bookCount = (Integer) request.getAttribute("bookCount");
    Integer availableCount = (Integer) request.getAttribute("availableCount");
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Управление книгами</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1300px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f7fa;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        .header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .nav {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
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
        .btn-primary { 
            background: #2196F3; 
            color: white; 
        }
        .btn-primary:hover { 
            background: #1976D2; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
        }
        .btn-secondary { 
            background: #6c757d; 
            color: white; 
        }
        .btn-secondary:hover { 
            background: #5a6268; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }
        .btn-success { 
            background: #4CAF50; 
            color: white; 
        }
        .btn-success:hover { 
            background: #45a049; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }
        .btn-warning { 
            background: #ff9800; 
            color: white; 
        }
        .btn-warning:hover { 
            background: #f57c00; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(255, 152, 0, 0.3);
        }
        .btn-danger { 
            background: #f44336; 
            color: white; 
        }
        .btn-danger:hover { 
            background: #d32f2f; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(244, 67, 54, 0.3);
        }
        .stats {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .stats-info {
            font-size: 16px;
            color: #333;
        }
        .stats-info strong {
            color: #2196F3;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            text-align: center;
            border-left: 4px solid #28a745;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            text-align: center;
            border-left: 4px solid #dc3545;
        }
        .books-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .form-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0,0,0,0.3);
            z-index: 1000;
            width: 600px;
            max-height: 90vh;
            overflow-y: auto;
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2196F3;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }
        .availability-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .available-badge {
            background: #d4edda;
            color: #155724;
        }
        .not-available-badge {
            background: #f8d7da;
            color: #721c24;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
        .genre-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            margin: 2px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 14px;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 Управление книгами</h1>
        <p>Администрирование каталога библиотеки</p>
    </div>
    
    <!-- Навигация -->
    <div class="nav">
        <a href="admin"><button class="btn-secondary">← Назад в админ-панель</button></a>
        <a href="profile.jsp"><button class="btn-secondary">👤 Личный кабинет</button></a>
        <a href="catalog.jsp"><button class="btn-secondary">📖 В каталог</button></a>
        <button class="btn-success" onclick="openAddForm()">➕ Добавить новую книгу</button>
    </div>
    
    <!-- Статистика -->
    <div class="stats">
        <div class="stats-info">
            📊 <strong><%= bookCount %></strong> книг в каталоге • 
            ✅ <strong><%= availableCount %></strong> доступно • 
            ⚠️ <strong><%= bookCount - availableCount %></strong> недоступно
        </div>
        <div class="stats-info">
            📂 Жанры: 
            <% for (String genre : allGenres) { %>
                <span class="genre-badge"><%= genre %></span>
            <% } %>
        </div>
    </div>
    
    <!-- Сообщения об успехе/ошибке -->
    <% if (success != null) { %>
        <div class="success">
            <% 
                if ("book_added".equals(success)) out.print("✅ Книга успешно добавлена!");
                else if ("book_updated".equals(success)) out.print("✅ Книга успешно обновлена!");
                else if ("book_deleted".equals(success)) out.print("✅ Книга успешно удалена!");
            %>
        </div>
    <% } %>
    
    <% if (error != null) { %>
        <div class="error">
            <% 
                if ("missing_fields".equals(error)) out.print("❌ Заполните все обязательные поля!");
                else if ("add_failed".equals(error)) out.print("❌ Ошибка при добавлении книги!");
                else if ("update_failed".equals(error)) out.print("❌ Ошибка при обновлении книги!");
                else if ("delete_failed".equals(error)) out.print("❌ Ошибка при удалении книги!");
                else if ("server_error".equals(error)) out.print("❌ Ошибка сервера!");
            %>
        </div>
    <% } %>
    
    <!-- Таблица книг -->
    <div class="books-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Название</th>
                    <th>Автор</th>
                    <th>Жанр</th>
                    <th>Год</th>
                    <th>Доступность</th>
                    <th>Дата добавления</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <% for (Book book : allBooks) { %>
                <tr>
                    <td><strong>#<%= book.getId() %></strong></td>
                    <td>
                        <strong style="font-size: 16px;"><%= book.getTitle() %></strong><br>
                        <small style="color: #666;"><%= book.getDescription().length() > 50 ? 
                            book.getDescription().substring(0, 50) + "..." : book.getDescription() %></small>
                    </td>
                    <td><%= book.getAuthor() %></td>
                    <td><%= book.getGenre() %></td>
                    <td><%= book.getYear() %></td>
                    <td>
                        <span class="availability-badge <%= book.isAvailable() ? "available-badge" : "not-available-badge" %>">
                            <%= book.isAvailable() ? "✅ Доступна" : "❌ Недоступна" %>
                        </span>
                    </td>
                    <td><%= book.getAddedDate() %></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-warning" onclick="openEditForm(
                                '<%= book.getId() %>',
                                '<%= book.getTitle().replace("'", "\\'") %>',
                                '<%= book.getAuthor().replace("'", "\\'") %>',
                                '<%= book.getGenre() %>',
                                '<%= book.getYear() %>',
                                '<%= book.getDescription().replace("'", "\\'").replace("\n", "\\n") %>',
                                <%= book.isAvailable() %>
                            )">✏️</button>
                            
                            <button class="btn-danger" onclick="deleteBook('<%= book.getId() %>', '<%= book.getTitle().replace("'", "\\'") %>')">
                                🗑️
                            </button>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <!-- Футер -->
    <div class="footer">
        <p>📚 Управление книгами • Административная панель • <%= new java.util.Date() %></p>
    </div>

    <!-- Модальные окна -->
    <div id="overlay" class="overlay" onclick="closeAllForms()"></div>
    
    <!-- Форма добавления книги -->
    <div id="addForm" class="form-popup">
        <h3 style="margin-top: 0; margin-bottom: 25px;">➕ Добавление новой книги</h3>
        
        <form action="book-manager" method="post">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label for="addTitle">Название книги *</label>
                <input type="text" id="addTitle" name="title" required 
                       placeholder="Введите название книги">
            </div>
            
            <div class="form-group">
                <label for="addAuthor">Автор *</label>
                <input type="text" id="addAuthor" name="author" required 
                       placeholder="Введите автора">
            </div>
            
            <div class="form-group">
                <label for="addGenre">Жанр *</label>
                <select id="addGenre" name="genre" required>
                    <option value="">-- Выберите жанр --</option>
                    <option value="Роман">Роман</option>
                    <option value="Роман-эпопея">Роман-эпопея</option>
                    <option value="Антиутопия">Антиутопия</option>
                    <option value="Фэнтези">Фэнтези</option>
                    <option value="Детектив">Детектив</option>
                    <option value="Научная литература">Научная литература</option>
                    <option value="Поэзия">Поэзия</option>
                    <option value="Драма">Драма</option>
                    <option value="Приключения">Приключения</option>
                    <option value="Научная фантастика">Научная фантастика</option>
                    <option value="Биография">Биография</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="addYear">Год издания *</label>
                <input type="number" id="addYear" name="year" required 
                       max="<%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %>"
                       placeholder="Например: 2023">
            </div>
            
            <div class="form-group">
                <label for="addDescription">Описание</label>
                <textarea id="addDescription" name="description" 
                          placeholder="Введите описание книги..."></textarea>
            </div>
            
            <div class="form-group checkbox-group">
                <input type="checkbox" id="addAvailable" name="available" checked>
                <label for="addAvailable" style="font-weight: normal;">Книга доступна для выдачи</label>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn-success">Добавить книгу</button>
                <button type="button" class="btn-secondary" onclick="closeAllForms()">Отмена</button>
            </div>
        </form>
    </div>
    
    <!-- Форма редактирования книги -->
    <div id="editForm" class="form-popup">
        <h3 style="margin-top: 0; margin-bottom: 25px;">✏️ Редактирование книги</h3>
        
        <form action="book-manager" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">
            
            <div class="form-group">
                <label for="editTitle">Название книги *</label>
                <input type="text" id="editTitle" name="title" required>
            </div>
            
            <div class="form-group">
                <label for="editAuthor">Автор *</label>
                <input type="text" id="editAuthor" name="author" required>
            </div>
            
            <div class="form-group">
                <label for="editGenre">Жанр *</label>
                <select id="editGenre" name="genre" required>
                    <option value="Роман">Роман</option>
                    <option value="Роман-эпопея">Роман-эпопея</option>
                    <option value="Антиутопия">Антиутопия</option>
                    <option value="Фэнтези">Фэнтези</option>
                    <option value="Детектив">Детектив</option>
                    <option value="Научная литература">Научная литература</option>
                    <option value="Поэзия">Поэзия</option>
                    <option value="Драма">Драма</option>
                    <option value="Приключения">Приключения</option>
                    <option value="Научная фантастика">Научная фантастика</option>
                    <option value="Биография">Биография</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="editYear">Год издания *</label>
                <input type="number" id="editYear" name="year" required 
                       max="<%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %>">
            </div>
            
            <div class="form-group">
                <label for="editDescription">Описание</label>
                <textarea id="editDescription" name="description"></textarea>
            </div>
            
            <div class="form-group checkbox-group">
                <input type="checkbox" id="editAvailable" name="available">
                <label for="editAvailable" style="font-weight: normal;">Книга доступна для выдачи</label>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn-success">Сохранить изменения</button>
                <button type="button" class="btn-secondary" onclick="closeAllForms()">Отмена</button>
            </div>
        </form>
    </div>

    <script>
        // Открытие формы добавления
        function openAddForm() {
            // Сбрасываем форму
            document.getElementById('addForm').querySelector('form').reset();
            document.getElementById('addAvailable').checked = true;
            
            closeAllForms();
            document.getElementById('addForm').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }
        
        // Открытие формы редактирования
        function openEditForm(id, title, author, genre, year, description, available) {
            document.getElementById('editId').value = id;
            document.getElementById('editTitle').value = title;
            document.getElementById('editAuthor').value = author;
            document.getElementById('editGenre').value = genre;
            document.getElementById('editYear').value = year;
            document.getElementById('editDescription').value = description;
            document.getElementById('editAvailable').checked = available;
            
            closeAllForms();
            document.getElementById('editForm').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }
        
        // Удаление книги с подтверждением
        function deleteBook(id, title) {
            if (confirm('ВНИМАНИЕ!\n\nВы уверены, что хотите удалить книгу:\n"' + title + '"?\n\nЭто действие невозможно отменить!')) {
                // Создаем скрытую форму для отправки запроса на удаление
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'book-manager';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Закрытие всех форм
        function closeAllForms() {
            document.getElementById('addForm').style.display = 'none';
            document.getElementById('editForm').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }
        
        // Закрытие форм при нажатии ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeAllForms();
            }
        });
        
        // Автоматическое скрытие сообщений через 5 секунд
        setTimeout(() => {
            const messages = document.querySelectorAll('.success, .error');
            messages.forEach(msg => {
                if (msg) {
                    msg.style.opacity = '0';
                    msg.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => msg.remove(), 500);
                }
            });
        }, 5000);
    </script>
</body>
</html>
