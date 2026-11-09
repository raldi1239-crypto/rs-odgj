package com.rsodgj.model;


public class User {
    private int idUser;
    private String username;
    private String namaLengkap;
    private String role;
    private boolean statusAktif;
    private java.sql.Timestamp dibuatPada;

    public int getIdUser() { return idUser; }
    public void setIdUser(int idUser) { this.idUser = idUser; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getNamaLengkap() { return namaLengkap; }
    public void setNamaLengkap(String namaLengkap) { this.namaLengkap = namaLengkap; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public boolean isStatusAktif() { return statusAktif; }
    public void setStatusAktif(boolean statusAktif) { this.statusAktif = statusAktif; }
    public java.sql.Timestamp getDibuatPada() { return dibuatPada; }
    public void setDibuatPada(java.sql.Timestamp dibuatPada) { this.dibuatPada = dibuatPada; }

    public boolean isAdmin() { return "Admin".equals(role); }
    public boolean isKlinis() { return "Dokter".equals(role) || "Perawat".equals(role); }
    public String getInisial() {
        if (namaLengkap == null || namaLengkap.isEmpty()) return "?";
        String n = namaLengkap.replaceFirst("^(dr\\.|Ns\\.)\\s*", "");
        return n.substring(0, 1).toUpperCase();
    }
}
