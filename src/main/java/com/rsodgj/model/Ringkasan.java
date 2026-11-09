package com.rsodgj.model;

public class Ringkasan {
    private int totalPasien;
    private int rawatInap;
    private int rawatJalan;
    private int pulang;
    private int pasienBerisiko;
    private int kapasitas;
    private int terisi;
    private int masukBulanIni;
    private int catatanHariIni;
    private java.util.Map<String,Integer> risiko;
    private java.util.Map<String,Integer> tren;

    public int getTotalPasien() { return totalPasien; }
    public void setTotalPasien(int totalPasien) { this.totalPasien = totalPasien; }
    public int getRawatInap() { return rawatInap; }
    public void setRawatInap(int rawatInap) { this.rawatInap = rawatInap; }
    public int getRawatJalan() { return rawatJalan; }
    public void setRawatJalan(int rawatJalan) { this.rawatJalan = rawatJalan; }
    public int getPulang() { return pulang; }
    public void setPulang(int pulang) { this.pulang = pulang; }
    public int getPasienBerisiko() { return pasienBerisiko; }
    public void setPasienBerisiko(int pasienBerisiko) { this.pasienBerisiko = pasienBerisiko; }
    public int getKapasitas() { return kapasitas; }
    public void setKapasitas(int kapasitas) { this.kapasitas = kapasitas; }
    public int getTerisi() { return terisi; }
    public void setTerisi(int terisi) { this.terisi = terisi; }
    public int getMasukBulanIni() { return masukBulanIni; }
    public void setMasukBulanIni(int masukBulanIni) { this.masukBulanIni = masukBulanIni; }
    public int getCatatanHariIni() { return catatanHariIni; }
    public void setCatatanHariIni(int catatanHariIni) { this.catatanHariIni = catatanHariIni; }
    public java.util.Map<String,Integer> getRisiko() { return risiko; }
    public void setRisiko(java.util.Map<String,Integer> risiko) { this.risiko = risiko; }
    public java.util.Map<String,Integer> getTren() { return tren; }
    public void setTren(java.util.Map<String,Integer> tren) { this.tren = tren; }

    public int getTersedia() { return Math.max(0, kapasitas - terisi); }
    public int getPersenHunian() { return kapasitas == 0 ? 0 : Math.min(100, Math.round(terisi * 100f / kapasitas)); }
    public int getTrenMaks() {
        int m = 1;
        if (tren != null) for (int v : tren.values()) m = Math.max(m, v);
        return m;
    }
}
