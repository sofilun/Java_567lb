package com.library;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/book-manager")
public class BookManagerServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Проверяем права администратора
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        BookDAO bookDAO = new BookDAO(getServletContext());
        request.setAttribute("allBooks", bookDAO.getAllBooks());
        request.setAttribute("allGenres", bookDAO.getAllGenres());
        request.setAttribute("bookCount", bookDAO.getBookCount());
        request.setAttribute("availableCount", bookDAO.getAvailableBookCount());
        
        request.getRequestDispatcher("book-manager.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        BookDAO bookDAO = new BookDAO(getServletContext());
        
        try {
            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String genre = request.getParameter("genre");
                String year = request.getParameter("year");
                String description = request.getParameter("description");
                boolean available = "on".equals(request.getParameter("available"));
                
                if (title == null || title.trim().isEmpty() ||
                    author == null || author.trim().isEmpty() ||
                    genre == null || genre.trim().isEmpty() ||
                    year == null || year.trim().isEmpty()) {
                    
                    response.sendRedirect("book-manager?error=missing_fields");
                    return;
                }
                
                String newId = bookDAO.generateNewId();
                Book newBook = new Book(newId, title, author, genre, year, description, available);
                
                if (bookDAO.addBook(newBook)) {
                    response.sendRedirect("book-manager?success=book_added");
                } else {
                    response.sendRedirect("book-manager?error=add_failed");
                }
                
            } else if ("update".equals(action)) {
                String id = request.getParameter("id");
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String genre = request.getParameter("genre");
                String year = request.getParameter("year");
                String description = request.getParameter("description");
                boolean available = "on".equals(request.getParameter("available"));
                
                if (id == null || id.trim().isEmpty() ||
                    title == null || title.trim().isEmpty() ||
                    author == null || author.trim().isEmpty() ||
                    genre == null || genre.trim().isEmpty() ||
                    year == null || year.trim().isEmpty()) {
                    
                    response.sendRedirect("book-manager?error=missing_fields");
                    return;
                }
                
                if (bookDAO.updateBook(id, title, author, genre, year, description, available)) {
                    response.sendRedirect("book-manager?success=book_updated");
                } else {
                    response.sendRedirect("book-manager?error=update_failed");
                }
                
            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                
                if (id != null && bookDAO.deleteBook(id)) {
                    response.sendRedirect("book-manager?success=book_deleted");
                } else {
                    response.sendRedirect("book-manager?error=delete_failed");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("book-manager?error=server_error");
        }
    }
}
