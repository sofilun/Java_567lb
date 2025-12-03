package com.library;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/admin")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5, // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AdminServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Проверяем права администратора
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        UserDAO userDAO = new UserDAO(getServletContext());
        request.setAttribute("allUsers", userDAO.getAllUsers());
        request.getRequestDispatcher("admin-panel.jsp").forward(request, response);
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
        
        // Проверяем, есть ли загружаемый файл (для аватара)
        if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
            String action = request.getParameter("formAction");
            if ("uploadAvatar".equals(action)) {
                handleAvatarUpload(request, response);
                return;
            } else if ("createUser".equals(action)) {
                handleCreateUser(request, response);
                return;
            }
        }
        
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO(getServletContext());
        
        try {
            if ("createUserSimple".equals(action)) {
                // Создание пользователя без аватара (простая форма)
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String role = request.getParameter("role");
                
                if (username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    fullName == null || fullName.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {
                    
                    response.sendRedirect("admin?error=missing_fields");
                    return;
                }
                
                // Проверяем, не существует ли уже пользователь с таким логином
                if (userDAO.userExists(username)) {
                    response.sendRedirect("admin?error=username_exists");
                    return;
                }
                
                // Создаем нового пользователя
                User newUser = new User(username, password, email, fullName, role);
                if (userDAO.addUser(newUser)) {
                    userDAO.saveUsers();
                    response.sendRedirect("admin?success=user_created");
                } else {
                    response.sendRedirect("admin?error=create_failed");
                }
                
            } else if ("updateRole".equals(action)) {
                String username = request.getParameter("username");
                String newRole = request.getParameter("role");
                
                if (userDAO.updateUserRole(username, newRole)) {
                    userDAO.saveUsers();
                    response.sendRedirect("admin?success=role_updated");
                } else {
                    response.sendRedirect("admin?error=update_failed");
                }
                
            } else if ("updateUser".equals(action)) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String password = request.getParameter("password");
                
                if (userDAO.updateUser(username, email, fullName, password)) {
                    userDAO.saveUsers();
                    response.sendRedirect("admin?success=user_updated");
                } else {
                    response.sendRedirect("admin?error=update_failed");
                }
                
            } else if ("deleteUser".equals(action)) {
                String username = request.getParameter("username");
                
                // Не позволяем удалить самого себя
                if (!username.equals(user.getUsername())) {
                    if (userDAO.deleteUser(username)) {
                        userDAO.saveUsers();
                        response.sendRedirect("admin?success=user_deleted");
                    } else {
                        response.sendRedirect("admin?error=delete_failed");
                    }
                } else {
                    response.sendRedirect("admin?error=cannot_delete_self");
                }
                
            } else if ("deleteAvatar".equals(action)) {
                String username = request.getParameter("username");
                
                if (userDAO.deleteAvatar(username)) {
                    userDAO.saveUsers();
                    response.sendRedirect("admin?success=avatar_deleted");
                } else {
                    response.sendRedirect("admin?error=delete_failed");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?error=server_error");
        }
    }
    
    private void handleAvatarUpload(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("admin?error=no_username");
            return;
        }
        
        UserDAO userDAO = new UserDAO(getServletContext());
        User targetUser = userDAO.findUser(username);
        
        if (targetUser == null) {
            response.sendRedirect("admin?error=user_not_found");
            return;
        }
        
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
                String newFileName = username + "_admin_avatar" + System.currentTimeMillis() + fileExtension;
                String filePath = uploadPath + File.separator + newFileName;
                
                // Удаляем старый аватар если он не дефолтный
                String oldAvatar = targetUser.getAvatar();
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
                userDAO.updateAvatar(username, "avatars/" + newFileName);
                userDAO.saveUsers();
                
                response.sendRedirect("admin?success=avatar_changed");
            } else {
                response.sendRedirect("admin?error=no_file");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?error=upload_failed");
        }
    }
    
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        try {
            // Получаем данные из формы
            String username = request.getParameter("newUsername");
            String password = request.getParameter("newPassword");
            String email = request.getParameter("newEmail");
            String fullName = request.getParameter("newFullName");
            String role = request.getParameter("newRole");
            
            // Валидация обязательных полей
            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                role == null || role.trim().isEmpty()) {
                
                response.sendRedirect("admin?error=missing_fields");
                return;
            }
            
            UserDAO userDAO = new UserDAO(getServletContext());
            
            // Проверяем, не существует ли уже пользователь с таким логином
            if (userDAO.userExists(username)) {
                response.sendRedirect("admin?error=username_exists");
                return;
            }
            
            // Создаем нового пользователя
            User newUser = new User(username, password, email, fullName, role);
            
            // Обрабатываем аватар если он был загружен
            Part filePart = request.getPart("newAvatar");
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
                String newFileName = username + "_avatar" + System.currentTimeMillis() + fileExtension;
                String filePath = uploadPath + File.separator + newFileName;
                
                // Сохраняем файл
                try (InputStream fileContent = filePart.getInputStream();
                     OutputStream out = new FileOutputStream(filePath)) {
                    
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
                
                // Устанавливаем аватар
                newUser.setAvatar("avatars/" + newFileName);
            }
            
            // Добавляем пользователя в базу
            if (userDAO.addUser(newUser)) {
                userDAO.saveUsers();
                response.sendRedirect("admin?success=user_created");
            } else {
                response.sendRedirect("admin?error=create_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?error=server_error");
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
