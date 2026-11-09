<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Dashboard"/>
    <jsp:param name="menu" value="dashboard"/>
</jsp:include>
<c:set var="aktif" value="${ringkasan.rawatInap + ringkasan.rawatJalan}"/>

<div class="mb-8 flex flex-wrap items-end justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Selamat datang, <c:out value="${sessionScope.userAktif.namaLengkap}"/></h2>
        <p class="mt-1 text-moss-500">Kondisi rumah sakit hari ini berdasarkan data yang tercatat.</p>
    </div>
    <div class="flex gap-3">
        <a href="${ctx}/admin/laporan" class="btn btn-outline"><i class="fa-solid fa-file-lines"></i>Laporan</a>
        <a href="${ctx}/admin/pasien?aksi=tambah" class="btn btn-primary"><i class="fa-solid fa-user-plus"></i>Daftarkan pasien</a>
    </div>
</div>

<!-- Angka utama -->
<div class="mb-6 grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">
    <div class="card p-5">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Pasien rawat inap</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-bed-pulse"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.rawatInap}</p>
        <p class="mt-1 text-xs text-moss-500">dari ${ringkasan.totalPasien} pasien terdaftar</p>
    </div>
    <div class="card p-5">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Hunian tempat tidur</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-chart-pie"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.persenHunian}%</p>
        <p class="mt-1 text-xs text-moss-500">${ringkasan.terisi} terisi, ${ringkasan.tersedia} tempat tidur tersedia</p>
    </div>
    <div class="card p-5 ${ringkasan.pasienBerisiko > 0 ? 'border-red-200' : ''}">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Perlu pengawasan ketat</p><span class="grid h-10 w-10 place-items-center rounded-lg ${ringkasan.pasienBerisiko > 0 ? 'bg-red-100 text-red-700' : 'bg-brand-100 text-brand-700'}"><i class="fa-solid fa-triangle-exclamation"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold ${ringkasan.pasienBerisiko > 0 ? 'text-red-700' : 'text-moss-900'}">${ringkasan.pasienBerisiko}</p>
        <p class="mt-1 text-xs text-moss-500">pasien berisiko tinggi atau isolasi</p>
    </div>
    <div class="card p-5">
        <div class="flex items-center justify-between"><p class="text-sm font-semibold text-moss-500">Pasien baru bulan ini</p><span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-100 text-brand-700"><i class="fa-solid fa-user-plus"></i></span></div>
        <p class="mt-3 text-3xl font-extrabold text-moss-900">${ringkasan.masukBulanIni}</p>
        <p class="mt-1 text-xs text-moss-500">${ringkasan.catatanHariIni} catatan medis hari ini</p>
    </div>
</div>

