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
        <jsp:param name="pageTitle" value="Execute Outbound #${outboundRequest.id}" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="outbound" />
                <jsp:param name="activeSubMenu" value="outbound-list" />
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
                                    <a href="${contextPath}/outbound">Outbound Requests</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/outbound?action=details&id=${outboundRequest.id}">Request #${outboundRequest.id}</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Execute</li>
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
                                <i class="bx bx-package me-2"></i>Execute Outbound #${outboundRequest.id}
                            </h4>
                            <div>
                                <a href="${contextPath}/outbound?action=details&id=${outboundRequest.id}" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i>Back to Details
                                </a>
                            </div>
                        </div>
                        
                        <!-- Request Info Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <span class="text-muted">Status:</span>
                                        <c:choose>
                                            <c:when test="${outboundRequest.status == 'Approved'}">
                                                <span class="badge bg-info ms-2">Ready to Pick</span>
                                            </c:when>
                                            <c:when test="${outboundRequest.status == 'InProgress'}">
                                                <span class="badge bg-primary ms-2">Picking In Progress</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-muted">Source:</span>
                                        <strong class="ms-2">${sourceWarehouse.name}</strong>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-muted">Reason:</span>
                                        <span class="badge bg-label-secondary ms-2">
                                            <c:choose>
                                                <c:when test="${not empty outboundRequest.reason}">${outboundRequest.reason}</c:when>
                                                <c:when test="${not empty outboundRequest.salesOrderId}">Sales Order</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <c:if test="${outboundRequest.status == 'Approved'}">
                                            <form action="${contextPath}/outbound" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="start" />
                                                <input type="hidden" name="id" value="${outboundRequest.id}" />
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-play me-1"></i>Start Picking
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${outboundRequest.status == 'Approved'}">
                            <!-- Approved - waiting to start -->
                            <div class="alert alert-info">
                                <i class="bx bx-info-circle me-2"></i>
                                Click "Start Picking" to begin the outbound process. You will then be able to record picked quantities.
                            </div>
                        </c:if>
                        
                        <c:if test="${outboundRequest.status == 'InProgress'}">
                            <!-- Picking Items -->
                            <div class="card mb-6">
                                <div class="card-header">
                                    <h5 class="mb-0">Pick Items</h5>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="item" items="${items}" varStatus="loop">
                                        <c:set var="productName" value="${requestScope['productName_'.concat(item.productId)]}" />
                                        <c:set var="productSku" value="${requestScope['productSku_'.concat(item.productId)]}" />
                                        <c:set var="available" value="${requestScope['available_'.concat(item.productId)]}" />
                                        
                                        <div class="card bg-light mb-3">
                                            <div class="card-body">
                                                <div class="row align-items-center">
                                                    <div class="col-md-4">
                                                        <h6 class="mb-1">${productName}</h6>
                                                        <small class="text-muted">${productSku}</small>
                                                    </div>
                                                    <div class="col-md-2 text-center">
                                                        <span class="text-muted small d-block">Requested</span>
                                                        <strong class="fs-5">${item.quantity}</strong>
                                                    </div>
                                                    <div class="col-md-2 text-center">
                                                        <span class="text-muted small d-block">Available</span>
                                                        <c:choose>
                                                            <c:when test="${available >= item.quantity}">
                                                                <strong class="fs-5 text-success">${available}</strong>
                                                            </c:when>
                                                            <c:when test="${available > 0}">
                                                                <strong class="fs-5 text-warning">${available}</strong>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <strong class="fs-5 text-danger">${available != null ? available : 0}</strong>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="col-md-2 text-center">
                                                        <span class="text-muted small d-block">Picked</span>
                                                        <strong class="fs-5">${item.pickedQuantity}</strong>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <c:choose>
                                                            <c:when test="${item.pickedQuantity >= item.quantity}">
                                                                <span class="badge bg-success w-100 py-2">
                                                                    <i class="bx bx-check me-1"></i>Complete
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-outline-primary btn-sm w-100" 
                                                                        data-bs-toggle="modal" 
                                                                        data-bs-target="#pickModal${item.productId}"
                                                                        ${(available == null || available <= 0) ? 'disabled' : ''}>
                                                                    <i class="bx bx-box me-1"></i>Pick
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                
                                                <c:if test="${available != null && available < item.quantity && item.pickedQuantity < item.quantity}">
                                                    <div class="alert alert-warning mt-3 mb-0 py-2">
                                                        <i class="bx bx-error me-1"></i>
                                                        <small>Insufficient inventory. Available: ${available}, Needed: ${item.quantity - item.pickedQuantity}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <!-- Pick Modal for this item -->
                                        <div class="modal fade" id="pickModal${item.productId}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form action="${contextPath}/outbound" method="post">
                                                        <input type="hidden" name="action" value="updateItem" />
                                                        <input type="hidden" name="id" value="${outboundRequest.id}" />
                                                        <input type="hidden" name="productId" value="${item.productId}" />
                                                        
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Pick: ${productName}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <div class="d-flex justify-content-between text-muted small mb-2">
                                                                    <span>Requested: ${item.quantity}</span>
                                                                    <span>Already Picked: ${item.pickedQuantity}</span>
                                                                </div>
                                                                <div class="d-flex justify-content-between text-muted small mb-3">
                                                                    <span>Remaining: ${item.quantity - item.pickedQuantity}</span>
                                                                    <span>Available: ${available != null ? available : 0}</span>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="mb-3">
                                                                <label class="form-label">Picked Quantity <span class="text-danger">*</span></label>
                                                                <c:set var="maxPick" value="${item.quantity - item.pickedQuantity}" />
                                                                <c:if test="${available != null && available < maxPick}">
                                                                    <c:set var="maxPick" value="${available}" />
                                                                </c:if>
                                                                <input type="number" 
                                                                       class="form-control" 
                                                                       name="pickedQuantity" 
                                                                       min="1" 
                                                                       max="${maxPick > 0 ? maxPick : 1}"
                                                                       value="${maxPick > 0 ? maxPick : 1}"
                                                                       required />
                                                                <small class="text-muted">
                                                                    Enter quantity picked (max: ${maxPick > 0 ? maxPick : 0})
                                                                </small>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary" ${maxPick <= 0 ? 'disabled' : ''}>
                                                                <i class="bx bx-check me-1"></i>Confirm Pick
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- Complete Button -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">Complete Outbound</h6>
                                            <p class="text-muted mb-0">
                                                Mark this outbound request as completed. Inventory will be deducted based on picked quantities.
                                            </p>
                                        </div>
                                        <form action="${contextPath}/outbound" method="post" 
                                              onsubmit="return confirm('Complete this outbound request? Inventory will be deducted. This cannot be undone.');">
                                            <input type="hidden" name="action" value="complete" />
                                            <input type="hidden" name="id" value="${outboundRequest.id}" />
                                            <button type="submit" class="btn btn-success">
                                                <i class="bx bx-check-double me-1"></i>Complete Outbound
                                            </button>
                                        </form>
                                    </div>
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
