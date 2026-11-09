<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="nilai" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${nilai == 'Rawat Inap'}"><c:set var="kelas" value="bg-emerald-50 text-emerald-800 ring-emerald-200"/></c:when>
    <c:when test="${nilai == 'Rawat Jalan'}"><c:set var="kelas" value="bg-sky-50 text-sky-800 ring-sky-200"/></c:when>
    <c:otherwise><c:set var="kelas" value="bg-moss-100 text-moss-600 ring-moss-200"/></c:otherwise>
</c:choose>
<span class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-semibold ring-1 ring-inset ${kelas}">${nilai}</span>
