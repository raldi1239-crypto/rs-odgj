<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="id_ID" scope="request"/>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<c:set var="menu" value="${param.menu}"/>
<c:set var="me" value="${sessionScope.userAktif}"/>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${param.title}"/> - RS ODGJ</title>
    <link rel="icon" href="${ctx}/assets/logo.svg" type="image/svg+xml">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: {
                fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
                colors: {
                    brand: { 50:'#F1F8F4', 100:'#DDF0E4', 200:'#BBE0C9', 300:'#8DC9A5', 400:'#55AB7B', 500:'#2F9060', 600:'#1F7549', 700:'#195E3B', 800:'#154B30', 900:'#0F3A25', 950:'#08261A' },
                    moss:  { 50:'#F5F8F6', 100:'#EAF0EC', 200:'#DCE5DF', 300:'#C3D0C8', 400:'#93A59B', 500:'#6B7F73', 600:'#51635A', 700:'#3D4C44', 800:'#2A352F', 900:'#1B241F' }
                }
            } }
        }
    </script>
    <style type="text/tailwindcss">
        @layer base {
            body { @apply bg-moss-50 text-moss-800 antialiased; }
            :focus-visible { @apply outline-none ring-2 ring-brand-500 ring-offset-2; }
        }
        @layer components {
            .card { @apply rounded-xl border border-moss-200 bg-white; }
            .btn { @apply inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2.5 text-sm font-semibold transition-colors; }
            .btn-primary { @apply bg-brand-600 text-white hover:bg-brand-700; }
            .btn-outline { @apply border border-moss-300 bg-white text-moss-800 hover:bg-moss-50; }
            .btn-danger { @apply border border-red-200 bg-white text-red-700 hover:bg-red-50; }
            .btn-sm { @apply px-3 py-1.5 text-xs; }
            .input { @apply w-full rounded-lg border border-moss-300 bg-white px-3.5 py-2.5 text-sm text-moss-900 placeholder-moss-400 transition focus:border-brand-500 focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:ring-offset-0 disabled:bg-moss-100 disabled:text-moss-500; }
            .label { @apply mb-1.5 block text-sm font-semibold text-moss-700; }
            .hint { @apply mt-1 text-xs text-moss-500; }
            .tbl th { @apply bg-moss-50 px-5 py-3 text-left text-xs font-semibold text-moss-500; }
            .tbl td { @apply px-5 py-4 align-middle text-sm; }
            .tbl tbody tr { @apply border-t border-moss-100; }
            .nav-item { @apply flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-brand-200 transition-colors hover:bg-white/5 hover:text-white; }
            .nav-active { @apply bg-white/10 text-white; }
            .section-title { @apply text-base font-bold text-moss-900; }
        }
        dialog { @apply rounded-2xl border-0 p-0 shadow-2xl; }
        dialog::backdrop { background: rgba(8, 38, 26, .55); }
        @media print { body { display: block !important; height: auto !important; overflow: visible !important; background: #fff !important; } main { overflow: visible !important; } }
        @media (prefers-reduced-motion: reduce) { * { transition: none !important; animation: none !important; } }
    </style>
</head>
<body class="flex h-screen overflow-hidden font-sans">

<div id="overlay" class="fixed inset-0 z-30 hidden bg-brand-950/50 lg:hidden print:hidden"></div>

<aside id="sidebar" class="fixed inset-y-0 left-0 z-40 flex w-64 -translate-x-full flex-col bg-brand-950 text-brand-100 transition-transform lg:static lg:translate-x-0 print:hidden">
    <div class="flex h-16 items-center gap-3 px-5">
        <img src="${ctx}/assets/logo.svg" alt="" class="h-9 w-9">
        <div class="leading-tight">
            <p class="text-base font-extrabold tracking-tight text-white">RS ODGJ</p>
            <p class="text-[11px] text-brand-300">Sistem Informasi Rumah Sakit</p>
        </div>
    </div>

    <nav class="flex-1 space-y-1 overflow-y-auto px-3 py-4" aria-label="Menu utama">
        <c:choose>
            <c:when test="${me.admin}">
                <a href="${ctx}/admin/dashboard" class="nav-item ${menu == 'dashboard' ? 'nav-active' : ''}"><i class="fa-solid fa-gauge-high w-5 text-center"></i>Dashboard</a>
                <a href="${ctx}/admin/pasien" class="nav-item ${menu == 'pasien' ? 'nav-active' : ''}"><i class="fa-solid fa-hospital-user w-5 text-center"></i>Data pasien</a>
                <a href="${ctx}/admin/bangsal" class="nav-item ${menu == 'bangsal' ? 'nav-active' : ''}"><i class="fa-solid fa-bed-pulse w-5 text-center"></i>Bangsal</a>
                <a href="${ctx}/admin/laporan" class="nav-item ${menu == 'laporan' ? 'nav-active' : ''}"><i class="fa-solid fa-file-lines w-5 text-center"></i>Laporan</a>
                <a href="${ctx}/admin/pengguna" class="nav-item ${menu == 'pengguna' ? 'nav-active' : ''}"><i class="fa-solid fa-users-gear w-5 text-center"></i>Pengguna</a>
            </c:when>
            <c:otherwise>
                <a href="${ctx}/klinis/dashboard" class="nav-item ${menu == 'dashboard' ? 'nav-active' : ''}"><i class="fa-solid fa-gauge-high w-5 text-center"></i>Dashboard</a>
                <a href="${ctx}/klinis/pasien" class="nav-item ${menu == 'pasien' ? 'nav-active' : ''}"><i class="fa-solid fa-notes-medical w-5 text-center"></i>Pasien dan rekam medis</a>
            </c:otherwise>
        </c:choose>
        <div class="my-3 border-t border-white/10"></div>
        <a href="${ctx}/akun" class="nav-item ${menu == 'akun' ? 'nav-active' : ''}"><i class="fa-solid fa-circle-user w-5 text-center"></i>Akun saya</a>
    </nav>

    <div class="border-t border-white/10 p-4">
        <div class="mb-3 flex items-center gap-3">
            <div class="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-brand-600 text-sm font-bold text-white">${me.inisial}</div>
            <div class="min-w-0 leading-tight">
                <p class="truncate text-sm font-semibold text-white"><c:out value="${me.namaLengkap}"/></p>
                <p class="text-xs text-brand-300">${me.role}</p>
            </div>
        </div>
        <a href="${ctx}/logout" class="flex w-full items-center justify-center gap-2 rounded-lg border border-white/15 px-3 py-2 text-sm font-semibold text-brand-100 transition-colors hover:bg-white/10"><i class="fa-solid fa-right-from-bracket"></i>Keluar</a>
    </div>
</aside>

<div class="flex min-w-0 flex-1 flex-col">
    <header class="flex h-16 shrink-0 items-center justify-between border-b border-moss-200 bg-white px-5 sm:px-8 print:hidden">
        <div class="flex items-center gap-3">
            <button id="btnMenu" type="button" class="grid h-10 w-10 place-items-center rounded-lg text-moss-600 hover:bg-moss-100 lg:hidden" aria-label="Buka menu"><i class="fa-solid fa-bars"></i></button>
            <h1 class="text-lg font-bold text-moss-900"><c:out value="${param.title}"/></h1>
        </div>
        <p id="tanggalHariIni" class="hidden text-sm text-moss-500 sm:block"></p>
    </header>

    <main class="flex-1 overflow-y-auto p-5 sm:p-8 print:overflow-visible print:p-0">
    <div class="mx-auto max-w-7xl">
        <c:if test="${not empty flashJenis}">
            <div id="flash" role="status" class="mb-6 flex items-start gap-3 rounded-xl border px-4 py-3 text-sm print:hidden ${flashJenis == 'sukses' ? 'border-brand-200 bg-brand-50 text-brand-900' : 'border-red-200 bg-red-50 text-red-900'}">
                <i class="fa-solid ${flashJenis == 'sukses' ? 'fa-circle-check text-brand-600' : 'fa-circle-exclamation text-red-600'} mt-0.5"></i>
                <p class="flex-1 font-medium"><c:out value="${flashPesan}"/></p>
                <button type="button" onclick="this.parentElement.remove()" class="text-moss-500 hover:text-moss-800" aria-label="Tutup pesan"><i class="fa-solid fa-xmark"></i></button>
            </div>
        </c:if>
