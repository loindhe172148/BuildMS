<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" data-assets-path="${pageContext.request.contextPath}/assets/" data-template="vertical-menu-template-free">
<head>
    <jsp:include page="head.jsp">
        <jsp:param name="pageTitle" value="${param.pageTitle}" />
        <jsp:param name="pageCss" value="${param.pageCss}" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp">
                <jsp:param name="activeMenu" value="${param.activeMenu}" />
                <jsp:param name="activeSubMenu" value="${param.activeSubMenu}" />
            </jsp:include>
            
            <!-- Layout container -->
            <div class="layout-page">
                
                <!-- Navbar -->
                <jsp:include page="navbar.jsp" />
                
                <!-- Content wrapper -->
                <div class="content-wrapper">
                    <!-- Content -->
                    <main class="container-xxl flex-grow-1 container-p-y" role="main">
                        
                        <!-- Breadcrumb -->
                        <c:if test="${not empty param.breadcrumb}">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/dashboard">Home</a>
                                    </li>
                                    <!-- Breadcrumb items will be added by the page -->
                                </ol>
                            </nav>
                        </c:if>
                        
                        <!-- Alert Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bx bx-error me-2"></i>
                                ${warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty infoMessage}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <i class="bx bx-info-circle me-2"></i>
                                ${infoMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Page Content - To be included by child pages -->
                        <jsp:include page="${param.contentPage}" />
                        
                    </main>
                    <!-- / Content -->
                    
                    <!-- Footer -->
                    <jsp:include page="footer.jsp" />
                    
                    <div class="content-backdrop fade"></div>
                </div>
                <!-- Content wrapper -->
            </div>
            <!-- / Layout page -->
        </div>

        <!-- Overlay -->
        <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <!-- / Layout wrapper -->

    <!-- Scripts -->
    <jsp:include page="scripts.jsp">
        <jsp:param name="pageScript" value="${param.pageScript}" />
    </jsp:include>
</body>
</html>
