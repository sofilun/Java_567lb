package com.library;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
//сервлет, обрабатывающий вход, регистрацию и выход пользователей
@WebServlet("/login") //относительный путь
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException { //объявление исключений в методе //Проблемы с инициализацией сервлета //Проблемы с вводом-выводом
            
            //кодировка
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            //получение параметров
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String action = request.getParameter("action");

            //используем ServletContext для сохранения данных между запросами
            UserDAO userDAO = new UserDAO(getServletContext()); //UserDAO - логичка работы с пользователями

            if ("register".equals(action)) { //активность = регистрация
                // Регистрация
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String role = request.getParameter("role");

                User newUser = new User(username, password, email, fullName, role);
                if (userDAO.addUser(newUser)) {
                    userDAO.saveUsers(); //сохраняем в файл

                    HttpSession session = request.getSession(); //создаем сессию
                    session.setAttribute("user", newUser); //сохраняем в ней пользователя
                    response.sendRedirect("profile.jsp"); //переходим к профилю
                } else {
                    request.setAttribute("error", "Такой логин уже занят");
                    request.getRequestDispatcher("register.jsp").forward(request, response); //вохврат к регистрации с сообщением об ошибке
                }

            } else {
                // Вход
                if (userDAO.validateUser(username, password)) { //провеврка данных
                    User user = userDAO.findUser(username); //поиск пользователя
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect("profile.jsp");
                } else {
                    response.sendRedirect("index.jsp?error=true"); //перенаправление на страницу с передачей параметра об ошибке
                }
            }
        }
    
    // Добавляем метод для выхода
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
            HttpSession session = request.getSession(false); //получения существующей сессии пользователя без создания новой.
            if (session != null) {
                session.invalidate(); // Уничтожаем сессию
            }
            response.sendRedirect("index.jsp");
        }
}
