<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="nilai" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${nilai == 'Membaik'}"><c:set var="kelas" value="bg-brand-100 text-brand-800"/><c:set var="ikon" value="fa-arrow-trend-up"/></c:when>
    <c:when test="${nilai == 'Memburuk'}"><c:set var="kelas" value="bg-red-100 text-red-800"/><c:set var="ikon" value="fa-arrow-trend-down"/></c:when>
    <c:otherwise><c:set var="kelas" value="bg-moss-100 text-moss-700"/><c:set var="ikon" value="fa-minus"/></c:otherwise>
</c:choose>
<span class="inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-semibold ${kelas}"><i class="fa-solid ${ikon} text-[10px]"></i>${nilai}</span>
