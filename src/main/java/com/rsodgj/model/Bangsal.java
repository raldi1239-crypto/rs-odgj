package com.rsodgj.model;


public class Bangsal {
    private int idBangsal;
    private String namaBangsal;
    private String jenis;
    private int kapasitas;
    private String keterangan;
    private int terisi;

    public int getIdBangsal() { return idBangsal; }
    public void setIdBangsal(int idBangsal) { this.idBangsal = idBangsal; }
    public String getNamaBangsal() { return namaBangsal; }
    public void setNamaBangsal(String namaBangsal) { this.namaBangsal = namaBangsal; }
    public String getJenis() { return jenis; }
    public void setJenis(String jenis) { this.jenis = jenis; }
    public int getKapasitas() { return kapasitas; }
    public void setKapasitas(int kapasitas) { this.kapasitas = kapasitas; }
    public String getKeterangan() { return keterangan; }
    public void setKeterangan(String keterangan) { this.keterangan = keterangan; }
    public int getTerisi() { return terisi; }
    public void setTerisi(int terisi) { this.terisi = terisi; }

    public int getTersedia() { return Math.max(0, kapasitas - terisi); }
    public int getPersen() { return kapasitas == 0 ? 0 : Math.min(100, Math.round(terisi * 100f / kapasitas)); }
}
