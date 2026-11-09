<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Dashboard"/>
    <jsp:param name="menu" value="dashboard"/>
</jsp:include>

<div class="mb-8 flex flex-wrap items-end justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Selamat bertugas, <c:out value="${sessionScope.userAktif.namaLengkap}"/></h2>
        <p class="mt-1 text-moss-500">Pasien yang membutuhkan perhatian Anda ditampilkan paling atas.</p>
    </div>
    <a href="${ctx}/klinis/pasien" class="btn btn-primary"><i class="fa-solid fa-notes-medical"></i>Buka daftar pasien</a>
</div>

<div class="mb-6 grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">
    <div class="card p-5">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Pasien rawat inap</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-bed-pulse"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.rawatInap}</p>
        <p class="mt-1 text-xs text-moss-500">${ringkasan.rawatJalan} pasien rawat jalan</p>
    </div>
    <div class="card p-5 ${ringkasan.pasienBerisiko > 0 ? 'border-red-200' : ''}">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Perlu pengawasan ketat</p><span class="grid h-10 w-10 place-items-center rounded-lg ${ringkasan.pasienBerisiko > 0 ? 'bg-red-100 text-red-700' : 'bg-brand-100 text-brand-700'}"><i class="fa-solid fa-triangle-exclamation"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold ${ringkasan.pasienBerisiko > 0 ? 'text-red-700' : 'text-moss-900'}">${ringkasan.pasienBerisiko}</p>
        <p class="mt-1 text-xs text-moss-500">risiko tinggi atau isolasi</p>
    </div>
    <div class="card p-5">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Catatan medis hari ini</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-clipboard-check"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.catatanHariIni}</p>
        <p class="mt-1 text-xs text-moss-500">dicatat oleh seluruh tim</p>
    </div>
    <c:choose>
        <c:when test="${ditangani >= 0}">
            <div class="card p-5">
                <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Pasien Anda</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-user-doctor"></i></span></div>
                <p class="mt-3 text-3xl font-extrabold text-moss-900">${ditangani}</p>
                <p class="mt-1 text-xs text-moss-500">sedang Anda tangani</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card p-5">
                <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Tempat tidur kosong</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-bed"></i></span></div>
                <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.tersedia}</p>
                <p class="mt-1 text-xs text-moss-500">hunian ${ringkasan.persenHunian}%</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div class="grid gap-6 xl:grid-cols-5">
    <section class="card overflow-hidden xl:col-span-3">
        <div class="flex items-center justify-between px-6 py-5">
            <div><h3 class="section-title">Pasien rawat inap prioritas</h3><p class="text-sm text-moss-500">Diurutkan dari risiko tertinggi.</p></div>
            <a href="${ctx}/klinis/pasien" class="text-sm font-semibold text-brand-700 hover:underline">Semua pasien</a>
        </div>
        <ul class="divide-y divide-moss-100">
            <c:forEach var="p" items="${prioritas}">
                <li>
                    <a href="${ctx}/klinis/pasien?id=${p.idPasien}" class="flex items-center justify-between gap-4 px-6 py-4 transition-colors hover:bg-moss-50">
                        <div class="min-w-0">
                            <p class="truncate font-semibold text-moss-900"><c:out value="${p.namaPasien}"/></p>
                            <p class="truncate text-xs text-moss-500">${p.noRm} &middot; <c:out value="${empty p.diagnosaUtama ? 'Belum ada diagnosa' : p.diagnosaUtama}"/><c:if test="${not empty p.namaBangsal}"> &middot; <c:out value="${p.namaBangsal}"/></c:if></p>
                        </div>
                        <div class="flex shrink-0 items-center gap-3"><t:risiko nilai="${p.tingkatRisiko}"/><i class="fa-solid fa-chevron-right text-xs text-moss-400"></i></div>
                    </a>
                </li>
            </c:forEach>
            <c:if test="${empty prioritas}"><li class="px-6 py-12 text-center text-sm text-moss-500">Tidak ada pasien rawat inap saat ini.</li></c:if>
        </ul>
    </section>

    <section class="card p-6 xl:col-span-2">
        <h3 class="section-title">Catatan medis terbaru</h3>
        <p class="mb-5 text-sm text-moss-500">Aktivitas terakhir dari tim klinis.</p>
        <ol class="space-y-5">
            <c:forEach var="r" items="${catatanTerbaru}">
                <li class="flex gap-3">
                    <span class="mt-1 grid h-8 w-8 shrink-0 place-items-center rounded-full ${r.kondisi == 'Memburuk' ? 'bg-red-100 text-red-700' : (r.kondisi == 'Membaik' ? 'bg-brand-100 text-brand-700' : 'bg-moss-100 text-moss-600')}"><i class="fa-solid ${r.kondisi == 'Memburuk' ? 'fa-arrow-trend-down' : (r.kondisi == 'Membaik' ? 'fa-arrow-trend-up' : 'fa-minus')} text-xs"></i></span>
                    <div class="min-w-0 text-sm">
                        <p class="font-semibold text-moss-900"><a class="hover:text-brand-700" href="${ctx}/klinis/pasien?id=${r.idPasien}"><c:out value="${r.namaPasien}"/></a> <span class="font-normal text-moss-500">kondisi ${r.kondisi}</span></p>
                        <p class="truncate text-moss-600"><c:out value="${empty r.observasi ? r.keluhan : r.observasi}"/></p>
                        <p class="text-xs text-moss-500"><fmt:formatDate value="${r.waktuCatat}" pattern="dd MMM, HH:mm"/> &middot; <c:out value="${r.namaPetugas}"/></p>
                    </div>
                </li>
            </c:forEach>
            <c:if test="${empty catatanTerbaru}"><li class="text-sm text-moss-500">Belum ada catatan medis.</li></c:if>
        </ol>
    </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
