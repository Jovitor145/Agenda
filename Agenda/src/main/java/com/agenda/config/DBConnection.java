package com.agenda.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    // Credenciais para o banco 'agenda'
    private static final String URL = "jdbc:mysql://localhost:7175/agenda?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; 
    private static final String PASSWORD = "S0i4stec"; 
    
    public static Connection getConnection() throws SQLException {
        try {
            // Carrega o driver MySQL explicitamente
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL não encontrado", e);
        }
    }
}