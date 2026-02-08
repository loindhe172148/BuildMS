<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Core JS -->
<script src="${contextPath}/assets/vendor/libs/jquery/jquery.js"></script>
<script src="${contextPath}/assets/vendor/libs/popper/popper.js"></script>
<script src="${contextPath}/assets/vendor/js/bootstrap.js"></script>
<script src="${contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="${contextPath}/assets/vendor/js/menu.js"></script>

<!-- Main JS -->
<script src="${contextPath}/assets/js/main.js"></script>

<!-- Page specific JS -->
<c:if test="${not empty param.pageScript}">
    <script src="${contextPath}${param.pageScript}"></script>
</c:if>

<!-- Custom application JS -->
<script>
    // Global context path for JS
    const APP_CONTEXT = '${contextPath}';
    
    // Initialize tooltips
    document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function(tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
    
    // Confirm delete helper
    function confirmDelete(message, formId) {
        if (confirm(message || 'Are you sure you want to delete this item?')) {
            document.getElementById(formId).submit();
        }
        return false;
    }
    
    // Show loading spinner
    function showLoading() {
        document.body.classList.add('loading');
    }
    
    // Hide loading spinner
    function hideLoading() {
        document.body.classList.remove('loading');
    }
</script>
