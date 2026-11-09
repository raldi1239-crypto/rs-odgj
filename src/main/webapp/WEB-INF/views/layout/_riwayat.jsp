<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<section>
    <h3 class="section-title mb-4">Riwayat rekam medis <span class="ml-1 text-sm font-medium text-moss-500">(${riwayat.size()} catatan)</span></h3>
    <c:choose>
        <c:when test="${empty riwayat}">
            <div class="card p-10 text-center">
                <span class="mx-auto grid h-12 w-12 place-items-center rounded-full bg-moss-100 text-moss-400"><i class="fa-solid fa-notes-medical"></i></span>
                <p class="mt-3 font-semibold text-moss-800">Belum ada catatan medis</p>
                <p class="mt-1 text-sm text-moss-500">Catatan pertama akan muncul di sini setelah dokter atau perawat menyimpannya.</p>
            </div>
        </c:when>
        <c:otherwise>
            <ol class="relative space-y-5 border-l-2 border-brand-200 pl-6">
                <c:forEach var="r" items="${riwayat}">
                    <li class="relative">
                        <span class="absolute -left-[31px] top-5 h-3 w-3 rounded-full border-2 border-white ${r.kondisi == 'Memburuk' ? 'bg-red-600' : (r.kondisi == 'Membaik' ? 'bg-brand-500' : 'bg-moss-400')}"></span>
                        <article class="card p-5">
                            <header class="flex flex-wrap items-center justify-between gap-2">
                                <div>
                                    <p class="text-sm font-bold text-moss-900"><fmt:formatDate value="${r.waktuCatat}" pattern="EEEE, dd MMMM yyyy"/>, <fmt:formatDate value="${r.waktuCatat}" pattern="HH:mm"/></p>
                                    <p class="text-xs text-moss-500">oleh <c:out value="${empty r.namaPetugas ? 'petugas tidak diketahui' : r.namaPetugas}"/><c:if test="${not empty r.rolePetugas}"> (${r.rolePetugas})</c:if></p>
                                </div>
                                <t:kondisi nilai="${r.kondisi}"/>
                            </header>

                            <c:if test="${not empty r.tekananDarah || r.nadi != null || r.suhu != null}">
                                <div class="mt-4 flex flex-wrap gap-2 text-xs font-semibold text-moss-700">
                                    <c:if test="${not empty r.tekananDarah}"><span class="rounded-md bg-moss-100 px-2.5 py-1"><i class="fa-solid fa-droplet mr-1 text-red-500"></i>TD ${r.tekananDarah} mmHg</span></c:if>
                                    <c:if test="${r.nadi != null}"><span class="rounded-md bg-moss-100 px-2.5 py-1"><i class="fa-solid fa-heart-pulse mr-1 text-rose-500"></i>Nadi ${r.nadi} x/menit</span></c:if>
                                    <c:if test="${r.suhu != null}"><span class="rounded-md bg-moss-100 px-2.5 py-1"><i class="fa-solid fa-temperature-half mr-1 text-amber-500"></i>Suhu ${r.suhu} &deg;C</span></c:if>
                                </div>
                            </c:if>

                            <dl class="mt-4 grid gap-4 text-sm sm:grid-cols-2">
                                <c:if test="${not empty r.keluhan}"><div><dt class="text-xs font-semibold text-moss-500">Keluhan</dt><dd class="mt-0.5 text-moss-800"><c:out value="${r.keluhan}"/></dd></div></c:if>
                                <c:if test="${not empty r.observasi}"><div><dt class="text-xs font-semibold text-moss-500">Observasi</dt><dd class="mt-0.5 text-moss-800"><c:out value="${r.observasi}"/></dd></div></c:if>
                                <c:if test="${not empty r.diagnosa}"><div><dt class="text-xs font-semibold text-moss-500">Diagnosa</dt><dd class="mt-0.5 font-semibold text-moss-900"><c:out value="${r.diagnosa}"/></dd></div></c:if>
                                <c:if test="${not empty r.terapi}"><div><dt class="text-xs font-semibold text-moss-500">Terapi</dt><dd class="mt-0.5 text-moss-800"><c:out value="${r.terapi}"/></dd></div></c:if>
                            </dl>
                        </article>
                    </li>
                </c:forEach>
            </ol>
        </c:otherwise>
    </c:choose>
</section>
