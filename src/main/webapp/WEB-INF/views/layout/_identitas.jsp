<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<section class="card p-6">
    <h3 class="section-title mb-4">Data pasien</h3>
    <dl class="space-y-4 text-sm">
        <div><dt class="text-xs font-semibold text-moss-500">NIK</dt><dd class="mt-0.5 font-medium text-moss-900"><c:out value="${pasien.nik}"/></dd></div>
        <div class="grid grid-cols-2 gap-4">
            <div><dt class="text-xs font-semibold text-moss-500">Jenis kelamin</dt><dd class="mt-0.5 font-medium text-moss-900">${pasien.jenisKelaminLengkap}</dd></div>
            <div><dt class="text-xs font-semibold text-moss-500">Umur</dt><dd class="mt-0.5 font-medium text-moss-900">${pasien.umur} tahun</dd></div>
        </div>
        <div><dt class="text-xs font-semibold text-moss-500">Tanggal lahir</dt><dd class="mt-0.5 font-medium text-moss-900"><fmt:formatDate value="${pasien.tanggalLahir}" pattern="dd MMMM yyyy"/></dd></div>
        <div><dt class="text-xs font-semibold text-moss-500">Alamat</dt><dd class="mt-0.5 font-medium text-moss-900"><c:out value="${empty pasien.alamat ? '-' : pasien.alamat}"/></dd></div>
        <div class="border-t border-moss-100 pt-4">
            <dt class="text-xs font-semibold text-moss-500">Keluarga penanggung jawab</dt>
            <dd class="mt-0.5 font-medium text-moss-900"><c:out value="${empty pasien.namaKeluarga ? '-' : pasien.namaKeluarga}"/></dd>
            <c:if test="${not empty pasien.teleponKeluarga}"><dd class="text-moss-600"><i class="fa-solid fa-phone mr-1.5 text-xs text-moss-400"></i><c:out value="${pasien.teleponKeluarga}"/></dd></c:if>
        </div>
        <div class="border-t border-moss-100 pt-4 grid grid-cols-2 gap-4">
            <div><dt class="text-xs font-semibold text-moss-500">Bangsal</dt><dd class="mt-0.5 font-medium text-moss-900"><c:out value="${empty pasien.namaBangsal ? '-' : pasien.namaBangsal}"/></dd></div>
            <div><dt class="text-xs font-semibold text-moss-500">Dokter</dt><dd class="mt-0.5 font-medium text-moss-900"><c:out value="${empty pasien.namaDokter ? '-' : pasien.namaDokter}"/></dd></div>
            <div><dt class="text-xs font-semibold text-moss-500">Tanggal masuk</dt><dd class="mt-0.5 font-medium text-moss-900"><fmt:formatDate value="${pasien.tanggalMasuk}" pattern="dd MMM yyyy"/></dd></div>
            <div><dt class="text-xs font-semibold text-moss-500">${empty pasien.tanggalKeluar ? 'Lama dirawat' : 'Tanggal keluar'}</dt>
                <dd class="mt-0.5 font-medium text-moss-900"><c:choose><c:when test="${empty pasien.tanggalKeluar}">${pasien.lamaRawat} hari</c:when><c:otherwise><fmt:formatDate value="${pasien.tanggalKeluar}" pattern="dd MMM yyyy"/></c:otherwise></c:choose></dd></div>
        </div>
    </dl>
</section>
