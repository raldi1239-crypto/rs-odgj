package com.rsodgj.model;


public class RekamMedis {
    private int idRekam;
    private int idPasien;
    private String namaPasien;
    private String namaPetugas;
    private String rolePetugas;
    private java.sql.Timestamp waktuCatat;
    private String keluhan;
    private String observasi;
    private String diagnosa;
    private String terapi;
    private String tekananDarah;
    private Integer nadi;
    private java.math.BigDecimal suhu;
    private String kondisi;

    public int getIdRekam() { return idRekam; }
    public void setIdRekam(int idRekam) { this.idRekam = idRekam; }
    public int getIdPasien() { return idPasien; }
    public void setIdPasien(int idPasien) { this.idPasien = idPasien; }
    public String getNamaPasien() { return namaPasien; }
    public void setNamaPasien(String namaPasien) { this.namaPasien = namaPasien; }
    public String getNamaPetugas() { return namaPetugas; }
    public void setNamaPetugas(String namaPetugas) { this.namaPetugas = namaPetugas; }
    public String getRolePetugas() { return rolePetugas; }
    public void setRolePetugas(String rolePetugas) { this.rolePetugas = rolePetugas; }
    public java.sql.Timestamp getWaktuCatat() { return waktuCatat; }
    public void setWaktuCatat(java.sql.Timestamp waktuCatat) { this.waktuCatat = waktuCatat; }
    public String getKeluhan() { return keluhan; }
    public void setKeluhan(String keluhan) { this.keluhan = keluhan; }
    public String getObservasi() { return observasi; }
    public void setObservasi(String observasi) { this.observasi = observasi; }
    public String getDiagnosa() { return diagnosa; }
    public void setDiagnosa(String diagnosa) { this.diagnosa = diagnosa; }
    public String getTerapi() { return terapi; }
    public void setTerapi(String terapi) { this.terapi = terapi; }
    public String getTekananDarah() { return tekananDarah; }
    public void setTekananDarah(String tekananDarah) { this.tekananDarah = tekananDarah; }
    public Integer getNadi() { return nadi; }
    public void setNadi(Integer nadi) { this.nadi = nadi; }
    public java.math.BigDecimal getSuhu() { return suhu; }
    public void setSuhu(java.math.BigDecimal suhu) { this.suhu = suhu; }
    public String getKondisi() { return kondisi; }
    public void setKondisi(String kondisi) { this.kondisi = kondisi; }
}
