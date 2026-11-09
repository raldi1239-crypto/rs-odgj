package com.rsodgj.config;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Koneksi database. Nilai bisa diganti lewat environment variable
 * DB_URL, DB_USER, DB_PASS tanpa perlu mengubah kode.
 */
public class KoneksiDB {
    private static final String URL = env("DB_URL",
            "jdbc:mysql://localhost:3306/db_rs_odgj?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Jakarta&characterEncoding=UTF-8");
    private static final String USER = env("DB_USER", "root");
    private static final String PASS = env("DB_PASS", "");

    private static String env(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isEmpty()) ? def : v;
    }

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