<div class="mb-6 grid grid-cols-1 gap-6 xl:grid-cols-3">
    <!-- Peta tempat tidur -->
    <section class="card p-6 xl:col-span-2">
        <div class="mb-5 flex flex-wrap items-start justify-between gap-3">
            <div>
                <h3 class="section-title">Peta tempat tidur</h3>
                <p class="text-sm text-moss-500">Satu kotak mewakili satu tempat tidur.</p>
            </div>
            <div class="flex flex-wrap items-center gap-4 text-xs text-moss-600">
                <span class="flex items-center gap-1.5"><span class="h-3 w-3 rounded bg-brand-600"></span>Terisi</span>
                <span class="flex items-center gap-1.5"><span class="h-3 w-3 rounded bg-orange-500"></span>Terisi (akut)</span>
                <span class="flex items-center gap-1.5"><span class="h-3 w-3 rounded bg-red-600"></span>Terisi (isolasi)</span>
                <span class="flex items-center gap-1.5"><span class="h-3 w-3 rounded bg-moss-200"></span>Kosong</span>
            </div>
        </div>
        <c:choose>
            <c:when test="${empty listBangsal}">
                <p class="rounded-lg bg-moss-50 p-6 text-center text-sm text-moss-500">Belum ada bangsal. <a class="font-semibold text-brand-700 underline" href="${ctx}/admin/bangsal">Tambahkan bangsal</a> untuk mulai memantau hunian.</p>
            </c:when>
            <c:otherwise>
                <div class="space-y-6">
                    <c:forEach var="b" items="${listBangsal}">
                        <c:set var="warna" value="${b.jenis == 'Isolasi' ? 'bg-red-600' : (b.jenis == 'Akut' ? 'bg-orange-500' : 'bg-brand-600')}"/>
                        <div>
                            <div class="mb-2 flex items-baseline justify-between gap-3">
                                <p class="text-sm font-bold text-moss-900"><c:out value="${b.namaBangsal}"/> <span class="ml-1 text-xs font-medium text-moss-500">${b.jenis}</span></p>
                                <p class="text-xs font-semibold text-moss-600">${b.terisi} / ${b.kapasitas} <span class="font-normal text-moss-500">(${b.persen}%)</span></p>
                            </div>
                            <div class="flex flex-wrap gap-1" role="img" aria-label="${b.terisi} dari ${b.kapasitas} tempat tidur terisi">
                                <c:forEach begin="1" end="${b.kapasitas}" var="i">
                                    <span class="h-3.5 w-3.5 rounded-[4px] ${i <= b.terisi ? warna : 'bg-moss-200'}"></span>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- Distribusi risiko -->
    <section class="card p-6">
        <h3 class="section-title">Tingkat risiko pasien aktif</h3>
        <p class="mb-5 text-sm text-moss-500">${aktif} pasien rawat inap dan rawat jalan.</p>
        <div class="space-y-4">
            <c:forEach var="e" items="${ringkasan.risiko}">
                <c:set var="warna" value="${e.key == 'Rendah' ? 'bg-brand-500' : (e.key == 'Sedang' ? 'bg-amber-500' : (e.key == 'Tinggi' ? 'bg-orange-500' : 'bg-red-700'))}"/>
                <div>
                    <div class="mb-1.5 flex justify-between text-sm"><span class="font-semibold text-moss-700">${e.key}</span><span class="font-bold text-moss-900">${e.value}</span></div>
                    <div class="h-2.5 overflow-hidden rounded-full bg-moss-100"><div class="h-full rounded-full ${warna}" style="width: ${aktif == 0 ? 0 : e.value * 100 / aktif}%"></div></div>
                </div>
            </c:forEach>
        </div>

        <div class="mt-8 border-t border-moss-100 pt-6">
            <h3 class="section-title">Pasien masuk, 6 bulan terakhir</h3>
            <div class="mt-4 flex h-36 items-end gap-3">
                <c:forEach var="e" items="${ringkasan.tren}">
                    <div class="flex h-full flex-1 flex-col justify-end text-center">
                        <span class="mb-1 text-xs font-bold text-moss-700">${e.value}</span>
                        <div class="rounded-t-md bg-brand-500" style="height: ${e.value == 0 ? 3 : e.value * 100 / ringkasan.trenMaks}%"></div>
                        <span class="mt-2 text-xs text-moss-500">${e.key}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</div>

<!-- Pasien terbaru -->
<section class="card overflow-hidden">
    <div class="flex items-center justify-between px-6 py-5">
        <div><h3 class="section-title">Pasien terbaru</h3><p class="text-sm text-moss-500">Enam pendaftaran terakhir.</p></div>
        <a href="${ctx}/admin/pasien" class="text-sm font-semibold text-brand-700 hover:underline">Lihat semua pasien</a>
    </div>
    <div class="overflow-x-auto">
        <table class="tbl w-full min-w-[720px]">
            <thead><tr><th>Pasien</th><th>Diagnosa</th><th>Risiko</th><th>Status</th><th>Tanggal masuk</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${pasienTerbaru}">
                <tr class="hover:bg-moss-50">
                    <td><a href="${ctx}/admin/pasien?aksi=detail&id=${p.idPasien}" class="font-semibold text-moss-900 hover:text-brand-700"><c:out value="${p.namaPasien}"/></a><p class="text-xs text-moss-500">${p.noRm}</p></td>
                    <td class="text-moss-600"><c:out value="${empty p.diagnosaUtama ? '-' : p.diagnosaUtama}"/></td>
                    <td><t:risiko nilai="${p.tingkatRisiko}"/></td>
                    <td><t:status nilai="${p.statusRawat}"/></td>
                    <td class="text-moss-600"><fmt:formatDate value="${p.tanggalMasuk}" pattern="dd MMM yyyy"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty pasienTerbaru}">
                <tr><td colspan="5" class="py-10 text-center text-moss-500">Belum ada pasien terdaftar.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
