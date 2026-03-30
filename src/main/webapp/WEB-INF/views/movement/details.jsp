<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Movement Details" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="movement" />
                <jsp:param name="activeSubMenu" value="movement-list" />
            </jsp:include>
            
            <!-- Layout container -->
            <div class="layout-page">
                
                <!-- Navbar -->
                <jsp:include page="/WEB-INF/common/navbar.jsp" />
                
                <!-- Content wrapper -->
                <div class="content-wrapper">
                    <!-- Content -->
                    <main class="container-xxl flex-grow-1 container-p-y" role="main">
                        
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/dashboard">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/movement">Internal Movements</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Details #${movementRequest.id}</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-transfer me-2"></i>Movement #${movementRequest.id}
                            </h4>
                            <div>
                                <a href="${contextPath}/movement" class="btn btn-outline-secondary me-2">
                                    <i class="bx bx-arrow-back me-1"></i>Back to List
                                </a>
                                <c:if test="${movementRequest.status == 'Created' || movementRequest.status == 'InProgress'}">
                                    <a href="${contextPath}/movement?action=execute&id=${movementRequest.id}" class="btn btn-primary">
                                        <i class="bx bx-play me-1"></i>Execute Movement
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Request Info Card -->
                        <div class="card mb-6">
                            <div class="card-header">
                                <h5 class="mb-0">Request Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Request ID</p>
                                        <p class="fw-bold">#${movementRequest.id}</p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Type</p>
                                        <p class="fw-bold">Internal Movement</p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Status</p>
                                        <c:choose>
                                            <c:when test="${movementRequest.status == 'Created'}">
                                                <span class="badge bg-warning">Created</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'InProgress'}">
                                                <span class="badge bg-info">In Progress</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${movementRequest.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Warehouse</p>
                                        <p class="fw-bold">
                                            <i class="bx bx-building-house me-1"></i>${warehouse.name}
                                        </p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Created By</p>
                                        <p class="fw-bold">${createdByUser.name}</p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Created Date</p>
                                        <p class="fw-bold">
                                            <fmt:parseDate value="${movementRequest.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="createdDate" type="both" />
                                            <fmt:formatDate value="${createdDate}" pattern="yyyy-MM-dd HH:mm" />
                                        </p>
                                    </div>
                                    <c:if test="${movementRequest.status == 'Completed' and not empty completedByUser}">
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Completed By</p>
                                            <p class="fw-bold">${completedByUser.name}</p>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Completed Date</p>
                                            <p class="fw-bold">
                                                <fmt:parseDate value="${movementRequest.completedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="completedDate" type="both" />
                                                <fmt:formatDate value="${completedDate}" pattern="yyyy-MM-dd HH:mm" />
                                            </p>
                                        </div>
                                    </c:if>
                                </div>
                                <c:if test="${not empty movementRequest.notes}">
                                    <div class="row">
                                        <div class="col-12">
                                            <p class="text-muted mb-1">Notes</p>
                                            <p>${movementRequest.notes}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Movement Items -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Movement Items</h5>
                                <span class="badge bg-primary">${itemsWithDetails.size()} items</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Product</th>
                                            <th>Source Location</th>
                                            <th>Destination Location</th>
                                            <th>Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="itemData" items="${itemsWithDetails}" varStatus="status">
                                            <c:set var="item" value="${itemData.item}" />
                                            <c:set var="product" value="${itemData.product}" />
                                            <c:set var="srcLoc" value="${itemData.sourceLocation}" />
                                            <c:set var="destLoc" value="${itemData.destinationLocation}" />
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>
                                                    <a href="${contextPath}/product?action=details&id=${product.id}">
                                                        <strong>${product.sku}</strong>
                                                    </a>
                                                    <br><small class="text-muted">${product.name}</small>
                                                </td>
                                                <td>
                                                    <i class="bx bx-log-out-circle text-danger me-1"></i>
                                                    ${srcLoc.code}
                                                    <span class="text-muted">(${srcLoc.type})</span>
                                                </td>
                                                <td>
                                                    <i class="bx bx-log-in-circle text-success me-1"></i>
                                                    ${destLoc.code}
                                                    <span class="text-muted">(${destLoc.type})</span>
                                                </td>
                                                <td>
                                                    <span class="fw-bold">${item.quantity}</span>
                                                    <span class="text-muted">${product.unit}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                    </div>
                    <!-- / Content -->
                    
                    <jsp:include page="/WEB-INF/common/footer.jsp" />
                    
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
    
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
