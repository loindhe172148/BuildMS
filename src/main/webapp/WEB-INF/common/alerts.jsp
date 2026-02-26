<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- Alert Messages Component - Can be included separately if needed --%>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bx bx-check-circle me-2" aria-hidden="true"></i>
        ${successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bx bx-error-circle me-2" aria-hidden="true"></i>
        ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty warningMessage}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bx bx-error me-2" aria-hidden="true"></i>
        ${warningMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty infoMessage}">
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <i class="bx bx-info-circle me-2" aria-hidden="true"></i>
        ${infoMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<%-- Field-level errors (for form validation) --%>
<c:if test="${not empty errors}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bx bx-error-circle me-2" aria-hidden="true"></i>
        <strong>Please fix the following errors:</strong>
        <ul class="mb-0 mt-2">
            <c:forEach var="error" items="${errors}">
                <li>${error}</li>
            </c:forEach>
        </ul>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
