<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />

<title>${param.pageTitle} | Smart WMS</title>

<meta name="description" content="Smart Warehouse Management System" />

<!-- Favicon -->
<link rel="icon" type="image/x-icon" href="${contextPath}/assets/img/favicon/favicon.ico" />

<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet" />

<link rel="stylesheet" href="${contextPath}/assets/vendor/fonts/iconify-icons.css" />

<!-- Core CSS -->
<link rel="stylesheet" href="${contextPath}/assets/vendor/css/core.css" />
<link rel="stylesheet" href="${contextPath}/assets/css/demo.css" />

<!-- Vendors CSS -->
<link rel="stylesheet" href="${contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

<!-- Page CSS -->
<c:if test="${not empty param.pageCss}">
    <link rel="stylesheet" href="${contextPath}${param.pageCss}" />
</c:if>

<!-- Helpers -->
<script src="${contextPath}/assets/vendor/js/helpers.js"></script>

<!-- Config -->
<script src="${contextPath}/assets/js/config.js"></script>
