package com.library;

import java.util.*;
import java.io.*;
import jakarta.servlet.*;

public class UserDAO {
    private static final String USERS_FILE = "users.dat";
    private Map<String, User> users = new HashMap<>();
    private ServletContext context;
    
    public UserDAO(ServletContext context) {
        this.context = context;
        loadUsers();
        
        // Добавляем тестовых пользователей только если файл пустой
        if (users.isEmpty()) {
            users.put("admin", new User("admin", "admin123", "admin@lib.ru", "Админ", "ADMIN"));
            users.put("moder", new User("moder", "moder123", "moder@lib.ru", "Модератор", "MODERATOR"));
            users.put("user", new User("user", "user123", "user@mail.ru", "Иван Иванов", "USER"));
            saveUsers();
        }
    }
    
    public User findUser(String username) {
        return users.get(username);
    }
    
    public boolean addUser(User user) {
        if (users.containsKey(user.getUsername())) {
            return false;
        }
        users.put(user.getUsername(), user);
        return true;
    }
    
    public boolean validateUser(String username, String password) {
        User user = findUser(username);
        return user != null && user.checkPassword(password);
    }
    
    public void updateAvatar(String username, String avatar) {
        User user = findUser(username);
        if (user != null) {
            user.setAvatar(avatar);
        }
    }
    
    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }
    
    public boolean updateUserRole(String username, String newRole) {
        User user = findUser(username);
        if (user != null) {
            // Создаем нового пользователя с обновленной ролью
            User updatedUser = new User(
                user.getUsername(),
                user.getPassword(),
                user.getEmail(),
                user.getFullName(),
                newRole
            );
            updatedUser.setAvatar(user.getAvatar());
            
            users.put(username, updatedUser);
            return true;
        }
        return false;
    }
    
    public boolean updateUser(String username, String email, String fullName, String password) {
        User user = findUser(username);
        if (user != null) {
            // Создаем нового пользователя с обновленными данными
            String userPassword = (password != null && !password.trim().isEmpty()) ? password : user.getPassword();
            
            User updatedUser = new User(
                user.getUsername(),
                userPassword,
                email,
                fullName,
                user.getRole()
            );
            updatedUser.setAvatar(user.getAvatar());
            
            users.put(username, updatedUser);
            return true;
        }
        return false;
    }
    
    public boolean deleteUser(String username) {
        if (users.containsKey(username)) {
            // Перед удалением пользователя удаляем его аватар если он есть
            User user = findUser(username);
            if (user != null && !"default-avatar.png".equals(user.getAvatar())) {
                deleteAvatarFile(user.getAvatar());
            }
            users.remove(username);
            return true;
        }
        return false;
    }
    
    public boolean deleteAvatar(String username) {
        User user = findUser(username);
        if (user != null) {
            // Удаляем файл аватара с сервера если он не дефолтный
            String currentAvatar = user.getAvatar();
            if (currentAvatar != null && !"default-avatar.png".equals(currentAvatar)) {
                deleteAvatarFile(currentAvatar);
            }
            
            // Устанавливаем аватар по умолчанию
            user.setAvatar("default-avatar.png");
            return true;
        }
        return false;
    }
    
    private void deleteAvatarFile(String avatarPath) {
        try {
            String fullAvatarPath = context.getRealPath("/images/" + avatarPath);
            File avatarFile = new File(fullAvatarPath);
            if (avatarFile.exists()) {
                avatarFile.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public User getUserDetails(String username) {
        return findUser(username);
    }
    
    // Сохранение пользователей в файл
    private void loadUsers() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + USERS_FILE);
            File file = new File(filePath);
            if (file.exists()) {
                try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
                    users = (Map<String, User>)ois.readObject();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void saveUsers() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + USERS_FILE);
            File file = new File(filePath);

            // Создаем папку если её нет
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) {
                oos.writeObject(users);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }   
    }
    
    // Дополнительные методы для удобства
    
    public boolean userExists(String username) {
        return users.containsKey(username);
    }
    
    public int getUserCount() {
        return users.size();
    }
    
    public List<User> getUsersByRole(String role) {
        List<User> result = new ArrayList<>();
        for (User user : users.values()) {
            if (role.equals(user.getRole())) {
                result.add(user);
            }
        }
        return result;
    }
    
    // Метод для поиска пользователей по имени (частичное совпадение)
    public List<User> searchUsersByName(String searchTerm) {
        List<User> result = new ArrayList<>();
        for (User user : users.values()) {
            if (user.getFullName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                user.getUsername().toLowerCase().contains(searchTerm.toLowerCase()) ||
                user.getEmail().toLowerCase().contains(searchTerm.toLowerCase())) {
                result.add(user);
            }
        }
        return result;
    }
}
