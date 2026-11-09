package com.rsodgj.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

/** Hash password dengan SHA-256 (hex, 64 karakter). */
public final class Sandi {
    private Sandi() {}

    public static String hash(String teks) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] b = md.digest(teks.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte x : b) sb.append(String.format("%02x", x));
            return sb.toString();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
