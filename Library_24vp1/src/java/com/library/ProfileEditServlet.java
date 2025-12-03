package com.library;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/profile-edit")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5, // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ProfileEditServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        // Передаем данные пользователя на страницу редактирования
        request.setAttribute("user", user);
        request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO(getServletContext());
        
        try {
            if ("updateInfo".equals(action)) {
                // Обновление основной информации
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String password = request.getParameter("password");
                
                if (email == null || email.trim().isEmpty() || 
                    fullName == null || fullName.trim().isEmpty()) {
                    
                    response.sendRedirect("edit-profile.jsp?error=missing_fields");
                    return;
                }
                
                // Обновляем данные пользователя
                if (userDAO.updateUser(currentUser.getUsername(), email, fullName, password)) {
                    userDAO.saveUsers();
                    
                    // Обновляем пользователя в сессии
                    User updatedUser = userDAO.findUser(currentUser.getUsername());
                    session.setAttribute("user", updatedUser);
                    
                    response.sendRedirect("profile.jsp?success=info_updated");
                } else {
                    response.sendRedirect("edit-profile.jsp?error=update_failed");
                }
                
            } else if ("deleteAvatar".equals(action)) {
                // Удаление аватара
                if (userDAO.deleteAvatar(currentUser.getUsername())) {
                    userDAO.saveUsers();
                    
                    // Обновляем пользователя в сессии
                    currentUser.setAvatar("default-avatar.png");
                    session.setAttribute("user", currentUser);
                    
                    response.sendRedirect("profile.jsp?success=avatar_deleted");
                } else {
                    response.sendRedirect("edit-profile.jsp?error=delete_failed");
                }
                
            } else if ("uploadAvatar".equals(action)) {
                // Загрузка нового аватара
                handleAvatarUpload(request, response, currentUser, userDAO, session);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit-profile.jsp?error=server_error");
        }
    }
    
    private void handleAvatarUpload(HttpServletRequest request, HttpServletResponse response,
                                    User user, UserDAO userDAO, HttpSession session) 
        throws ServletException, IOException {
        
        try {
            Part filePart = request.getPart("avatar");
            String fileName = getFileName(filePart);
            
            if (fileName != null && !fileName.isEmpty()) {
                // Создаем папку для изображений если её нет
                String uploadPath = getServletContext().getRealPath("/images/avatars");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Генерируем уникальное имя файла
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String newFileName = user.getUsername() + "_avatar" + System.currentTimeMillis() + fileExtension;
                String filePath = uploadPath + File.separator + newFileName;
                
                // Удаляем старый аватар если он не дефолтный
                String oldAvatar = user.getAvatar();
                if (oldAvatar != null && !"default-avatar.png".equals(oldAvatar)) {
                    String oldAvatarPath = getServletContext().getRealPath("/images/" + oldAvatar);
                    File oldAvatarFile = new File(oldAvatarPath);
                    if (oldAvatarFile.exists()) {
                        oldAvatarFile.delete();
                    }
                }
                
                // Сохраняем новый файл
                try (InputStream fileContent = filePart.getInputStream();
                     OutputStream out = new FileOutputStream(filePath)) {
                    
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
                
                // Обновляем аватар в базе данных
                userDAO.updateAvatar(user.getUsername(), "avatars/" + newFileName);
                userDAO.saveUsers();
                
                // Обновляем пользователя в сессии
                user.setAvatar("avatars/" + newFileName);
                session.setAttribute("user", user);
                
                response.sendRedirect("profile.jsp?success=avatar_updated");
            } else {
                response.sendRedirect("edit-profile.jsp?error=no_file");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit-profile.jsp?error=upload_failed");
        }
    }
    
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}
