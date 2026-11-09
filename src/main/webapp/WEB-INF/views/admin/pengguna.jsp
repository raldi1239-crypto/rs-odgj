<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Pengguna"/>
    <jsp:param name="menu" value="pengguna"/>
</jsp:include>

<div class="mb-6 flex flex-wrap items-end justify-between gap-4">
    <div>
        <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Manajemen pengguna</h2>
        <p class="mt-1 text-moss-500">Kelola akun admin, dokter, dan perawat yang dapat masuk ke sistem.</p>
    </div>
    <button type="button" class="btn btn-primary" onclick="document.getElementById('dlgTambah').showModal()"><i class="fa-solid fa-user-plus"></i>Tambah pengguna</button>
</div>

<section class="card overflow-hidden">
    <div class="overflow-x-auto">
        <table class="tbl w-full min-w-[760px]">
            <thead><tr><th>Pengguna</th><th>Peran</th><th>Status</th><th>Dibuat</th><th class="text-right">Aksi</th></tr></thead>
            <tbody>
            <c:forEach var="u" items="${listUser}">
                <tr class="hover:bg-moss-50">
                    <td>
                        <div class="flex items-center gap-3">
                            <span class="grid h-9 w-9 place-items-center rounded-full bg-brand-100 text-sm font-bold text-brand-800">${u.inisial}</span>
                            <div><p class="font-semibold text-moss-900"><c:out value="${u.namaLengkap}"/></p><p class="text-xs text-moss-500">@<c:out value="${u.username}"/></p></div>
                        </div>
                    </td>
                    <td><span class="rounded-full px-2.5 py-1 text-xs font-semibold ${u.role == 'Admin' ? 'bg-moss-800 text-white' : (u.role == 'Dokter' ? 'bg-brand-100 text-brand-800' : 'bg-sky-100 text-sky-800')}">${u.role}</span></td>
                    <td><span class="inline-flex items-center gap-1.5 text-sm font-semibold ${u.statusAktif ? 'text-brand-700' : 'text-moss-500'}"><span class="h-2 w-2 rounded-full ${u.statusAktif ? 'bg-brand-500' : 'bg-moss-400'}"></span>${u.statusAktif ? 'Aktif' : 'Nonaktif'}</span></td>
                    <td class="text-moss-600"><fmt:formatDate value="${u.dibuatPada}" pattern="dd MMM yyyy"/></td>
                    <td>
                        <div class="flex justify-end gap-2">
                            <button type="button" class="btn btn-outline btn-sm" onclick="resetSandi(this)" data-id="${u.idUser}" data-nama="<c:out value='${u.namaLengkap}'/>"><i class="fa-solid fa-key"></i>Reset password</button>
                            <c:if test="${u.idUser != sessionScope.userAktif.idUser}">
                                <form method="post" action="${ctx}/admin/pengguna" class="inline">
                                    <t:csrf/>
                                    <input type="hidden" name="aksi" value="status">
                                    <input type="hidden" name="id" value="${u.idUser}">
                                    <input type="hidden" name="aktif" value="${u.statusAktif ? '0' : '1'}">
                                    <button type="submit" class="btn btn-sm ${u.statusAktif ? 'btn-danger' : 'btn-outline'}">${u.statusAktif ? 'Nonaktifkan' : 'Aktifkan'}</button>
                                </form>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</section>

<dialog id="dlgTambah" class="w-full max-w-lg">
    <form method="post" action="${ctx}/admin/pengguna" class="p-6" autocomplete="off">
        <t:csrf/>
        <input type="hidden" name="aksi" value="tambah">
        <h3 class="text-lg font-extrabold text-moss-900">Tambah pengguna</h3>
        <div class="mt-5 space-y-4">
            <div><label class="label" for="nNama">Nama lengkap</label><input id="nNama" name="namaLengkap" class="input" required minlength="3" maxlength="100" placeholder="Contoh: dr. Budi Santoso, Sp.KJ"></div>
            <div class="grid grid-cols-2 gap-4">
                <div><label class="label" for="nUser">Username</label><input id="nUser" name="username" class="input" required pattern="[A-Za-z0-9_.]{3,30}" placeholder="budi.santoso"></div>
                <div><label class="label" for="nRole">Peran</label>
                    <select id="nRole" name="role" class="input"><option>Dokter</option><option>Perawat</option><option>Admin</option></select></div>
            </div>
            <div><label class="label" for="nSandi">Password awal</label><input id="nSandi" name="password" type="password" class="input" required minlength="6" autocomplete="new-password"><p class="hint">Minimal 6 karakter. Pengguna dapat menggantinya di menu Akun saya.</p></div>
        </div>
        <div class="mt-6 flex justify-end gap-3">
            <button type="button" class="btn btn-outline" onclick="document.getElementById('dlgTambah').close()">Batal</button>
            <button type="submit" class="btn btn-primary">Buat akun</button>
        </div>
    </form>
</dialog>

<dialog id="dlgReset" class="w-full max-w-md">
    <form method="post" action="${ctx}/admin/pengguna" class="p-6" autocomplete="off">
        <t:csrf/>
        <input type="hidden" name="aksi" value="reset">
        <input type="hidden" name="id" id="rId">
        <h3 class="text-lg font-extrabold text-moss-900">Reset password</h3>
        <p class="mt-1 text-sm text-moss-600">Atur password baru untuk <strong id="rNama"></strong>.</p>
        <div class="mt-5"><label class="label" for="rSandi">Password baru</label><input id="rSandi" name="password" type="password" class="input" required minlength="6" autocomplete="new-password"></div>
        <div class="mt-6 flex justify-end gap-3">
            <button type="button" class="btn btn-outline" onclick="document.getElementById('dlgReset').close()">Batal</button>
            <button type="submit" class="btn btn-primary">Simpan password</button>
        </div>
    </form>
</dialog>
<script>
    function resetSandi(btn) {
        document.getElementById('rId').value = btn.dataset.id;
        document.getElementById('rNama').textContent = btn.dataset.nama;
        document.getElementById('rSandi').value = '';
        document.getElementById('dlgReset').showModal();
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
