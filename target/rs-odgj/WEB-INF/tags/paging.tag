<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="base" required="true" type="java.lang.String" %>
<%@ attribute name="halaman" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalHalaman" required="true" type="java.lang.Integer" %>
<%@ attribute name="q" type="java.lang.String" %>
<%@ attribute name="risiko" type="java.lang.String" %>
<%@ attribute name="status" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${totalHalaman > 1}">
    <c:set var="awal" value="${halaman - 2 < 1 ? 1 : halaman - 2}"/>
    <c:set var="akhir" value="${awal + 4 > totalHalaman ? totalHalaman : awal + 4}"/>
    <c:set var="awal" value="${akhir - 4 < 1 ? 1 : akhir - 4}"/>
    <nav class="flex items-center gap-1" aria-label="Halaman">
        <c:if test="${halaman > 1}">
            <c:url var="u" value="${base}"><c:param name="hal" value="${halaman - 1}"/><c:param name="q" value="${q}"/><c:param name="risiko" value="${risiko}"/><c:param name="status" value="${status}"/></c:url>
            <a href="${u}" class="grid h-9 w-9 place-items-center rounded-lg border border-moss-200 bg-white text-moss-600 hover:bg-moss-50" aria-label="Sebelumnya"><i class="fa-solid fa-chevron-left text-xs"></i></a>
        </c:if>
        <c:forEach begin="${awal}" end="${akhir}" var="i">
            <c:url var="u" value="${base}"><c:param name="hal" value="${i}"/><c:param name="q" value="${q}"/><c:param name="risiko" value="${risiko}"/><c:param name="status" value="${status}"/></c:url>
            <a href="${u}" class="grid h-9 min-w-[2.25rem] place-items-center rounded-lg border px-2 text-sm font-semibold ${i == halaman ? 'border-brand-600 bg-brand-600 text-white' : 'border-moss-200 bg-white text-moss-700 hover:bg-moss-50'}" ${i == halaman ? 'aria-current="page"' : ''}>${i}</a>
        </c:forEach>
        <c:if test="${halaman < totalHalaman}">
            <c:url var="u" value="${base}"><c:param name="hal" value="${halaman + 1}"/><c:param name="q" value="${q}"/><c:param name="risiko" value="${risiko}"/><c:param name="status" value="${status}"/></c:url>
            <a href="${u}" class="grid h-9 w-9 place-items-center rounded-lg border border-moss-200 bg-white text-moss-600 hover:bg-moss-50" aria-label="Berikutnya"><i class="fa-solid fa-chevron-right text-xs"></i></a>
        </c:if>
    </nav>
</c:if>
