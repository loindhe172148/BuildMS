<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    Smart WMS - Index Page
    
    This is the entry point of the application.
    - If user is logged in: redirect to dashboard
    - If user is not logged in: redirect to login page
--%>

<c:choose>
    <c:when test="${not empty sessionScope.user}">
        <%-- User is logged in, redirect to dashboard --%>
        <c:redirect url="/dashboard" />
    </c:when>
    <c:otherwise>
        <%-- User is not logged in, redirect to login page --%>
        <c:redirect url="/auth?action=login" />
    </c:otherwise>
</c:choose>