package com.rsodgj.controller;

import com.rsodgj.dao.PasienDAO;
import com.rsodgj.model.Pasien;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/admin/laporan")
public class LaporanController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        LocalDate hariIni = LocalDate.now();
        Date dari = Teks.toDate(req.getParameter("dari"));
        Date sampai = Teks.toDate(req.getParameter("sampai"));
        if (dari == null) dari = Date.valueOf(hariIni.withDayOfMonth(1));
        if (sampai == null) sampai = Date.valueOf(hariIni);
        if (dari.after(sampai)) { Date t = dari; dari = sampai; sampai = t; }

        List<Pasien> data = new PasienDAO().masukPada(dari, sampai);

        Map<String, Integer> risiko = new LinkedHashMap<>();
        for (String k : new String[]{"Rendah", "Sedang", "Tinggi", "Isolasi"}) risiko.put(k, 0);
        Map<String, Integer> status = new LinkedHashMap<>();
        for (String k : new String[]{"Rawat Inap", "Rawat Jalan", "Pulang"}) status.put(k, 0);
        Map<String, Integer> diagnosa = new HashMap<>();
        int laki = 0;
        for (Pasien p : data) {
            risiko.merge(p.getTingkatRisiko(), 1, Integer::sum);
            status.merge(p.getStatusRawat(), 1, Integer::sum);
            if ("L".equals(p.getJenisKelamin())) laki++;
            String d = p.getDiagnosaUtama() == null || p.getDiagnosaUtama().isEmpty() ? "Belum ada diagnosa" : p.getDiagnosaUtama();
            diagnosa.merge(d, 1, Integer::sum);
        }
        List<Map.Entry<String, Integer>> topDiagnosa = new ArrayList<>(diagnosa.entrySet());
        topDiagnosa.sort((a, b) -> b.getValue() - a.getValue());
        if (topDiagnosa.size() > 5) topDiagnosa = new ArrayList<>(topDiagnosa.subList(0, 5));

        req.setAttribute("dari", dari);
        req.setAttribute("sampai", sampai);
        req.setAttribute("data", data);
        req.setAttribute("risikoMap", risiko);
        req.setAttribute("statusMap", status);
        req.setAttribute("topDiagnosa", topDiagnosa);
        req.setAttribute("jumlahLaki", laki);
        req.setAttribute("jumlahPerempuan", data.size() - laki);
        Rute.tampil(req, res, "admin/laporan");
    }
}
