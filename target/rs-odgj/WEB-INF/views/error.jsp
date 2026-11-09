<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="kode" value="${requestScope['javax.servlet.error.status_code']}"/>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Terjadi kendala - RS ODGJ</title>
    <link rel="icon" href="${ctx}/assets/logo.svg" type="image/svg+xml">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: {
            fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
            colors: { brand: { 50:'#F1F8F4', 100:'#DDF0E4', 600:'#1F7549', 700:'#195E3B', 900:'#0F3A25' }, moss: { 50:'#F5F8F6', 500:'#6B7F73', 900:'#1B241F' } } } } }
    </script>
</head>
<body class="grid min-h-screen place-items-center bg-moss-50 px-6 font-sans text-moss-900 antialiased">
    <div class="w-full max-w-md text-center">
        <img src="${ctx}/assets/logo.svg" alt="" class="mx-auto h-14 w-14">
        <p class="mt-8 text-6xl font-extrabold tracking-tight text-brand-600"><c:out value="${empty kode ? 'Oops' : kode}"/></p>
        <h1 class="mt-3 text-2xl font-extrabold">
            <c:choose>
                <c:when test="${kode == 404}">Halaman tidak ditemukan</c:when>
                <c:when test="${kode == 403}">Akses ditolak</c:when>
                <c:otherwise>Terjadi kesalahan pada sistem</c:otherwise>
            </c:choose>
        </h1>
        <p class="mt-3 text-moss-500">
            <c:choose>
                <c:when test="${kode == 404}">Alamat yang Anda buka tidak tersedia atau sudah dipindahkan.</c:when>
                <c:when test="${kode == 403}">Anda tidak memiliki izin untuk membuka halaman ini, atau token keamanan sudah kedaluwarsa. Muat ulang halaman lalu coba lagi.</c:when>
                <c:otherwise>Kami tidak dapat memproses permintaan ini. Periksa koneksi database, lalu coba lagi.</c:otherwise>
            </c:choose>
        </p>
        <div class="mt-8 flex justify-center gap-3">
            <a href="javascript:history.back()" class="rounded-lg border border-moss-500/30 bg-white px-5 py-2.5 text-sm font-semibold hover:bg-brand-50">Kembali</a>
            <a href="${ctx}/index.jsp" class="rounded-lg bg-brand-600 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-700">Ke beranda</a>
        </div>
    </div>
</body>
</html>
