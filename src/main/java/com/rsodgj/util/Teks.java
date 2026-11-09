package com.rsodgj.util;

import java.sql.Date;

/** Fungsi bantu untuk membaca parameter form dengan aman. */
public final class Teks {
    private Teks() {}

    public static String bersih(String s) {
        return s == null ? "" : s.trim();
    }

    public static String atauNull(String s) {
        String t = bersih(s);
        return t.isEmpty() ? null : t;
    }

    public static int toInt(String s, int def) {
        try { return Integer.parseInt(bersih(s)); } catch (Exception e) { return def; }
    }

    public static Integer toIntObj(String s) {
        try { return Integer.valueOf(bersih(s)); } catch (Exception e) { return null; }
    }

    public static Date toDate(String s) {
        try { return Date.valueOf(bersih(s)); } catch (Exception e) { return null; }
    }
}
