package com.rsodgj.controller;

import com.rsodgj.dao.PasienDAO;
import com.rsodgj.model.Pasien;
import com.rsodgj.util.Teks;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

/** Ekspor data pasien (sesuai filter yang sedang aktif) ke CSV yang dapat dibuka di Excel. */
@WebServlet("/admin/pasien/export")
public class ExportController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String q = Teks.bersih(req.getParameter("q"));
        String risiko = Teks.bersih(req.getParameter("risiko"));
        String status = Teks.bersih(req.getParameter("status"));

        res.setContentType("text/csv; charset=UTF-8");
        res.setHeader("Content-Disposition", "attachment; filename=\"data-pasien-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".csv\"");

        PrintWriter w = res.getWriter();
        w.write('\uFEFF'); // BOM agar Excel membaca UTF-8
        w.print("No RM;NIK;Nama;Jenis Kelamin;Umur;Diagnosa;Risiko;Status;Bangsal;Dokter;Tanggal Masuk;Tanggal Keluar\r\n");
        for (Pasien p : new PasienDAO().cari(q, risiko, status, "terbaru", 0, 0)) {
            w.print(String.join(";",
                    sel(p.getNoRm()), sel("'" + p.getNik()), sel(p.getNamaPasien()), sel(p.getJenisKelaminLengkap()),
                    String.valueOf(p.getUmur()), sel(p.getDiagnosaUtama()), sel(p.getTingkatRisiko()), sel(p.getStatusRawat()),
                    sel(p.getNamaBangsal()), sel(p.getNamaDokter()),
                    sel(String.valueOf(p.getTanggalMasuk())), sel(p.getTanggalKeluar() == null ? "" : p.getTanggalKeluar().toString())));
            w.print("\r\n");
        }
    }

    /** Escape sel CSV dan cegah formula injection di Excel. */
    private static String sel(String s) {
        if (s == null) return "";
        if (!s.isEmpty() && "=+-@".indexOf(s.charAt(0)) >= 0) s = "'" + s;
        return "\"" + s.replace("\"", "\"\"") + "\"";
    }
}
