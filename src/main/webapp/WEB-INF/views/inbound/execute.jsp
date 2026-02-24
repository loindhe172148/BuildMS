<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Execute Inbound Request" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="inbound" />
                <jsp:param name="activeSubMenu" value="inbound-list" />
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
                                    <a href="${contextPath}/inbound">Inbound Requests</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Execute #${inboundRequest.id}</li>
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
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-play-circle me-2"></i>Execute Inbound Request #${inboundRequest.id}
                                </h4>
                                <c:choose>
                                    <c:when test="${inboundRequest.status == 'Approved'}">
                                        <span class="badge bg-info fs-6">Approved - Ready to Execute</span>
                                    </c:when>
                                    <c:when test="${inboundRequest.status == 'InProgress'}">
                                        <span class="badge bg-primary fs-6">In Progress</span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <a href="${contextPath}/inbound?action=details&id=${inboundRequest.id}" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to Details
                            </a>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <!-- Start Execution (if Approved) -->
                                <c:if test="${inboundRequest.status == 'Approved'}">
                                    <div class="card mb-6">
                                        <div class="card-body text-center py-5">
                                            <i class="bx bx-play-circle bx-lg text-primary mb-3"></i>
                                            <h5>Ready to Execute</h5>
                                            <p class="text-muted mb-4">Click the button below to start receiving goods for this request.</p>
                                            <form action="${contextPath}/inbound" method="post">
                                                <input type="hidden" name="action" value="start" />
                                                <input type="hidden" name="id" value="${inboundRequest.id}" />
                                                <button type="submit" class="btn btn-primary btn-lg">
                                                    <i class="bx bx-play me-2"></i>Start Execution
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Items to Receive (if InProgress) -->
                                <c:if test="${inboundRequest.status == 'InProgress'}">
                                    <div class="card mb-6">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">Items to Receive</h5>
                                            <span class="badge bg-primary">${items.size()} items</span>
                                        </div>
                                        <div class="card-body">
                                            <c:forEach var="item" items="${items}" varStatus="status">
                                                <div class="card bg-light mb-3">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                                            <div>
                                                                <h6 class="mb-1">${requestScope['productName_'.concat(item.productId)]}</h6>
                                                                <small class="text-muted">SKU: ${requestScope['productSku_'.concat(item.productId)]}</small>
                                                            </div>
                                                            <c:choose>
                                                                <c:when test="${not empty item.receivedQuantity && item.receivedQuantity == item.quantity}">
                                                                    <span class="badge bg-success"><i class="bx bx-check me-1"></i>Complete</span>
                                                                </c:when>
                                                                <c:when test="${not empty item.receivedQuantity && item.receivedQuantity > 0}">
                                                                    <span class="badge bg-warning">Partial</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Pending</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        
                                                        <form action="${contextPath}/inbound" method="post" class="row g-3 align-items-end">
                                                            <input type="hidden" name="action" value="updateItem" />
                                                            <input type="hidden" name="id" value="${inboundRequest.id}" />
                                                            <input type="hidden" name="productId" value="${item.productId}" />
                                                            
                                                            <div class="col-md-3">
                                                                <label class="form-label">Expected Qty</label>
                                                                <input type="text" class="form-control" value="${item.quantity}" readonly />
                                                            </div>
                                                            
                                                            <div class="col-md-3">
                                                                <label class="form-label">Received Qty <span class="text-danger">*</span></label>
                                                                <input type="number" class="form-control" name="receivedQuantity" 
                                                                       min="0" value="${not empty item.receivedQuantity ? item.receivedQuantity : item.quantity}" required />
                                                            </div>
                                                            
                                                            <div class="col-md-4">
                                                                <label class="form-label">Location</label>
                                                                <select class="form-select" name="locationId">
                                                                    <option value="">Select location...</option>
                                                                    <c:forEach var="loc" items="${locations}">
                                                                        <c:if test="${loc.isActive}">
                                                                            <option value="${loc.id}" ${item.locationId == loc.id ? 'selected' : ''}>
                                                                                ${loc.code} (${loc.type})
                                                                            </option>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            
                                                            <div class="col-md-2">
                                                                <button type="submit" class="btn btn-outline-primary w-100" aria-label="Save quantity">
                                                                    <i class="bx bx-save" aria-hidden="true"></i>
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    
                                    <!-- Complete Button -->
                                    <div class="card">
                                        <div class="card-body">
                                            <form action="${contextPath}/inbound" method="post">
                                                <input type="hidden" name="action" value="complete" />
                                                <input type="hidden" name="id" value="${inboundRequest.id}" />
                                                <button type="submit" class="btn btn-success btn-lg w-100" 
                                                        onclick="return confirm('Complete this inbound request? This will update inventory.')">
                                                    <i class="bx bx-check-circle me-2"></i>Complete Inbound Request
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="col-md-4">
                                <!-- Request Summary -->
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="bx bx-info-circle me-2"></i>Request Summary</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted small">Destination Warehouse</label>
                                            <p class="mb-0 fw-semibold">
                                                <c:choose>
                                                    <c:when test="${not empty warehouse}">${warehouse.name}</c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted small">Total Items</label>
                                            <p class="mb-0 fw-semibold">${items.size()}</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted small">Expected Date</label>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${not empty inboundRequest.expectedDate}">
                                                        ${inboundRequest.expectedDate.toLocalDate()}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Instructions -->
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="bx bx-help-circle me-2"></i>Instructions</h6>
                                    </div>
                                    <div class="card-body">
                                        <ol class="mb-0 ps-3">
                                            <li class="mb-2">Physically receive each item</li>
                                            <li class="mb-2">Enter the actual received quantity</li>
                                            <li class="mb-2">Select target storage location</li>
                                            <li class="mb-2">Click Complete when done</li>
                                        </ol>
                                        <hr />
                                        <p class="text-muted small mb-0">
                                            <i class="bx bx-info-circle me-1"></i>
                                            Inventory will be updated automatically upon completion.
                                        </p>
                                    </div>
                                </div>
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
