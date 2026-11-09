<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty sessionScope.userAktif}">
    <c:redirect url="${sessionScope.userAktif.admin ? '/admin/dashboard' : '/klinis/dashboard'}"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Masuk - RS ODGJ</title>
    <link rel="icon" href="${ctx}/assets/logo.svg" type="image/svg+xml">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: {
            fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
            colors: {
                brand: { 50:'#F1F8F4', 100:'#DDF0E4', 200:'#BBE0C9', 300:'#8DC9A5', 400:'#55AB7B', 500:'#2F9060', 600:'#1F7549', 700:'#195E3B', 800:'#154B30', 900:'#0F3A25', 950:'#08261A' },
                moss:  { 50:'#F5F8F6', 100:'#EAF0EC', 200:'#DCE5DF', 300:'#C3D0C8', 400:'#93A59B', 500:'#6B7F73', 600:'#51635A', 700:'#3D4C44', 800:'#2A352F', 900:'#1B241F' }
            } } } }
    </script>
    <style type="text/tailwindcss">
        @layer base { :focus-visible { @apply outline-none ring-2 ring-brand-500 ring-offset-2; } }
        @media (prefers-reduced-motion: reduce) { * { transition: none !important; animation: none !important; } }
    </style>
</head>
<body class="min-h-screen bg-white font-sans text-moss-800 antialiased">
<div class="flex min-h-screen">

    <!-- Panel kiri -->
    <section class="relative hidden w-[46%] flex-col justify-between overflow-hidden bg-brand-950 p-12 text-brand-100 lg:flex">
        <svg class="pointer-events-none absolute -bottom-40 -right-40 h-[640px] w-[640px] text-brand-700/40" viewBox="0 0 200 200" fill="none" stroke="currentColor" aria-hidden="true">
            <circle cx="100" cy="100" r="95" stroke-width="1"/><circle cx="100" cy="100" r="75" stroke-width="1"/>
            <circle cx="100" cy="100" r="55" stroke-width="1"/><circle cx="100" cy="100" r="35" stroke-width="1"/><circle cx="100" cy="100" r="15" stroke-width="1"/>
        </svg>

        <div class="relative flex items-center gap-3">
            <img src="${ctx}/assets/logo.svg" alt="" class="h-11 w-11">
            <div class="leading-tight">
                <p class="text-xl font-extrabold tracking-tight text-white">RS ODGJ</p>
                <p class="text-xs text-brand-300">Rumah Sakit Orang Dengan Gangguan Jiwa</p>
            </div>
        </div>

        <div class="relative max-w-md">
            <h2 class="text-4xl font-extrabold leading-tight tracking-tight text-white">Perawatan jiwa yang tertata dan terpantau.</h2>
            <p class="mt-5 text-base leading-relaxed text-brand-200">Satu sistem untuk pendaftaran pasien, pemantauan hunian bangsal, dan rekam medis harian oleh tim klinis.</p>
            <ul class="mt-10 space-y-5 text-sm">
                <li class="flex items-start gap-4">
                    <span class="grid h-10 w-10 shrink-0 place-items-center rounded-lg bg-white/10 text-brand-300"><i class="fa-solid fa-notes-medical"></i></span>
                    <span><strong class="block text-white">Rekam medis terpusat</strong>Keluhan, observasi, tanda vital, dan terapi tercatat per kunjungan.</span>
                </li>
                <li class="flex items-start gap-4">
                    <span class="grid h-10 w-10 shrink-0 place-items-center rounded-lg bg-white/10 text-brand-300"><i class="fa-solid fa-bed-pulse"></i></span>
                    <span><strong class="block text-white">Hunian bangsal real-time</strong>Ketersediaan tempat tidur dan tingkat risiko pasien terlihat sekilas.</span>
                </li>
                <li class="flex items-start gap-4">
                    <span class="grid h-10 w-10 shrink-0 place-items-center rounded-lg bg-white/10 text-brand-300"><i class="fa-solid fa-user-shield"></i></span>
                    <span><strong class="block text-white">Akses sesuai peran</strong>Admin, dokter, dan perawat hanya melihat yang menjadi tugasnya.</span>
                </li>
            </ul>
        </div>

        <p class="relative text-xs text-brand-400">&copy; <%= java.time.Year.now() %> RS ODGJ. Data pasien bersifat rahasia.</p>
    </section>

    <!-- Panel kanan -->
    <section class="flex flex-1 items-center justify-center px-6 py-12">
        <div class="w-full max-w-md">
            <div class="mb-10 flex items-center gap-3 lg:hidden">
                <img src="${ctx}/assets/logo.svg" alt="" class="h-11 w-11">
                <div class="leading-tight">
                    <p class="text-xl font-extrabold tracking-tight text-brand-900">RS ODGJ</p>
                    <p class="text-xs text-moss-500">Sistem Informasi Rumah Sakit</p>
                </div>
            </div>

            <h1 class="text-3xl font-extrabold tracking-tight text-moss-900">Masuk ke sistem</h1>
            <p class="mt-2 text-moss-500">Gunakan akun yang diberikan oleh administrator.</p>

            <c:if test="${not empty errorMsg}">
                <div role="alert" class="mt-6 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900">
                    <i class="fa-solid fa-circle-exclamation mt-0.5 text-red-600"></i><p class="font-medium"><c:out value="${errorMsg}"/></p>
                </div>
            </c:if>
            <c:if test="${param.sesi == 'habis' && empty errorMsg}">
                <div role="status" class="mt-6 flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
                    <i class="fa-solid fa-clock mt-0.5 text-amber-600"></i><p class="font-medium">Sesi Anda berakhir. Silakan masuk kembali.</p>
                </div>
            </c:if>
            <c:if test="${param.keluar == '1' && empty errorMsg}">
                <div role="status" class="mt-6 flex items-start gap-3 rounded-xl border border-brand-200 bg-brand-50 px-4 py-3 text-sm text-brand-900">
                    <i class="fa-solid fa-circle-check mt-0.5 text-brand-600"></i><p class="font-medium">Anda telah keluar dari sistem.</p>
                </div>
            </c:if>

            <form id="formLogin" action="${ctx}/login" method="post" class="mt-8 space-y-5">
                <div>
                    <label for="username" class="mb-1.5 block text-sm font-semibold text-moss-700">Username</label>
                    <div class="relative">
                        <i class="fa-regular fa-user absolute left-3.5 top-1/2 -translate-y-1/2 text-moss-400"></i>
                        <input id="username" type="text" name="username" value="<c:out value='${usernameLama}'/>" required autofocus autocomplete="username"
                               class="w-full rounded-lg border border-moss-300 bg-white py-3 pl-10 pr-4 text-sm text-moss-900 placeholder-moss-400 focus:border-brand-500 focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:ring-offset-0"
                               placeholder="Masukkan username">
                    </div>
                </div>
                <div>
                    <label for="password" class="mb-1.5 block text-sm font-semibold text-moss-700">Password</label>
                    <div class="relative">
                        <i class="fa-solid fa-lock absolute left-3.5 top-1/2 -translate-y-1/2 text-moss-400"></i>
                        <input id="password" type="password" name="password" required autocomplete="current-password"
                               class="w-full rounded-lg border border-moss-300 bg-white py-3 pl-10 pr-12 text-sm text-moss-900 placeholder-moss-400 focus:border-brand-500 focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:ring-offset-0"
                               placeholder="Masukkan password">
                        <button type="button" id="lihatSandi" class="absolute right-2 top-1/2 grid h-8 w-8 -translate-y-1/2 place-items-center rounded-md text-moss-500 hover:bg-moss-100" aria-label="Tampilkan password"><i class="fa-regular fa-eye"></i></button>
                    </div>
                </div>
                <button id="btnMasuk" type="submit" class="flex w-full items-center justify-center gap-2 rounded-lg bg-brand-600 px-4 py-3 text-sm font-semibold text-white transition-colors hover:bg-brand-700 disabled:opacity-70">
                    <span id="teksMasuk">Masuk</span><i class="fa-solid fa-arrow-right-to-bracket"></i>
                </button>
            </form>

            <p class="mt-8 text-center text-xs text-moss-500">Lupa password? Hubungi administrator sistem rumah sakit.</p>
        </div>
    </section>
</div>

<script>
    var inp = document.getElementById('password'), tgl = document.getElementById('lihatSandi');
    tgl.addEventListener('click', function () {
        var tampil = inp.type === 'password';
        inp.type = tampil ? 'text' : 'password';
        tgl.innerHTML = tampil ? '<i class="fa-regular fa-eye-slash"></i>' : '<i class="fa-regular fa-eye"></i>';
        tgl.setAttribute('aria-label', tampil ? 'Sembunyikan password' : 'Tampilkan password');
    });
    document.getElementById('formLogin').addEventListener('submit', function () {
        document.getElementById('btnMasuk').disabled = true;
        document.getElementById('teksMasuk').textContent = 'Memeriksa akun...';
    });
</script>
</body>
</html>
