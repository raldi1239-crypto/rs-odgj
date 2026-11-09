<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="nilai" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${nilai == 'Rendah'}"><c:set var="kelas" value="bg-brand-100 text-brand-800"/><c:set var="titik" value="bg-brand-500"/></c:when>
    <c:when test="${nilai == 'Sedang'}"><c:set var="kelas" value="bg-amber-100 text-amber-800"/><c:set var="titik" value="bg-amber-500"/></c:when>
    <c:when test="${nilai == 'Tinggi'}"><c:set var="kelas" value="bg-orange-100 text-orange-800"/><c:set var="titik" value="bg-orange-500"/></c:when>
    <c:otherwise><c:set var="kelas" value="bg-red-700 text-white"/><c:set var="titik" value="bg-white"/></c:otherwise>
</c:choose>
<span class="inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-semibold ${kelas}"><span class="h-1.5 w-1.5 rounded-full ${titik}"></span>${nilai}</span>
