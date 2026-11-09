<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Laporan"/>
    <jsp:param name="menu" value="laporan"/>
</jsp:include>
<c:set var="jumlah" value="${data.size()}"/>

<!-- Kop khusus cetak -->
<div class="mb-6 hidden border-b-2 border-brand-700 pb-4 print:block">
    <div class="flex items-center gap-3">
        <img src="${ctx}/assets/logo.svg" alt="" class="h-12 w-12">
        <div>
            <p class="text-xl font-extrabold text-brand-900">RS ODGJ</p>
            <p class="text-sm text-moss-600">Rumah Sakit Orang Dengan Gangguan Jiwa</p>
        </div>
    </div>
    <p class="mt-4 text-base font-bold">Laporan pasien masuk</p>
    <p class="text-sm">Periode <fmt:formatDate value="${dari}" pattern="dd MMMM yyyy"/> sampai <fmt:formatDate value="${sampai}" pattern="dd MMMM yyyy"/></p>
</div>

<div class="mb-6 flex flex-wrap items-end justify-between gap-4 print:hidden">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Laporan pasien masuk</h2>
        <p class="mt-1 text-moss-500">Pilih periode untuk melihat ringkasan dan mencetak laporan.</p>
    </div>
    <button type="button" class="btn btn-primary" onclick="window.print()"><i class="fa-solid fa-print"></i>Cetak laporan</button>
</div>

<form method="get" action="${ctx}/admin/laporan" class="card mb-6 flex flex-wrap items-end gap-4 p-4 print:hidden">
    <div><label class="label" for="dari">Dari tanggal</label><input id="dari" type="date" name="dari" class="input" value="${dari}" required></div>
    <div><label class="label" for="sampai">Sampai tanggal</label><input id="sampai" type="date" name="sampai" class="input" value="${sampai}" required></div>
    <button type="submit" class="btn btn-primary">Tampilkan</button>
</form>

<div class="mb-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
    <div class="card p-5"><p class="text-sm font-semibold text-moss-500">Total pasien masuk</p><p class="mt-2 text-3xl font-extrabold text-moss-900">${jumlah}</p></div>
    <div class="card p-5"><p class="text-sm font-semibold text-moss-500">Laki-laki</p><p class="mt-2 text-3xl font-extrabold text-moss-900">${jumlahLaki}</p></div>
    <div class="card p-5"><p class="text-sm font-semibold text-moss-500">Perempuan</p><p class="mt-2 text-3xl font-extrabold text-moss-900">${jumlahPerempuan}</p></div>
    <div class="card p-5"><p class="text-sm font-semibold text-moss-500">Risiko tinggi dan isolasi</p><p class="mt-2 text-3xl font-extrabold text-red-700">${risikoMap['Tinggi'] + risikoMap['Isolasi']}</p></div>
</div>

<div class="mb-6 grid gap-6 lg:grid-cols-3">
    <section class="card p-6">
        <h3 class="section-title mb-4">Menurut tingkat risiko</h3>
        <ul class="space-y-3 text-sm">
            <c:forEach var="e" items="${risikoMap}"><li class="flex items-center justify-between"><t:risiko nilai="${e.key}"/><span class="font-bold text-moss-900">${e.value}</span></li></c:forEach>
        </ul>
    </section>
    <section class="card p-6">
        <h3 class="section-title mb-4">Menurut status rawat</h3>
        <ul class="space-y-3 text-sm">
            <c:forEach var="e" items="${statusMap}"><li class="flex items-center justify-between"><t:status nilai="${e.key}"/><span class="font-bold text-moss-900">${e.value}</span></li></c:forEach>
        </ul>
    </section>
    <section class="card p-6">
        <h3 class="section-title mb-4">Diagnosa terbanyak</h3>
        <c:choose>
            <c:when test="${empty topDiagnosa}"><p class="text-sm text-moss-500">Belum ada data pada periode ini.</p></c:when>
            <c:otherwise>
                <ul class="space-y-3 text-sm">
                    <c:forEach var="e" items="${topDiagnosa}"><li class="flex items-center justify-between gap-3"><span class="text-moss-700"><c:out value="${e.key}"/></span><span class="font-bold text-moss-900">${e.value}</span></li></c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<section class="card overflow-hidden">
    <div class="px-6 py-5"><h3 class="section-title">Daftar pasien masuk</h3></div>
    <div class="overflow-x-auto">
        <table class="tbl w-full min-w-[800px]">
            <thead><tr><th>Tanggal masuk</th><th>No RM</th><th>Nama</th><th>Diagnosa</th><th>Risiko</th><th>Status</th><th>Bangsal</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${data}">
                <tr>
                    <td><fmt:formatDate value="${p.tanggalMasuk}" pattern="dd MMM yyyy"/></td>
                    <td class="text-moss-600">${p.noRm}</td>
                    <td class="font-semibold text-moss-900"><c:out value="${p.namaPasien}"/></td>
                    <td class="text-moss-600"><c:out value="${empty p.diagnosaUtama ? '-' : p.diagnosaUtama}"/></td>
                    <td><t:risiko nilai="${p.tingkatRisiko}"/></td>
                    <td><t:status nilai="${p.statusRawat}"/></td>
                    <td class="text-moss-600"><c:out value="${empty p.namaBangsal ? '-' : p.namaBangsal}"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty data}"><tr><td colspan="7" class="py-12 text-center text-moss-500">Tidak ada pasien yang masuk pada periode ini.</td></tr></c:if>
            </tbody>
        </table>
    </div>
</section>

<p class="mt-6 hidden text-xs text-moss-500 print:block">Dicetak oleh <c:out value="${sessionScope.userAktif.namaLengkap}"/> dari sistem RS ODGJ.</p>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
