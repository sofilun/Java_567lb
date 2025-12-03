package com.library;

import java.io.Serializable;

public class Book implements Serializable {
    private String id;
    private String title;
    private String author;
    private String genre;
    private String year;
    private String description;
    private boolean available;
    private String addedDate;
    
    public Book(String id, String title, String author, String genre, String year, 
                String description, boolean available) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.genre = genre;
        this.year = year;
        this.description = description;
        this.available = available;
        this.addedDate = new java.text.SimpleDateFormat("dd.MM.yyyy").format(new java.util.Date());
    }
    
    // Геттеры
    public String getId() { return id; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getGenre() { return genre; }
    public String getYear() { return year; }
    public String getDescription() { return description; }
    public boolean isAvailable() { return available; }
    public String getAddedDate() { return addedDate; }
    
    // Сеттеры
    public void setTitle(String title) { this.title = title; }
    public void setAuthor(String author) { this.author = author; }
    public void setGenre(String genre) { this.genre = genre; }
    public void setYear(String year) { this.year = year; }
    public void setDescription(String description) { this.description = description; }
    public void setAvailable(boolean available) { this.available = available; }
    
    @Override
    public String toString() {
        return title + " (" + author + ", " + year + ")";
    }
}
