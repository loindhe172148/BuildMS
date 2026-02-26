<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en" class="layout-wide" data-assets-path="${contextPath}/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />

    <title>Under Maintenance | Smart WMS</title>

    <meta name="description" content="Under maintenance" />

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
    <link rel="stylesheet" href="${contextPath}/assets/vendor/css/pages/page-misc.css" />

    <!-- Helpers -->
    <script src="${contextPath}/assets/vendor/js/helpers.js"></script>

    <!-- Config -->
    <script src="${contextPath}/assets/js/config.js"></script>
</head>
<body>
    <!-- Content -->
    <main class="container-xxl container-p-y" role="main">
        <div class="misc-wrapper">
            <h3 class="mb-2 mx-2">Under Maintenance! 🚧</h3>
            <p class="mb-6 mx-2">Sorry for the inconvenience. We're performing scheduled maintenance.</p>
            <p class="mb-4 mx-2 text-muted">We'll be back shortly. Thank you for your patience.</p>
            <a href="${contextPath}/" class="btn btn-primary">Try Again</a>
            <div class="mt-6">
                <img src="${contextPath}/assets/img/illustrations/girl-doing-yoga-light.png" 
                     alt="Under Maintenance" width="500" class="img-fluid" />
            </div>
        </div>
    </main>
    <!-- /Content -->

    <!-- Core JS -->
    <script src="${contextPath}/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="${contextPath}/assets/vendor/libs/popper/popper.js"></script>
    <script src="${contextPath}/assets/vendor/js/bootstrap.js"></script>
    <script src="${contextPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="${contextPath}/assets/vendor/js/menu.js"></script>

    <!-- Main JS -->
    <script src="${contextPath}/assets/js/main.js"></script>
</body>
</html>
