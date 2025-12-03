package com.library;

import java.util.*;
import java.io.*;
import jakarta.servlet.*;

public class BookDAO {
    private static final String BOOKS_FILE = "books.dat";
    private Map<String, Book> books = new HashMap<>();
    private ServletContext context;
    
    public BookDAO(ServletContext context) {
        this.context = context;
        loadBooks();
        
        // Добавляем тестовые книги если файл пустой
        if (books.isEmpty()) {
            addTestBooks();
            saveBooks();
        }
    }
    
    private void addTestBooks() {
        books.put("1", new Book("1", "Мастер и Маргарита", "Михаил Булгаков", 
            "Роман", "1967", "Одно из величайших произведений русской литературы XX века", true));
        
        books.put("2", new Book("2", "Преступление и наказание", "Фёдор Достоевский", 
            "Роман", "1866", "Психологический роман о преступлении и его последствиях", true));
        
        books.put("3", new Book("3", "Война и мир", "Лев Толстой", 
            "Роман-эпопея", "1869", "Эпопея, описывающая русское общество в эпоху войн против Наполеона", false));
        
        books.put("4", new Book("4", "1984", "Джордж Оруэлл", 
            "Антиутопия", "1949", "Роман-антиутопия о тоталитарном обществе", true));
        
        books.put("5", new Book("5", "Гарри Поттер и философский камень", "Джоан Роулинг", 
            "Фэнтези", "1997", "Первая книга серии о юном волшебнике Гарри Поттере", true));
    }
    
    public List<Book> getAllBooks() {
        return new ArrayList<>(books.values());
    }
    
    public Book getBook(String id) {
        return books.get(id);
    }
    
    public boolean addBook(Book book) {
        if (books.containsKey(book.getId())) {
            return false;
        }
        books.put(book.getId(), book);
        saveBooks();
        return true;
    }
    
    public boolean updateBook(String id, String title, String author, String genre, 
                              String year, String description, boolean available) {
        Book book = books.get(id);
        if (book != null) {
            book.setTitle(title);
            book.setAuthor(author);
            book.setGenre(genre);
            book.setYear(year);
            book.setDescription(description);
            book.setAvailable(available);
            saveBooks();
            return true;
        }
        return false;
    }
    
    public boolean deleteBook(String id) {
        if (books.containsKey(id)) {
            books.remove(id);
            saveBooks();
            return true;
        }
        return false;
    }
    
    public String generateNewId() {
        int maxId = 0;
        for (String id : books.keySet()) {
            try {
                int numId = Integer.parseInt(id);
                if (numId > maxId) {
                    maxId = numId;
                }
            } catch (NumberFormatException e) {
                // Пропускаем нечисловые ID
            }
        }
        return String.valueOf(maxId + 1);
    }
    
    public int getBookCount() {
        return books.size();
    }
    
    public int getAvailableBookCount() {
        int count = 0;
        for (Book book : books.values()) {
            if (book.isAvailable()) {
                count++;
            }
        }
        return count;
    }
    
    public List<String> getAllGenres() {
        Set<String> genres = new HashSet<>();
        for (Book book : books.values()) {
            genres.add(book.getGenre());
        }
        return new ArrayList<>(genres);
    }
    
    private void loadBooks() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + BOOKS_FILE);
            File file = new File(filePath);
            if (file.exists()) {
                try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
                    books = (Map<String, Book>)ois.readObject();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void saveBooks() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + BOOKS_FILE);
            File file = new File(filePath);

            // Создаем папку если её нет
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) {
                oos.writeObject(books);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }   
    }
}
