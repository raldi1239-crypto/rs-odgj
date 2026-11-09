package com.rsodgj.model;


public class Pasien {
    private int idPasien;
    private String nik;
    private String namaPasien;
    private String jenisKelamin;
    private java.sql.Date tanggalLahir;
    private String alamat;
    private String namaKeluarga;
    private String teleponKeluarga;
    private String diagnosaUtama;
    private String tingkatRisiko;
    private String statusRawat;
    private Integer idBangsal;
    private Integer idDokter;
    private java.sql.Date tanggalMasuk;
    private java.sql.Date tanggalKeluar;
    private String namaBangsal;
    private String namaDokter;

    public int getIdPasien() { return idPasien; }
    public void setIdPasien(int idPasien) { this.idPasien = idPasien; }
    public String getNik() { return nik; }
    public void setNik(String nik) { this.nik = nik; }
    public String getNamaPasien() { return namaPasien; }
    public void setNamaPasien(String namaPasien) { this.namaPasien = namaPasien; }
    public String getJenisKelamin() { return jenisKelamin; }
    public void setJenisKelamin(String jenisKelamin) { this.jenisKelamin = jenisKelamin; }
    public java.sql.Date getTanggalLahir() { return tanggalLahir; }
    public void setTanggalLahir(java.sql.Date tanggalLahir) { this.tanggalLahir = tanggalLahir; }
    public String getAlamat() { return alamat; }
    public void setAlamat(String alamat) { this.alamat = alamat; }
    public String getNamaKeluarga() { return namaKeluarga; }
    public void setNamaKeluarga(String namaKeluarga) { this.namaKeluarga = namaKeluarga; }
    public String getTeleponKeluarga() { return teleponKeluarga; }
    public void setTeleponKeluarga(String teleponKeluarga) { this.teleponKeluarga = teleponKeluarga; }
    public String getDiagnosaUtama() { return diagnosaUtama; }
    public void setDiagnosaUtama(String diagnosaUtama) { this.diagnosaUtama = diagnosaUtama; }
    public String getTingkatRisiko() { return tingkatRisiko; }
    public void setTingkatRisiko(String tingkatRisiko) { this.tingkatRisiko = tingkatRisiko; }
    public String getStatusRawat() { return statusRawat; }
    public void setStatusRawat(String statusRawat) { this.statusRawat = statusRawat; }
    public Integer getIdBangsal() { return idBangsal; }
    public void setIdBangsal(Integer idBangsal) { this.idBangsal = idBangsal; }
    public Integer getIdDokter() { return idDokter; }
    public void setIdDokter(Integer idDokter) { this.idDokter = idDokter; }
    public java.sql.Date getTanggalMasuk() { return tanggalMasuk; }
    public void setTanggalMasuk(java.sql.Date tanggalMasuk) { this.tanggalMasuk = tanggalMasuk; }
    public java.sql.Date getTanggalKeluar() { return tanggalKeluar; }
    public void setTanggalKeluar(java.sql.Date tanggalKeluar) { this.tanggalKeluar = tanggalKeluar; }
    public String getNamaBangsal() { return namaBangsal; }
    public void setNamaBangsal(String namaBangsal) { this.namaBangsal = namaBangsal; }
    public String getNamaDokter() { return namaDokter; }
    public void setNamaDokter(String namaDokter) { this.namaDokter = namaDokter; }

    public String getNoRm() { return String.format("RM-%06d", idPasien); }
    public int getUmur() {
        if (tanggalLahir == null) return 0;
        return java.time.Period.between(tanggalLahir.toLocalDate(), java.time.LocalDate.now()).getYears();
    }
    public String getJenisKelaminLengkap() { return "L".equals(jenisKelamin) ? "Laki-laki" : "Perempuan"; }
    public long getLamaRawat() {
        if (tanggalMasuk == null) return 0;
        java.time.LocalDate akhir = tanggalKeluar != null ? tanggalKeluar.toLocalDate() : java.time.LocalDate.now();
        return java.time.temporal.ChronoUnit.DAYS.between(tanggalMasuk.toLocalDate(), akhir);
    }
}
