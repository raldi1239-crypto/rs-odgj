<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Rekam medis pasien"/>
    <jsp:param name="menu" value="pasien"/>
</jsp:include>
<c:set var="dokter" value="${sessionScope.userAktif.role == 'Dokter'}"/>

<a href="${ctx}/klinis/pasien" class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-moss-600 hover:text-brand-700"><i class="fa-solid fa-arrow-left text-xs"></i>Kembali ke daftar pasien</a>

<div class="mb-6 flex flex-wrap items-start justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900"><c:out value="${pasien.namaPasien}"/></h2>
        <div class="mt-2 flex flex-wrap items-center gap-2">
            <span class="text-sm font-semibold text-moss-500">${pasien.noRm}</span>
            <t:risiko nilai="${pasien.tingkatRisiko}"/>
            <t:status nilai="${pasien.statusRawat}"/>
        </div>
        <c:if test="${not empty pasien.diagnosaUtama}"><p class="mt-2 text-sm text-moss-600">Diagnosa utama: <strong class="text-moss-900"><c:out value="${pasien.diagnosaUtama}"/></strong></p></c:if>
    </div>
    <a href="#catatan-baru" class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i>Tambah catatan</a>
</div>

<div class="grid gap-6 lg:grid-cols-[340px_1fr]">
    <div class="space-y-6">
        <jsp:include page="/WEB-INF/views/layout/_identitas.jsp"/>

        <c:if test="${not empty riwayat}">
            <c:set var="r" value="${riwayat[0]}"/>
            <section class="card p-6">
                <h3 class="section-title">Tanda vital terakhir</h3>
                <p class="text-xs text-moss-500"><fmt:formatDate value="${r.waktuCatat}" pattern="dd MMM yyyy, HH:mm"/></p>
                <div class="mt-4 grid grid-cols-3 gap-3 text-center">
                    <div class="rounded-lg bg-moss-50 p-3"><p class="text-lg font-extrabold text-moss-900"><c:out value="${empty r.tekananDarah ? '-' : r.tekananDarah}"/></p><p class="text-[11px] text-moss-500">Tekanan darah</p></div>
                    <div class="rounded-lg bg-moss-50 p-3"><p class="text-lg font-extrabold text-moss-900">${r.nadi != null ? r.nadi : '-'}</p><p class="text-[11px] text-moss-500">Nadi/menit</p></div>
                    <div class="rounded-lg bg-moss-50 p-3"><p class="text-lg font-extrabold text-moss-900">${r.suhu != null ? r.suhu : '-'}</p><p class="text-[11px] text-moss-500">Suhu &deg;C</p></div>
                </div>
                <div class="mt-4 flex items-center justify-between text-sm"><span class="text-moss-500">Kondisi terakhir</span><t:kondisi nilai="${r.kondisi}"/></div>
            </section>
        </c:if>
    </div>

    <div class="space-y-8">
        <section id="catatan-baru" class="card scroll-mt-4 p-6">
            <h3 class="section-title">Catatan baru</h3>
            <p class="text-sm text-moss-500">Catat hasil pemeriksaan hari ini. Isi minimal keluhan atau observasi.</p>

            <form method="post" action="${ctx}/klinis/pasien" class="mt-5 space-y-5" autocomplete="off">
                <t:csrf/>
                <input type="hidden" name="idPasien" value="${pasien.idPasien}">

                <div>
                    <span class="label">Kondisi pasien</span>
                    <div class="grid grid-cols-3 gap-3">
                        <label class="flex cursor-pointer items-center justify-center gap-2 rounded-lg border border-moss-300 px-3 py-2.5 text-sm font-semibold has-[:checked]:border-brand-600 has-[:checked]:bg-brand-50 has-[:checked]:text-brand-800"><input type="radio" name="kondisi" value="Membaik" class="accent-brand-600">Membaik</label>
                        <label class="flex cursor-pointer items-center justify-center gap-2 rounded-lg border border-moss-300 px-3 py-2.5 text-sm font-semibold has-[:checked]:border-moss-600 has-[:checked]:bg-moss-100"><input type="radio" name="kondisi" value="Stabil" class="accent-moss-600" checked>Stabil</label>
                        <label class="flex cursor-pointer items-center justify-center gap-2 rounded-lg border border-moss-300 px-3 py-2.5 text-sm font-semibold has-[:checked]:border-red-600 has-[:checked]:bg-red-50 has-[:checked]:text-red-800"><input type="radio" name="kondisi" value="Memburuk" class="accent-red-600">Memburuk</label>
                    </div>
                </div>

                <div class="grid gap-4 sm:grid-cols-3">
                    <div><label class="label" for="td">Tekanan darah</label><input id="td" name="tekananDarah" class="input" placeholder="120/80" pattern="\d{2,3}/\d{2,3}" maxlength="7"></div>
                    <div><label class="label" for="nadi">Nadi (x/menit)</label><input id="nadi" name="nadi" type="number" min="20" max="250" class="input" placeholder="80"></div>
                    <div><label class="label" for="suhu">Suhu (&deg;C)</label><input id="suhu" name="suhu" type="number" step="0.1" min="30" max="45" class="input" placeholder="36.5"></div>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <div><label class="label" for="keluhan">Keluhan</label><textarea id="keluhan" name="keluhan" rows="3" class="input" placeholder="Apa yang dikeluhkan atau terlihat dari pasien?"></textarea></div>
                    <div><label class="label" for="observasi">Hasil observasi</label><textarea id="observasi" name="observasi" rows="3" class="input" placeholder="Perilaku, afek, interaksi, kepatuhan obat"></textarea></div>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <div><label class="label" for="diagnosa">Diagnosa</label><input id="diagnosa" name="diagnosa" class="input" maxlength="120" value="<c:out value='${pasien.diagnosaUtama}'/>"></div>
                    <div><label class="label" for="terapi">Terapi dan tindakan</label><input id="terapi" name="terapi" class="input" placeholder="Obat, dosis, terapi kelompok"></div>
                </div>

                <c:if test="${dokter}">
                    <div class="rounded-lg border border-brand-200 bg-brand-50 p-4">
                        <label class="label" for="tingkatRisiko">Perbarui tingkat risiko pasien</label>
                        <select id="tingkatRisiko" name="tingkatRisiko" class="input max-w-xs">
                            <c:forTokens items="Rendah,Sedang,Tinggi,Isolasi" delims="," var="k"><option value="${k}" ${pasien.tingkatRisiko == k ? 'selected' : ''}>${k}</option></c:forTokens>
                        </select>
                        <p class="hint">Hanya dokter yang dapat mengubah tingkat risiko. Biarkan jika tidak berubah.</p>
                    </div>
                </c:if>

                <div class="flex justify-end"><button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i>Simpan catatan</button></div>
            </form>
        </section>

        <jsp:include page="/WEB-INF/views/layout/_riwayat.jsp"/>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
