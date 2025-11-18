package com.library;

import java.io.Serializable;

public class User implements Serializable { //Serializable - позволяет сохранять объекты в файлы, передавать по сети, хранить в сессиях
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String role;
    private String avatar;
    
    public User(String username, String password, String email, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.avatar = "default-avatar.png";
    }
    
    // Геттеры - после создания не изменяются и сеттеры - могут меняться
    public String getUsername() { return username; } //возвращает значение поля
    public String getPassword() { return password; }
    public String getEmail() { return email; }
    public String getFullName() { return fullName; }
    public String getRole() { return role; }
    public String getAvatar() { return avatar; }
    
    public void setAvatar(String avatar) { this.avatar = avatar; } //устанавливают новое значение
    
    //проверка пароля
    public boolean checkPassword(String inputPassword) {
        return this.password.equals(inputPassword);
    }
}