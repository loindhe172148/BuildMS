<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="transfer" value="${request}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Transfer Details" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="transfers" />
                <jsp:param name="activeSubMenu" value="transfer-list" />
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
                                    <a href="${contextPath}/transfer">Transfers</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">${transfer.requestNumber}</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-transfer me-2"></i>Transfer: ${transfer.requestNumber}
                                </h4>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${transfer.status == 'Completed'}">bg-success</c:when>
                                        <c:when test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving'}">bg-info</c:when>
                                        <c:when test="${transfer.status == 'Approved'}">bg-primary</c:when>
                                        <c:when test="${transfer.status == 'Created'}">bg-warning</c:when>
                                        <c:when test="${transfer.status == 'Rejected'}">bg-danger</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>
                                    fs-6">
                                    ${transfer.status}
                                </span>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${contextPath}/transfer" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i> Back to List
                                </a>
                                
                                <!-- Approve/Reject (Manager only, Status = Created) -->
                                <c:if test="${transfer.status == 'Created' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                    <form method="post" action="${contextPath}/transfer" class="d-inline">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="id" value="${transfer.id}">
                                        <button type="submit" class="btn btn-success">
                                            <i class="bx bx-check me-1"></i> Approve
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                        <i class="bx bx-x me-1"></i> Reject
                                    </button>
                                </c:if>
                                
                                <!-- Start Outbound (Status = Approved) -->
                                <c:if test="${transfer.status == 'Approved' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff')}">
                                    <a href="${contextPath}/transfer?action=execute-outbound&id=${transfer.id}" class="btn btn-primary">
                                        <i class="bx bx-play me-1"></i> Execute Outbound
                                    </a>
                                </c:if>
                                
                                <!-- Complete Outbound / Start Inbound (Status = InProgress or InTransit) -->
                                <c:if test="${transfer.status == 'InProgress' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff')}">
                                    <a href="${contextPath}/transfer?action=execute-outbound&id=${transfer.id}" class="btn btn-info">
                                        <i class="bx bx-check-circle me-1"></i> Complete Outbound
                                    </a>
                                </c:if>
                                
                                <c:if test="${transfer.status == 'InTransit' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff')}">
                                    <a href="${contextPath}/transfer?action=execute-inbound&id=${transfer.id}" class="btn btn-primary">
                                        <i class="bx bx-download me-1"></i> Execute Inbound
                                    </a>
                                </c:if>
                                
                                <c:if test="${transfer.status == 'Receiving' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff')}">
                                    <a href="${contextPath}/transfer?action=execute-inbound&id=${transfer.id}" class="btn btn-success">
                                        <i class="bx bx-check-double me-1"></i> Complete Inbound
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Transfer Information -->
                        <div class="row">
                            <!-- Transfer Details -->
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0"><i class="bx bx-info-circle me-2"></i>Transfer Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-borderless mb-0">
                                            <tr>
                                                <th class="ps-0" width="40%">Request Number:</th>
                                                <td><strong>${transfer.requestNumber}</strong></td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Type:</th>
                                                <td><span class="badge bg-label-info">${transfer.type}</span></td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Status:</th>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${transfer.status == 'Completed'}">bg-success</c:when>
                                                            <c:when test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving'}">bg-info</c:when>
                                                            <c:when test="${transfer.status == 'Approved'}">bg-primary</c:when>
                                                            <c:when test="${transfer.status == 'Created'}">bg-warning</c:when>
                                                            <c:when test="${transfer.status == 'Rejected'}">bg-danger</c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        ${transfer.status}
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Created By:</th>
                                                <td>${createdByUser.fullName}</td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Created At:</th>
                                                <td>
                                                    <fmt:formatDate value="${transfer.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                                </td>
                                            </tr>
                                            <c:if test="${not empty transfer.notes}">
                                                <tr>
                                                    <th class="ps-0">Notes:</th>
                                                    <td>${transfer.notes}</td>
                                                </tr>
                                            </c:if>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Warehouse Details -->
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0"><i class="bx bx-building-house me-2"></i>Warehouse Details</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-5 text-center">
                                                <div class="border rounded p-3 bg-light">
                                                    <i class="bx bx-export fs-1 text-danger mb-2"></i>
                                                    <h6 class="text-muted mb-1">Source</h6>
                                                    <strong>${sourceWarehouse.name}</strong>
                                                    <br>
                                                    <small class="text-muted">${sourceWarehouse.code}</small>
                                                </div>
                                            </div>
                                            <div class="col-2 d-flex align-items-center justify-content-center">
                                                <i class="bx bx-right-arrow-alt fs-1 text-primary"></i>
                                            </div>
                                            <div class="col-5 text-center">
                                                <div class="border rounded p-3 bg-light">
                                                    <i class="bx bx-import fs-1 text-success mb-2"></i>
                                                    <h6 class="text-muted mb-1">Destination</h6>
                                                    <strong>${destinationWarehouse.name}</strong>
                                                    <br>
                                                    <small class="text-muted">${destinationWarehouse.code}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Transfer Items -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="bx bx-package me-2"></i>Transfer Items</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Product</th>
                                            <th>SKU</th>
                                            <th class="text-center">Quantity</th>
                                            <c:if test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                <th class="text-center">Picked Qty</th>
                                            </c:if>
                                            <c:if test="${transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                <th class="text-center">Received Qty</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${requestItems}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.product}">
                                                            ${item.product.name}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Product #${item.productId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty item.product}">
                                                        <code>${item.product.sku}</code>
                                                    </c:if>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-label-primary">${item.quantity}</span>
                                                </td>
                                                <c:if test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <td class="text-center">
                                                        <span class="badge bg-label-info">${item.pickedQuantity != null ? item.pickedQuantity : 0}</span>
                                                    </td>
                                                </c:if>
                                                <c:if test="${transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <td class="text-center">
                                                        <span class="badge bg-label-success">${item.receivedQuantity != null ? item.receivedQuantity : 0}</span>
                                                    </td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty requestItems}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">
                                                    No items in this transfer.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Status Timeline -->
                        <c:if test="${not empty statusHistory}">
                            <div class="card mt-4">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="bx bx-history me-2"></i>Status History</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="timeline">
                                        <c:forEach var="history" items="${statusHistory}">
                                            <li class="timeline-item">
                                                <span class="timeline-point"></span>
                                                <div class="timeline-event">
                                                    <div class="timeline-header">
                                                        <h6 class="mb-0">${history.status}</h6>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${history.changedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                                        </small>
                                                    </div>
                                                    <c:if test="${not empty history.notes}">
                                                        <p class="mb-0">${history.notes}</p>
                                                    </c:if>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </c:if>
                        
                    </div>
                    <!-- / Content -->
                    
                    <!-- Footer -->
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
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${contextPath}/transfer">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="id" value="${transfer.id}">
                    <div class="modal-header">
                        <h5 class="modal-title">Reject Transfer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                            <textarea name="reason" class="form-control" rows="3" required
                                      placeholder="Please provide a reason for rejection..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bx bx-x me-1"></i> Reject Transfer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
