package com.library;

import java.util.*;
import java.io.*;
import javax.servlet.*;

public class UserDAO {
    private static final String USERS_FILE = "users.dat";
    //<ключ, значение> = <имя пользователя, объект пользователя>
    private Map<String, User> users = new HashMap<>(); //коллекция для хранения пользователей
    
    public UserDAO(ServletContext context) {
        
        loadUsers(context); //вызов метода загрузки из файла
        
        // Добавляем тестовых пользователей только если файл пустой
        if (users.isEmpty()) {
            users.put("admin", new User("admin", "admin123", "admin@lib.ru", "Админ", "ADMIN"));
            users.put("moder", new User("moder", "moder123", "moder@lib.ru", "Модератор", "MODERATOR"));
            users.put("user", new User("user", "user123", "user@mail.ru", "Иван Иванов", "USER"));
            saveUsers(context); //сохраняем в файл
        }
    }
    
    public User findUser(String username) {
        return users.get(username); //возвращаем User из Map либо null
    }
    
    public boolean addUser(User user) {
        if (users.containsKey(user.getUsername())) { //существует ли ключ от имени пользоваля
            return false;
        }
        users.put(user.getUsername(), user); //добавляем новую пару ключ-значение
        return true;
    }
    
    public boolean validateUser(String username, String password) {
        User user = findUser(username);
        return user != null && user.checkPassword(password); //сравнение пароля пользователя с введенным паролем
    }
    
    public void updateAvatar(String username, String avatar) {
        User user = findUser(username);
        if (user != null) {
            user.setAvatar(avatar); //установка аватара
        }
    }
    
    // Сохранение пользователей в файл
    private void loadUsers(ServletContext context) {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + USERS_FILE); //преобразует виртуальный путь в реальный
            File file = new File(filePath); //создание объекта класса File, который представляет файл
            if (file.exists()) {
                try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) { //создает поток для чтения, начинает чтение объектов
                    users = (Map<String, User>)ois.readObject(); //читается объект и приводится к типу (Map<String, User>)
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void saveUsers(ServletContext context) {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + USERS_FILE);
            File file = new File(filePath);

            try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) {
                oos.writeObject(users); //поток для записи объекта.функция записи 
            }
        } catch (IOException e) {
            e.printStackTrace();
        }   
    }
}