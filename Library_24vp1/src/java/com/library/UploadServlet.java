package com.library;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/upload")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5, // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UploadServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("index.jsp");
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
                String newFileName = user.getUsername() + "_avatar" + fileExtension;
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
                
                // Обновляем аватар в базе данных
                UserDAO userDAO = new UserDAO(getServletContext()); // Контекст передаем при создании
                userDAO.updateAvatar(user.getUsername(), "avatars/" + newFileName);
                userDAO.saveUsers(); // БЕЗ параметра!
                
                // Обновляем пользователя в сессии
                user.setAvatar("avatars/" + newFileName);
                session.setAttribute("user", user);
                
                response.sendRedirect("profile.jsp?success=avatar_updated");
            } else {
                response.sendRedirect("upload-avatar.jsp?error=no_file");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("upload-avatar.jsp?error=upload_failed");
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
