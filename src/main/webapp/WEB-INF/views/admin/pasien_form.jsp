<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="baru" value="${pasien.idPasien == 0}"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="${baru ? 'Daftarkan pasien' : 'Ubah data pasien'}"/>
    <jsp:param name="menu" value="pasien"/>
</jsp:include>

<a href="${ctx}/admin/pasien" class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-moss-600 hover:text-brand-700"><i class="fa-solid fa-arrow-left text-xs"></i>Kembali ke daftar pasien</a>
<h2 class="mb-6 text-2xl font-extrabold tracking-tight text-moss-900">${baru ? 'Daftarkan pasien baru' : 'Ubah data pasien'}<c:if test="${!baru}"> <span class="text-moss-400">${pasien.noRm}</span></c:if></h2>

<c:if test="${not empty error}">
    <div role="alert" class="mb-6 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900">
        <i class="fa-solid fa-circle-exclamation mt-0.5 text-red-600"></i><p class="font-medium"><c:out value="${error}"/></p>
    </div>
</c:if>

<form method="post" action="${ctx}/admin/pasien" class="space-y-6" autocomplete="off">
    <t:csrf/>
    <input type="hidden" name="aksi" value="simpan">
    <input type="hidden" name="id" value="${pasien.idPasien}">

    <section class="card p-6">
        <h3 class="section-title">Identitas pasien</h3>
        <div class="mt-5 grid gap-5 md:grid-cols-2">
            <div>
                <label class="label" for="nik">NIK</label>
                <input id="nik" name="nik" class="input" inputmode="numeric" maxlength="16" pattern="\d{16}" required value="<c:out value='${pasien.nik}'/>" placeholder="16 digit angka">
                <p class="hint">Sesuai KTP atau Kartu Keluarga.</p>
            </div>
            <div>
                <label class="label" for="namaPasien">Nama lengkap</label>
                <input id="namaPasien" name="namaPasien" class="input" required minlength="3" maxlength="100" value="<c:out value='${pasien.namaPasien}'/>">
            </div>
            <div>
                <span class="label">Jenis kelamin</span>
                <div class="flex gap-3">
                    <label class="flex flex-1 cursor-pointer items-center gap-2 rounded-lg border border-moss-300 px-3.5 py-2.5 text-sm has-[:checked]:border-brand-600 has-[:checked]:bg-brand-50">
                        <input type="radio" name="jenisKelamin" value="L" class="accent-brand-600" ${pasien.jenisKelamin == 'L' ? 'checked' : ''} required>Laki-laki</label>
                    <label class="flex flex-1 cursor-pointer items-center gap-2 rounded-lg border border-moss-300 px-3.5 py-2.5 text-sm has-[:checked]:border-brand-600 has-[:checked]:bg-brand-50">
                        <input type="radio" name="jenisKelamin" value="P" class="accent-brand-600" ${pasien.jenisKelamin == 'P' ? 'checked' : ''}>Perempuan</label>
                </div>
            </div>
            <div>
                <label class="label" for="tanggalLahir">Tanggal lahir</label>
                <input id="tanggalLahir" type="date" name="tanggalLahir" class="input" required value="${pasien.tanggalLahir}">
            </div>
            <div class="md:col-span-2">
                <label class="label" for="alamat">Alamat</label>
                <textarea id="alamat" name="alamat" rows="2" maxlength="255" class="input"><c:out value="${pasien.alamat}"/></textarea>
            </div>
        </div>
    </section>

    <section class="card p-6">
        <h3 class="section-title">Keluarga penanggung jawab</h3>
        <div class="mt-5 grid gap-5 md:grid-cols-2">
            <div>
                <label class="label" for="namaKeluarga">Nama keluarga</label>
                <input id="namaKeluarga" name="namaKeluarga" class="input" maxlength="100" value="<c:out value='${pasien.namaKeluarga}'/>">
            </div>
            <div>
                <label class="label" for="teleponKeluarga">Nomor telepon</label>
                <input id="teleponKeluarga" name="teleponKeluarga" class="input" inputmode="tel" maxlength="20" value="<c:out value='${pasien.teleponKeluarga}'/>" placeholder="08xxxxxxxxxx">
            </div>
        </div>
    </section>

    <section class="card p-6">
        <h3 class="section-title">Penanganan klinis</h3>
        <div class="mt-5 grid gap-5 md:grid-cols-2">
            <div class="md:col-span-2">
                <label class="label" for="diagnosaUtama">Diagnosa utama</label>
                <input id="diagnosaUtama" name="diagnosaUtama" class="input" maxlength="120" value="<c:out value='${pasien.diagnosaUtama}'/>" placeholder="Contoh: Skizofrenia paranoid">
            </div>
            <div>
                <label class="label" for="tingkatRisiko">Tingkat risiko</label>
                <select id="tingkatRisiko" name="tingkatRisiko" class="input">
                    <option value="Rendah" ${pasien.tingkatRisiko == 'Rendah' ? 'selected' : ''}>Rendah - bangsal tenang</option>
                    <option value="Sedang" ${pasien.tingkatRisiko == 'Sedang' ? 'selected' : ''}>Sedang - perlu observasi</option>
                    <option value="Tinggi" ${pasien.tingkatRisiko == 'Tinggi' ? 'selected' : ''}>Tinggi - fase akut</option>
                    <option value="Isolasi" ${pasien.tingkatRisiko == 'Isolasi' ? 'selected' : ''}>Isolasi - berisiko membahayakan</option>
                </select>
            </div>
            <div>
                <label class="label" for="idDokter">Dokter penanggung jawab</label>
                <select id="idDokter" name="idDokter" class="input">
                    <option value="">Belum ditentukan</option>
                    <c:forEach var="d" items="${listDokter}"><option value="${d.idUser}" ${pasien.idDokter == d.idUser ? 'selected' : ''}><c:out value="${d.namaLengkap}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="label" for="statusRawat">Status rawat</label>
                <select id="statusRawat" name="statusRawat" class="input">
                    <c:forTokens items="Rawat Inap,Rawat Jalan,Pulang" delims="," var="s"><option value="${s}" ${pasien.statusRawat == s ? 'selected' : ''}>${s}</option></c:forTokens>
                </select>
            </div>
            <div id="boxBangsal">
                <label class="label" for="idBangsal">Bangsal</label>
                <select id="idBangsal" name="idBangsal" class="input">
                    <option value="">Pilih bangsal</option>
                    <c:forEach var="b" items="${listBangsal}">
                        <option value="${b.idBangsal}" ${pasien.idBangsal == b.idBangsal ? 'selected' : ''}><c:out value="${b.namaBangsal}"/> (${b.jenis}) - terisi ${b.terisi}/${b.kapasitas}</option>
                    </c:forEach>
                </select>
                <p class="hint">Tempat tidur yang sedang dipakai pasien ini ikut dihitung pada angka terisi.</p>
            </div>
            <div>
                <label class="label" for="tanggalMasuk">Tanggal masuk</label>
                <input id="tanggalMasuk" type="date" name="tanggalMasuk" class="input" required value="${pasien.tanggalMasuk}">
            </div>
            <div id="boxKeluar">
                <label class="label" for="tanggalKeluar">Tanggal keluar</label>
                <input id="tanggalKeluar" type="date" name="tanggalKeluar" class="input" value="${pasien.tanggalKeluar}">
                <p class="hint">Kosongkan untuk memakai tanggal hari ini.</p>
            </div>
        </div>
    </section>

    <div class="flex justify-end gap-3">
        <a href="${ctx}/admin/pasien" class="btn btn-outline">Batal</a>
        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i>${baru ? 'Simpan pasien' : 'Simpan perubahan'}</button>
    </div>
</form>

<script>
    (function () {
        var status = document.getElementById('statusRawat'), bangsal = document.getElementById('idBangsal'),
            boxBangsal = document.getElementById('boxBangsal'), boxKeluar = document.getElementById('boxKeluar');
        function terapkan() {
            var inap = status.value === 'Rawat Inap';
            boxBangsal.classList.toggle('hidden', !inap);
            bangsal.disabled = !inap;
            bangsal.required = inap;
            boxKeluar.classList.toggle('hidden', status.value !== 'Pulang');
        }
        status.addEventListener('change', terapkan);
        terapkan();
        var hariIni = new Date().toISOString().slice(0, 10);
        document.getElementById('tanggalLahir').max = hariIni;
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
