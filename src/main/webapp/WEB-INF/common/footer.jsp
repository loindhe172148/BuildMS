<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Footer -->
<footer class="content-footer footer bg-footer-theme">
    <div class="container-xxl">
        <div class="footer-container d-flex align-items-center justify-content-between py-4 flex-md-row flex-column">
            <div class="mb-2 mb-md-0">
                &copy; 2026 <a href="${contextPath}/" class="footer-link fw-medium">Smart WMS</a> - 
                Warehouse Management System
            </div>
            <div class="d-none d-lg-inline-block">
                <a href="${contextPath}/help" class="footer-link me-4">Help</a>
                <a href="${contextPath}/about" class="footer-link me-4">About</a>
                <a href="${contextPath}/contact" class="footer-link">Contact</a>
            </div>
        </div>
    </div>
</footer>
<!-- / Footer -->
