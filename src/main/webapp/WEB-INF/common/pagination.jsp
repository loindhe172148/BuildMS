<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%--
    Pagination Component
    
    Usage:
    <jsp:include page="/WEB-INF/common/pagination.jsp">
        <jsp:param name="currentPage" value="${currentPage}" />
        <jsp:param name="totalPages" value="${totalPages}" />
        <jsp:param name="baseUrl" value="${contextPath}/product?action=list" />
    </jsp:include>
    
    Required request attributes or parameters:
    - currentPage: Current page number (1-based)
    - totalPages: Total number of pages
    - baseUrl: Base URL for pagination links (will append &page=X)
--%>

<c:set var="currentPage" value="${param.currentPage}" />
<c:set var="totalPages" value="${param.totalPages}" />
<c:set var="baseUrl" value="${param.baseUrl}" />

<c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
            <%-- Previous button --%>
            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                <a class="page-link" href="${baseUrl}&page=${currentPage - 1}" aria-label="Previous">
                    <span aria-hidden="true"><i class="tf-icon bx bx-chevron-left"></i></span>
                </a>
            </li>
            
            <%-- First page --%>
            <c:if test="${currentPage > 3}">
                <li class="page-item">
                    <a class="page-link" href="${baseUrl}&page=1">1</a>
                </li>
                <c:if test="${currentPage > 4}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </c:if>
            </c:if>
            
            <%-- Page numbers around current page --%>
            <c:forEach begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                       end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" 
                       var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${baseUrl}&page=${i}">${i}</a>
                </li>
            </c:forEach>
            
            <%-- Last page --%>
            <c:if test="${currentPage < totalPages - 2}">
                <c:if test="${currentPage < totalPages - 3}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </c:if>
                <li class="page-item">
                    <a class="page-link" href="${baseUrl}&page=${totalPages}">${totalPages}</a>
                </li>
            </c:if>
            
            <%-- Next button --%>
            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${baseUrl}&page=${currentPage + 1}" aria-label="Next">
                    <span aria-hidden="true"><i class="tf-icon bx bx-chevron-right"></i></span>
                </a>
            </li>
        </ul>
    </nav>
    
    <div class="text-center text-muted small">
        Page ${currentPage} of ${totalPages}
    </div>
</c:if>
