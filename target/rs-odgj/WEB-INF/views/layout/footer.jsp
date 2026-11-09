<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    </div>
    </main>
</div>

<script>
    (function () {
        var sb = document.getElementById('sidebar'), ov = document.getElementById('overlay');
        function toggle(open) {
            sb.classList.toggle('-translate-x-full', !open);
            ov.classList.toggle('hidden', !open);
        }
        document.getElementById('btnMenu').addEventListener('click', function () { toggle(true); });
        ov.addEventListener('click', function () { toggle(false); });

        var t = document.getElementById('tanggalHariIni');
        if (t) t.textContent = new Date().toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

        var f = document.getElementById('flash');
        if (f && f.className.indexOf('bg-brand-50') > -1) setTimeout(function () { if (f.parentNode) f.remove(); }, 6000);

        // dialog: tutup saat klik area gelap di luar kotak
        document.querySelectorAll('dialog').forEach(function (d) {
            d.addEventListener('click', function (e) { if (e.target === d) d.close(); });
        });
    })();
</script>
</body>
</html>
