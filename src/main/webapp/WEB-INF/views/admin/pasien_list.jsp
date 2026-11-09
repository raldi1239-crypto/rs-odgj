<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Data pasien"/>
    <jsp:param name="menu" value="pasien"/>
</jsp:include>
<c:url var="urlEkspor" value="/admin/pasien/export"><c:param name="q" value="${q}"/><c:param name="risiko" value="${risiko}"/><c:param name="status" value="${status}"/></c:url>
<c:set var="ada" value="${not empty q || not empty risiko || not empty status}"/>

<div class="mb-6 flex flex-wrap items-end justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Manajemen pasien</h2>
        <p class="mt-1 text-moss-500">${total} pasien <c:if test="${ada}">sesuai filter</c:if><c:if test="${!ada}">terdaftar</c:if>.</p>
    </div>
    <div class="flex gap-3">
        <a href="${urlEkspor}" class="btn btn-outline"><i class="fa-solid fa-file-csv"></i>Ekspor CSV</a>
        <a href="${ctx}/admin/pasien?aksi=tambah" class="btn btn-primary"><i class="fa-solid fa-user-plus"></i>Daftarkan pasien</a>
    </div>
</div>

<form method="get" action="${ctx}/admin/pasien" class="card mb-5 grid gap-3 p-4 md:grid-cols-[1fr_180px_180px_auto]">
    <div class="relative">
        <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-1/2 -translate-y-1/2 text-moss-400"></i>
        <input type="search" name="q" value="<c:out value='${q}'/>" placeholder="Cari nama, NIK, nomor RM, atau diagnosa" class="input pl-10" aria-label="Cari pasien">
    </div>
    <select name="risiko" class="input" aria-label="Filter risiko">
        <option value="">Semua risiko</option>
        <c:forTokens items="Rendah,Sedang,Tinggi,Isolasi" delims="," var="r"><option value="${r}" ${risiko == r ? 'selected' : ''}>${r}</option></c:forTokens>
    </select>
    <select name="status" class="input" aria-label="Filter status">
        <option value="">Semua status</option>
        <c:forTokens items="Rawat Inap,Rawat Jalan,Pulang" delims="," var="s"><option value="${s}" ${status == s ? 'selected' : ''}>${s}</option></c:forTokens>
    </select>
    <div class="flex gap-2">
        <button type="submit" class="btn btn-primary">Terapkan</button>
        <c:if test="${ada}"><a href="${ctx}/admin/pasien" class="btn btn-outline">Reset</a></c:if>
    </div>
</form>

<section class="card overflow-hidden">
    <div class="overflow-x-auto">
        <table class="tbl w-full min-w-[960px]">
            <thead><tr><th>Pasien</th><th>Umur</th><th>Diagnosa</th><th>Risiko</th><th>Status dan bangsal</th><th>Tanggal masuk</th><th class="text-right">Aksi</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${listPasien}">
                <tr class="hover:bg-moss-50">
                    <td>
                        <a href="${ctx}/admin/pasien?aksi=detail&id=${p.idPasien}" class="font-semibold text-moss-900 hover:text-brand-700"><c:out value="${p.namaPasien}"/></a>
                        <p class="text-xs text-moss-500">${p.noRm} &middot; <c:out value="${p.nik}"/></p>
                    </td>
                    <td class="text-moss-600">${p.umur} th, ${p.jenisKelamin}</td>
                    <td class="max-w-[220px] truncate text-moss-600"><c:out value="${empty p.diagnosaUtama ? '-' : p.diagnosaUtama}"/></td>
                    <td><t:risiko nilai="${p.tingkatRisiko}"/></td>
                    <td><t:status nilai="${p.statusRawat}"/><c:if test="${not empty p.namaBangsal}"><p class="mt-1 text-xs text-moss-500"><c:out value="${p.namaBangsal}"/></p></c:if></td>
                    <td class="text-moss-600"><fmt:formatDate value="${p.tanggalMasuk}" pattern="dd MMM yyyy"/></td>
                    <td>
                        <div class="flex justify-end gap-2">
                            <a href="${ctx}/admin/pasien?aksi=detail&id=${p.idPasien}" class="btn btn-outline btn-sm" title="Lihat detail"><i class="fa-solid fa-eye"></i></a>
                            <a href="${ctx}/admin/pasien?aksi=ubah&id=${p.idPasien}" class="btn btn-outline btn-sm" title="Ubah data"><i class="fa-solid fa-pen"></i></a>
                            <button type="button" class="btn btn-danger btn-sm" title="Hapus" data-id="${p.idPasien}" data-nama="<c:out value='${p.namaPasien}'/>" onclick="konfirmasiHapus(this)"><i class="fa-solid fa-trash"></i></button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listPasien}">
                <tr><td colspan="7" class="py-14 text-center">
                    <span class="mx-auto grid h-12 w-12 place-items-center rounded-full bg-moss-100 text-moss-400"><i class="fa-solid fa-user-slash"></i></span>
                    <p class="mt-3 font-semibold text-moss-800"><c:choose><c:when test="${ada}">Tidak ada pasien yang cocok</c:when><c:otherwise>Belum ada pasien terdaftar</c:otherwise></c:choose></p>
                    <p class="mt-1 text-sm text-moss-500"><c:choose><c:when test="${ada}">Ubah kata kunci atau reset filter.</c:when><c:otherwise>Daftarkan pasien pertama untuk memulai.</c:otherwise></c:choose></p>
                </td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
    <c:if test="${totalHalaman > 1}">
        <div class="flex flex-wrap items-center justify-between gap-3 border-t border-moss-100 px-5 py-4">
            <p class="text-sm text-moss-500">Halaman ${halaman} dari ${totalHalaman}</p>
            <t:paging base="/admin/pasien" halaman="${halaman}" totalHalaman="${totalHalaman}" q="${q}" risiko="${risiko}" status="${status}"/>
        </div>
    </c:if>
</section>

<dialog id="dlgHapus" class="w-full max-w-md">
    <form method="post" action="${ctx}/admin/pasien" class="p-6">
        <t:csrf/>
        <input type="hidden" name="aksi" value="hapus">
        <input type="hidden" name="id" id="hapusId">
        <span class="grid h-12 w-12 place-items-center rounded-full bg-red-100 text-red-700"><i class="fa-solid fa-trash"></i></span>
        <h3 class="mt-4 text-lg font-extrabold text-moss-900">Hapus data pasien?</h3>
        <p class="mt-2 text-sm text-moss-600"><strong id="hapusNama"></strong> beserta seluruh rekam medisnya akan dihapus permanen dan tidak dapat dikembalikan.</p>
        <div class="mt-6 flex justify-end gap-3">
            <button type="button" class="btn btn-outline" onclick="document.getElementById('dlgHapus').close()">Batal</button>
            <button type="submit" class="btn bg-red-600 text-white hover:bg-red-700">Ya, hapus</button>
        </div>
    </form>
</dialog>
<script>
    function konfirmasiHapus(btn) {
        document.getElementById('hapusId').value = btn.dataset.id;
        document.getElementById('hapusNama').textContent = btn.dataset.nama;
        document.getElementById('dlgHapus').showModal();
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
