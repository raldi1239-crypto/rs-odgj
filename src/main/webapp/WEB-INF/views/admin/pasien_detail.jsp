<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="Detail pasien"/>
    <jsp:param name="menu" value="pasien"/>
</jsp:include>

<a href="${ctx}/admin/pasien" class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-moss-600 hover:text-brand-700"><i class="fa-solid fa-arrow-left text-xs"></i>Kembali ke daftar pasien</a>

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
    <a href="${ctx}/admin/pasien?aksi=ubah&id=${pasien.idPasien}" class="btn btn-primary"><i class="fa-solid fa-pen"></i>Ubah data</a>
</div>

<div class="grid gap-6 lg:grid-cols-[340px_1fr]">
    <div><jsp:include page="/WEB-INF/views/layout/_identitas.jsp"/></div>
    <div><jsp:include page="/WEB-INF/views/layout/_riwayat.jsp"/></div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
