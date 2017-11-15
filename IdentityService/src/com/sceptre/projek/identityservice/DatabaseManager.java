package com.sceptre.projek.identityservice;

import java.sql.*;

public class DatabaseManager {
    // Default JDBC driver name and database URL
    private static final String DEFAULT_JDBC_DRIVER = "com.mysql.jdbc.Driver";
    private static final String DEFAULT_DB_HOST = "localhost";
    private static final String DEFAULT_DB_PORT = "3306";
    private static final String DEFAULT_DB_NAME = "wbd2_identityservice";

    // Default database credentials
    private static final String DEFAULT_DB_USER = "root";
    private static final String DEFAULT_DB_PASSWORD = "";

    private static Connection connection;

    /**
     * Returns an existing DB connection, or creates one if it does not exist yet.
     *
     * @return DB connection.
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        if (connection != null) return connection;

        // Register JDBC driver
        Class.forName(DEFAULT_JDBC_DRIVER);

        String host = System.getenv("DB_HOST");
        if (host == null) host = DEFAULT_DB_HOST;

        String port = System.getenv("DB_PORT");
        if (port == null) port = DEFAULT_DB_PORT;

        String databaseName = System.getenv("DB_NAME");
        if (databaseName == null) databaseName = DEFAULT_DB_NAME;

        String user = System.getenv("DB_USER");
        if (user == null) user = DEFAULT_DB_USER;

        String password = System.getenv("DB_PASSWORD");
        if (password == null) password = DEFAULT_DB_PASSWORD;

        String url = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?useSSL=false";
        connection = DriverManager.getConnection(url, user, password);
        return connection;
    }
}
