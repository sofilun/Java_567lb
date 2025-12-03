package com.library;

import java.io.*;
import jakarta.servlet.*;

public class VisitCounter {
    private static final String COUNTER_FILE = "visit_count.txt";
    
    public static synchronized int getVisitCount(ServletContext context) { //синхронизация потоков
        try {
            String filePath = context.getRealPath("/WEB-INF/" + COUNTER_FILE);
            File file = new File(filePath);
            
            if (file.exists()) {
                //буферизация - BufferedReader reader = new BufferedReader(new FileReader(file))
                //Буферизация - это техника, когда данные читаются/пишутся не по одному байту, а блоками (буферами) определенного размера
                try (BufferedReader reader = new BufferedReader(new FileReader(file))) { //добавляет буферизацию, читает посимвольно
                    String countStr = reader.readLine(); //читаем построчно
                    return Integer.parseInt(countStr); //преобразуем строку в число
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static synchronized void incrementVisitCount(ServletContext context) {
        int count = getVisitCount(context); //читает текущее значение
        count++;
        
        try {
            String filePath = context.getRealPath("/WEB-INF/" + COUNTER_FILE);
            try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
                writer.print(count); //записываем новое значение
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
