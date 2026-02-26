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
        <jsp:param name="pageTitle" value="Execute Movement" />
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
                                <li class="breadcrumb-item active" aria-current="page">Execute #${movementRequest.id}</li>
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
                                <i class="bx bx-play-circle me-2"></i>Execute Movement #${movementRequest.id}
                            </h4>
                            <a href="${contextPath}/movement?action=details&id=${movementRequest.id}" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to Details
                            </a>
                        </div>
                        
                        <!-- Status Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar avatar-lg me-3 rounded bg-label-primary">
                                                <i class="bx bx-transfer bx-lg"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-0">Movement #${movementRequest.id}</h6>
                                                <small class="text-muted">
                                                    <i class="bx bx-building-house me-1"></i>${warehouse.name}
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <p class="text-muted mb-0">Status</p>
                                        <c:choose>
                                            <c:when test="${movementRequest.status == 'Created'}">
                                                <span class="badge bg-warning fs-6">Created</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'InProgress'}">
                                                <span class="badge bg-info fs-6">In Progress</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary fs-6">${movementRequest.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-5 text-md-end">
                                        <c:choose>
                                            <c:when test="${movementRequest.status == 'Created'}">
                                                <form action="${contextPath}/movement" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="start" />
                                                    <input type="hidden" name="id" value="${movementRequest.id}" />
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bx bx-play me-1"></i>Start Movement
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'InProgress'}">
                                                <form action="${contextPath}/movement" method="post" class="d-inline" 
                                                      onsubmit="return confirm('Are you sure you want to complete this movement? This will update inventory levels.');">
                                                    <input type="hidden" name="action" value="complete" />
                                                    <input type="hidden" name="id" value="${movementRequest.id}" />
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="bx bx-check me-1"></i>Complete Movement
                                                    </button>
                                                </form>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Instructions -->
                        <c:if test="${movementRequest.status == 'InProgress'}">
                            <div class="alert alert-info mb-6">
                                <h6 class="alert-heading mb-2">
                                    <i class="bx bx-info-circle me-1"></i>Execution Instructions
                                </h6>
                                <ol class="mb-0 ps-3">
                                    <li>Navigate to each source location and pick the specified quantities.</li>
                                    <li>Transport items to the destination locations.</li>
                                    <li>Place items at the destination locations.</li>
                                    <li>Once all items are moved, click "Complete Movement" to update inventory.</li>
                                </ol>
                            </div>
                        </c:if>
                        
                        <!-- Movement Items -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Items to Move</h5>
                                <span class="badge bg-primary">${itemsWithDetails.size()} items</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">#</th>
                                            <th>Product</th>
                                            <th>From Location</th>
                                            <th>To Location</th>
                                            <th>Qty to Move</th>
                                            <th>Source Available</th>
                                            <th>Dest Current</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="itemData" items="${itemsWithDetails}" varStatus="status">
                                            <c:set var="item" value="${itemData.item}" />
                                            <c:set var="product" value="${itemData.product}" />
                                            <c:set var="srcLoc" value="${itemData.sourceLocation}" />
                                            <c:set var="destLoc" value="${itemData.destinationLocation}" />
                                            <c:set var="srcQty" value="${itemData.sourceQuantity}" />
                                            <c:set var="destQty" value="${itemData.destinationQuantity}" />
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>
                                                    <strong>${product.sku}</strong>
                                                    <br><small class="text-muted">${product.name}</small>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <span class="badge bg-label-danger me-2">FROM</span>
                                                        <div>
                                                            <strong>${srcLoc.code}</strong>
                                                            <br><small class="text-muted">${srcLoc.type}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <span class="badge bg-label-success me-2">TO</span>
                                                        <div>
                                                            <strong>${destLoc.code}</strong>
                                                            <br><small class="text-muted">${destLoc.type}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="fs-5 fw-bold text-primary">${item.quantity}</span>
                                                    <span class="text-muted">${product.unit}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${srcQty >= item.quantity}">
                                                            <span class="text-success">${srcQty}</span>
                                                            <i class="bx bx-check-circle text-success ms-1"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger fw-bold">${srcQty}</span>
                                                            <i class="bx bx-error-circle text-danger ms-1" 
                                                               title="Insufficient quantity"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${destQty}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Summary after move -->
                        <c:if test="${movementRequest.status == 'InProgress'}">
                            <div class="card mt-6">
                                <div class="card-header">
                                    <h5 class="mb-0">Expected Result After Completion</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Product</th>
                                                <th>Source Location</th>
                                                <th>Current → After</th>
                                                <th>Destination Location</th>
                                                <th>Current → After</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="itemData" items="${itemsWithDetails}">
                                                <c:set var="item" value="${itemData.item}" />
                                                <c:set var="product" value="${itemData.product}" />
                                                <c:set var="srcLoc" value="${itemData.sourceLocation}" />
                                                <c:set var="destLoc" value="${itemData.destinationLocation}" />
                                                <c:set var="srcQty" value="${itemData.sourceQuantity}" />
                                                <c:set var="destQty" value="${itemData.destinationQuantity}" />
                                                <tr>
                                                    <td><strong>${product.sku}</strong></td>
                                                    <td>${srcLoc.code}</td>
                                                    <td>
                                                        <span class="text-muted">${srcQty}</span>
                                                        <i class="bx bx-right-arrow-alt mx-2"></i>
                                                        <span class="fw-bold text-danger">${srcQty - item.quantity}</span>
                                                        <small class="text-danger ms-1">(-${item.quantity})</small>
                                                    </td>
                                                    <td>${destLoc.code}</td>
                                                    <td>
                                                        <span class="text-muted">${destQty}</span>
                                                        <i class="bx bx-right-arrow-alt mx-2"></i>
                                                        <span class="fw-bold text-success">${destQty + item.quantity}</span>
                                                        <small class="text-success ms-1">(+${item.quantity})</small>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>
                        
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
