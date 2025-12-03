<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User, java.util.*" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    User user = (User) userObj;
    
    // Пример данных книг (в реальном приложении будут из базы данных)
    List<Map<String, String>> books = new ArrayList<>();
    
    // Добавляем книги в каталог
    Map<String, String> book1 = new HashMap<>();
    book1.put("id", "1");
    book1.put("title", "Мастер и Маргарита");
    book1.put("author", "Михаил Булгаков");
    book1.put("genre", "Роман");
    book1.put("year", "1967");
    book1.put("description", "Одно из величайших произведений русской литературы XX века");
    book1.put("available", "да");
    books.add(book1);
    
    Map<String, String> book2 = new HashMap<>();
    book2.put("id", "2");
    book2.put("title", "Преступление и наказание");
    book2.put("author", "Фёдор Достоевский");
    book2.put("genre", "Роман");
    book2.put("year", "1866");
    book2.put("description", "Психологический роман о преступлении и его последствиях");
    book2.put("available", "да");
    books.add(book2);
    
    Map<String, String> book3 = new HashMap<>();
    book3.put("id", "3");
    book3.put("title", "Война и мир");
    book3.put("author", "Лев Толстой");
    book3.put("genre", "Роман-эпопея");
    book3.put("year", "1869");
    book3.put("description", "Эпопея, описывающая русское общество в эпоху войн против Наполеона");
    book3.put("available", "нет");
    books.add(book3);
    
    Map<String, String> book4 = new HashMap<>();
    book4.put("id", "4");
    book4.put("title", "1984");
    book4.put("author", "Джордж Оруэлл");
    book4.put("genre", "Антиутопия");
    book4.put("year", "1949");
    book4.put("description", "Роман-антиутопия о тоталитарном обществе");
    book4.put("available", "да");
    books.add(book4);
    
    Map<String, String> book5 = new HashMap<>();
    book5.put("id", "5");
    book5.put("title", "Гарри Поттер и философский камень");
    book5.put("author", "Джоан Роулинг");
    book5.put("genre", "Фэнтези");
    book5.put("year", "1997");
    book5.put("description", "Первая книга серии о юном волшебнике Гарри Поттере");
    book5.put("available", "да");
    books.add(book5);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Каталог книг</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f7fa;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: #667eea; 
            color: white; 
        }
        .btn-primary:hover { 
            background: #5a67d8; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
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
            background: #28a745; 
            color: white; 
        }
        .btn-success:hover { 
            background: #218838; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .btn-warning { 
            background: #ffc107; 
            color: #212529; 
        }
        .btn-warning:hover { 
            background: #e0a800; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.3);
        }
        .btn-danger { 
            background: #dc3545; 
            color: white; 
        }
        .btn-danger:hover { 
            background: #c82333; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }
        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        .book-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .book-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        .book-cover {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
        }
        .book-content {
            padding: 20px;
        }
        .book-title {
            margin: 0 0 10px;
            color: #333;
            font-size: 18px;
            font-weight: 600;
            line-height: 1.3;
        }
        .book-author {
            margin: 0 0 15px;
            color: #666;
            font-size: 14px;
            font-style: italic;
        }
        .book-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }
        .book-genre {
            background: #e3f2fd;
            color: #1976d2;
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .book-year {
            background: #f3e5f5;
            color: #7b1fa2;
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .book-description {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .book-availability {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .availability-status {
            font-weight: 600;
            font-size: 14px;
        }
        .available {
            color: #28a745;
        }
        .not-available {
            color: #dc3545;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 14px;
            margin-top: 40px;
        }
        .book-id {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 12px;
        }
        .book-card {
            position: relative;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 Каталог книг</h1>
        <p>Исследуйте нашу коллекцию литературных произведений</p>
    </div>
    
    <!-- Навигация -->
    <div class="nav">
        <a href="profile.jsp"><button class="btn-secondary">👤 Личный кабинет</button></a>
        
        <% 
        if ("USER".equals(user.getRole())) {
        %>
            <a href="#"><button class="btn-warning">📖 Мои книги</button></a>
        <%
        } else if ("MODERATOR".equals(user.getRole())) {
        %>
            <a href="#"><button class="btn-warning">👨‍💼 Панель модератора</button></a>
        <%
        } else if ("ADMIN".equals(user.getRole())) {
        %>
            <a href="admin"><button class="btn-warning">👑 Панель администратора</button></a>
        <%
        }
        %>
        
        <a href="index.jsp"><button class="btn-secondary">🏠 Главная страница</button></a>
        <a href="login?logout=true"><button class="btn-danger">🚪 Выйти</button></a>
    </div>
    
    <!-- Каталог книг -->
    <div class="catalog-grid">
        <% for (Map<String, String> book : books) { %>
            <div class="book-card">
                <div class="book-id">#<%= book.get("id") %></div>
                <div class="book-cover">
                    📖
                </div>
                <div class="book-content">
                    <h3 class="book-title"><%= book.get("title") %></h3>
                    <p class="book-author"><%= book.get("author") %></p>
                    
                    <div class="book-meta">
                        <span class="book-genre"><%= book.get("genre") %></span>
                        <span class="book-year">Год: <%= book.get("year") %></span>
                    </div>
                    
                    <p class="book-description"><%= book.get("description") %></p>
                    
                    <div class="book-availability">
                        <div class="availability-status <%= "да".equals(book.get("available")) ? "available" : "not-available" %>">
                            <%= "да".equals(book.get("available")) ? "✅ Доступна" : "❌ Недоступна" %>
                        </div>
                        <div class="action-buttons">
                            <button class="btn-primary" style="padding: 6px 12px; font-size: 12px;">
                                <%= "да".equals(book.get("available")) ? "📖 Забронировать" : "⏳ В очередь" %>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    
    <!-- Футер -->
    <div class="footer">
        <p>📚 Библиотечная система • Каталог книг</p>
    </div>
</body>
</html>
