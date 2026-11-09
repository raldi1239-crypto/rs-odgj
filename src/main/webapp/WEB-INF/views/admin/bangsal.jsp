<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Bangsal"/>
    <jsp:param name="menu" value="bangsal"/>
</jsp:include>

<div class="mb-6 flex flex-wrap items-end justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Bangsal dan tempat tidur</h2>
        <p class="mt-1 text-moss-500">Atur kapasitas dan pantau hunian setiap bangsal.</p>
    </div>
    <button type="button" class="btn btn-primary" onclick="bukaForm(null)"><i class="fa-solid fa-plus"></i>Tambah bangsal</button>
</div>

<c:choose>
    <c:when test="${empty listBangsal}">
        <div class="card p-14 text-center">
            <span class="mx-auto grid h-12 w-12 place-items-center rounded-full bg-moss-100 text-moss-400"><i class="fa-solid fa-bed-pulse"></i></span>
            <p class="mt-3 font-semibold text-moss-800">Belum ada bangsal</p>
            <p class="mt-1 text-sm text-moss-500">Tambahkan bangsal agar pasien rawat inap dapat ditempatkan.</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="grid gap-5 md:grid-cols-2 xl:grid-cols-3">
            <c:forEach var="b" items="${listBangsal}">
                <c:set var="warna" value="${b.persen >= 90 ? 'bg-red-600' : (b.persen >= 70 ? 'bg-amber-500' : 'bg-brand-500')}"/>
                <article class="card flex flex-col p-5">
                    <div class="flex items-start justify-between gap-3">
                        <div>
                            <h3 class="text-base font-bold text-moss-900"><c:out value="${b.namaBangsal}"/></h3>
                            <p class="mt-0.5 text-xs font-semibold text-moss-500">Bangsal ${b.jenis}</p>
                        </div>
                        <span class="rounded-full px-2.5 py-1 text-xs font-bold ${b.tersedia == 0 ? 'bg-red-100 text-red-800' : 'bg-brand-100 text-brand-800'}"><c:choose><c:when test="${b.tersedia == 0}">Penuh</c:when><c:otherwise>${b.tersedia} kosong</c:otherwise></c:choose></span>
                    </div>
                    <p class="mt-3 min-h-[2.5rem] text-sm text-moss-600"><c:out value="${empty b.keterangan ? 'Tanpa keterangan.' : b.keterangan}"/></p>
                    <div class="mt-4">
                        <div class="mb-1.5 flex justify-between text-sm"><span class="font-semibold text-moss-700">Terisi</span><span class="font-bold text-moss-900">${b.terisi} / ${b.kapasitas}</span></div>
                        <div class="h-2.5 overflow-hidden rounded-full bg-moss-100"><div class="h-full rounded-full ${warna}" style="width: ${b.persen}%"></div></div>
                    </div>
                    <div class="mt-5 flex gap-2 border-t border-moss-100 pt-4">
                        <button type="button" class="btn btn-outline btn-sm flex-1" onclick="bukaForm(this)"
                                data-id="${b.idBangsal}" data-nama="<c:out value='${b.namaBangsal}'/>" data-jenis="${b.jenis}" data-kapasitas="${b.kapasitas}" data-ket="<c:out value='${b.keterangan}'/>"><i class="fa-solid fa-pen"></i>Ubah</button>
                        <button type="button" class="btn btn-danger btn-sm" onclick="konfirmasiHapus(this)" data-id="${b.idBangsal}" data-nama="<c:out value='${b.namaBangsal}'/>" title="Hapus bangsal"><i class="fa-solid fa-trash"></i></button>
                    </div>
                </article>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<dialog id="dlgForm" class="w-full max-w-lg">
    <form method="post" action="${ctx}/admin/bangsal" class="p-6">
        <t:csrf/>
        <input type="hidden" name="aksi" value="simpan">
        <input type="hidden" name="id" id="fId" value="0">
        <h3 id="fJudul" class="text-lg font-extrabold text-moss-900">Tambah bangsal</h3>
        <div class="mt-5 space-y-4">
            <div><label class="label" for="fNama">Nama bangsal</label><input id="fNama" name="namaBangsal" class="input" required minlength="3" maxlength="60"></div>
            <div class="grid grid-cols-2 gap-4">
                <div><label class="label" for="fJenis">Jenis</label>
                    <select id="fJenis" name="jenis" class="input"><option>Tenang</option><option>Intermediate</option><option>Akut</option><option>Isolasi</option></select></div>
                <div><label class="label" for="fKap">Kapasitas</label><input id="fKap" name="kapasitas" type="number" min="1" max="500" class="input" required></div>
            </div>
            <div><label class="label" for="fKet">Keterangan</label><input id="fKet" name="keterangan" class="input" maxlength="200" placeholder="Fungsi atau kekhususan bangsal"></div>
        </div>
        <div class="mt-6 flex justify-end gap-3">
            <button type="button" class="btn btn-outline" onclick="document.getElementById('dlgForm').close()">Batal</button>
            <button type="submit" class="btn btn-primary">Simpan</button>
        </div>
    </form>
</dialog>

<dialog id="dlgHapus" class="w-full max-w-md">
    <form method="post" action="${ctx}/admin/bangsal" class="p-6">
        <t:csrf/>
        <input type="hidden" name="aksi" value="hapus">
        <input type="hidden" name="id" id="hId">
        <span class="grid h-12 w-12 place-items-center rounded-full bg-red-100 text-red-700"><i class="fa-solid fa-trash"></i></span>
        <h3 class="mt-4 text-lg font-extrabold text-moss-900">Hapus bangsal?</h3>
        <p class="mt-2 text-sm text-moss-600"><strong id="hNama"></strong> akan dihapus. Bangsal yang masih dihuni pasien tidak dapat dihapus.</p>
        <div class="mt-6 flex justify-end gap-3">
            <button type="button" class="btn btn-outline" onclick="document.getElementById('dlgHapus').close()">Batal</button>
            <button type="submit" class="btn bg-red-600 text-white hover:bg-red-700">Ya, hapus</button>
        </div>
    </form>
</dialog>

<script>
    function bukaForm(btn) {
        var d = btn ? btn.dataset : { id: '0', nama: '', jenis: 'Tenang', kapasitas: '', ket: '' };
        document.getElementById('fJudul').textContent = btn ? 'Ubah bangsal' : 'Tambah bangsal';
        document.getElementById('fId').value = d.id;
        document.getElementById('fNama').value = d.nama;
        document.getElementById('fJenis').value = d.jenis;
        document.getElementById('fKap').value = d.kapasitas;
        document.getElementById('fKet').value = d.ket || '';
        document.getElementById('dlgForm').showModal();
    }
    function konfirmasiHapus(btn) {
        document.getElementById('hId').value = btn.dataset.id;
        document.getElementById('hNama').textContent = btn.dataset.nama;
        document.getElementById('dlgHapus').showModal();
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
