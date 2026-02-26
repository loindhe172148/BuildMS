package vn.edu.fpt.swp.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database connection utility class
 * Configuration loaded from src/main/resources/db.properties
 */
public class DBConnection {
    private static final String URL;
    private static final String USERNAME;
    private static final String PASSWORD;
    private static final String DRIVER;
    
    static {
        Properties props = new Properties();
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("Unable to find db.properties file");
            }
            props.load(input);
            
            URL = props.getProperty("db.url");
            USERNAME = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
            DRIVER = props.getProperty("db.driver");
            
            if (URL == null || USERNAME == null || PASSWORD == null || DRIVER == null) {
                throw new RuntimeException("Missing required properties in db.properties");
            }
            
            Class.forName(DRIVER);
        } catch (IOException e) {
            throw new RuntimeException("Error loading db.properties", e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found", e);
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    /**
     * Close database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
