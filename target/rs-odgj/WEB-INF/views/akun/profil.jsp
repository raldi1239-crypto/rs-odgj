<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Akun saya"/>
    <jsp:param name="menu" value="akun"/>
</jsp:include>
<c:set var="u" value="${sessionScope.userAktif}"/>

<div class="mb-6">
    <h2 class="text-2xl font-extrabold tracking-tight text-moss-900">Akun saya</h2>
    <p class="mt-1 text-moss-500">Perbarui nama dan ganti password Anda.</p>
</div>

<div class="grid gap-6 lg:grid-cols-2">
    <section class="card p-6">
        <div class="mb-6 flex items-center gap-4">
            <span class="grid h-14 w-14 place-items-center rounded-full bg-brand-600 text-xl font-bold text-white">${u.inisial}</span>
            <div><p class="text-lg font-bold text-moss-900"><c:out value="${u.namaLengkap}"/></p><p class="text-sm text-moss-500">${u.role} &middot; @<c:out value="${u.username}"/></p></div>
        </div>
        <form method="post" action="${ctx}/akun" class="space-y-4">
            <t:csrf/>
            <input type="hidden" name="aksi" value="nama">
            <div><label class="label" for="nm">Nama lengkap</label><input id="nm" name="namaLengkap" class="input" required minlength="3" maxlength="100" value="<c:out value='${u.namaLengkap}'/>"></div>
            <div><label class="label" for="un">Username</label><input id="un" class="input" value="<c:out value='${u.username}'/>" disabled><p class="hint">Username tidak dapat diubah. Hubungi administrator jika perlu.</p></div>
            <div class="flex justify-end"><button type="submit" class="btn btn-primary">Simpan nama</button></div>
        </form>
    </section>

    <section class="card p-6">
        <h3 class="section-title">Ganti password</h3>
        <form method="post" action="${ctx}/akun" class="mt-5 space-y-4" autocomplete="off">
            <t:csrf/>
            <input type="hidden" name="aksi" value="sandi">
            <div><label class="label" for="pl">Password saat ini</label><input id="pl" name="lama" type="password" class="input" required autocomplete="current-password"></div>
            <div><label class="label" for="pb">Password baru</label><input id="pb" name="baru" type="password" class="input" required minlength="6" autocomplete="new-password"><p class="hint">Minimal 6 karakter.</p></div>
            <div><label class="label" for="pu">Ulangi password baru</label><input id="pu" name="ulang" type="password" class="input" required minlength="6" autocomplete="new-password"></div>
            <div class="flex justify-end"><button type="submit" class="btn btn-primary"><i class="fa-solid fa-key"></i>Ganti password</button></div>
        </form>
    </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
