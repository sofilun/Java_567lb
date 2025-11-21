package com.library;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

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
                UserDAO userDAO = new UserDAO(getServletContext());
                userDAO.updateAvatar(user.getUsername(), "avatars/" + newFileName);
                userDAO.saveUsers(getServletContext());
                
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
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}
