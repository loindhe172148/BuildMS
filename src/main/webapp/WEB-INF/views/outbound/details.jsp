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
        <jsp:param name="pageTitle" value="Outbound Request #${request.id}" />
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
                                <li class="breadcrumb-item active" aria-current="page">Request #${outboundRequest.id}</li>
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
                                <i class="bx bx-package me-2"></i>Outbound Request #${outboundRequest.id}
                            </h4>
                            <div>
                                <a href="${contextPath}/outbound" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i>Back to List
                                </a>
                                
                                <c:if test="${outboundRequest.status == 'Created' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                    <a href="${contextPath}/outbound?action=approve&id=${outboundRequest.id}" class="btn btn-success">
                                        <i class="bx bx-check-circle me-1"></i>Approve/Reject
                                    </a>
                                </c:if>
                                
                                <c:if test="${(outboundRequest.status == 'Approved' || outboundRequest.status == 'InProgress') && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff')}">
                                    <a href="${contextPath}/outbound?action=execute&id=${outboundRequest.id}" class="btn btn-warning">
                                        <i class="bx bx-play me-1"></i>Execute
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Request Info -->
                            <div class="col-md-8">
                                <div class="card mb-6">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Request Information</h5>
                                        <c:choose>
                                            <c:when test="${outboundRequest.status == 'Created'}">
                                                <span class="badge bg-warning">Pending Approval</span>
                                            </c:when>
                                            <c:when test="${outboundRequest.status == 'Approved'}">
                                                <span class="badge bg-info">Approved</span>
                                            </c:when>
                                            <c:when test="${outboundRequest.status == 'InProgress'}">
                                                <span class="badge bg-primary">Picking In Progress</span>
                                            </c:when>
                                            <c:when test="${outboundRequest.status == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${outboundRequest.status == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <strong>Type:</strong>
                                                <p class="mb-0">
                                                    <c:choose>
                                                        <c:when test="${outboundRequest.type == 'Outbound'}">
                                                            <span class="badge bg-label-primary">Outbound</span>
                                                            <c:if test="${not empty outboundRequest.salesOrderId}">
                                                                <span class="text-muted">(Sales Order #${outboundRequest.salesOrderId})</span>
                                                            </c:if>
                                                        </c:when>
                                                        <c:when test="${outboundRequest.type == 'Internal'}">
                                                            <span class="badge bg-label-secondary">Internal</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-label-info">${outboundRequest.type}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <strong>Source Warehouse:</strong>
                                                <p class="mb-0">${sourceWarehouse.name}</p>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <strong>Created By:</strong>
                                                <p class="mb-0">${createdByUser.fullName}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <strong>Created Date:</strong>
                                                <p class="mb-0">
                                                    <c:if test="${not empty outboundRequest.createdAt}">
                                                        ${outboundRequest.createdAt.toLocalDate()} ${outboundRequest.createdAt.toLocalTime().toString().substring(0, 5)}
                                                    </c:if>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty outboundRequest.reason}">
                                            <div class="row mb-3">
                                                <div class="col-12">
                                                    <strong>Reason:</strong>
                                                    <p class="mb-0"><span class="badge bg-label-secondary">${outboundRequest.reason}</span></p>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty outboundRequest.notes}">
                                            <div class="row mb-3">
                                                <div class="col-12">
                                                    <strong>Notes:</strong>
                                                    <p class="mb-0">${outboundRequest.notes}</p>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${outboundRequest.status == 'Approved' || outboundRequest.status == 'InProgress' || outboundRequest.status == 'Completed'}">
                                            <hr />
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <strong>Approved By:</strong>
                                                    <p class="mb-0">
                                                        <c:choose>
                                                            <c:when test="${not empty approvedByUser}">
                                                                ${approvedByUser.fullName}
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Approved Date:</strong>
                                                    <p class="mb-0">
                                                        <c:if test="${not empty outboundRequest.approvedDate}">
                                                            ${outboundRequest.approvedDate.toLocalDate()} ${outboundRequest.approvedDate.toLocalTime().toString().substring(0, 5)}
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${outboundRequest.status == 'Rejected'}">
                                            <hr />
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <strong>Rejected By:</strong>
                                                    <p class="mb-0">
                                                        <c:choose>
                                                            <c:when test="${not empty rejectedByUser}">
                                                                ${rejectedByUser.fullName}
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Rejected Date:</strong>
                                                    <p class="mb-0">
                                                        <c:if test="${not empty outboundRequest.rejectedDate}">
                                                            ${outboundRequest.rejectedDate.toLocalDate()} ${outboundRequest.rejectedDate.toLocalTime().toString().substring(0, 5)}
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </div>
                                            <c:if test="${not empty outboundRequest.rejectionReason}">
                                                <div class="row">
                                                    <div class="col-12">
                                                        <strong>Rejection Reason:</strong>
                                                        <p class="mb-0 text-danger">${outboundRequest.rejectionReason}</p>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                        
                                        <c:if test="${outboundRequest.status == 'Completed'}">
                                            <hr />
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <strong>Completed By:</strong>
                                                    <p class="mb-0">
                                                        <c:choose>
                                                            <c:when test="${not empty completedByUser}">
                                                                ${completedByUser.fullName}
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Completed Date:</strong>
                                                    <p class="mb-0">
                                                        <c:if test="${not empty outboundRequest.completedDate}">
                                                            ${outboundRequest.completedDate.toLocalDate()} ${outboundRequest.completedDate.toLocalTime().toString().substring(0, 5)}
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Items Table -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Items</h5>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th class="text-center">Requested</th>
                                                    <th class="text-center">Picked</th>
                                                    <th class="text-center">Available</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${items}">
                                                    <tr>
                                                        <td>
                                                            <strong>${requestScope['productName_'.concat(item.productId)]}</strong>
                                                            <br />
                                                            <small class="text-muted">${requestScope['productSku_'.concat(item.productId)]}</small>
                                                        </td>
                                                        <td class="text-center">${item.quantity}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${outboundRequest.status == 'InProgress' || outboundRequest.status == 'Completed'}">
                                                                    ${item.pickedQuantity}
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:set var="available" value="${requestScope['available_'.concat(item.productId)]}" />
                                                            <c:choose>
                                                                <c:when test="${available >= item.quantity}">
                                                                    <span class="text-success">${available}</span>
                                                                </c:when>
                                                                <c:when test="${available > 0}">
                                                                    <span class="text-warning">${available}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-danger">${available != null ? available : 0}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${outboundRequest.status == 'Completed'}">
                                                                    <span class="badge bg-success">Picked</span>
                                                                </c:when>
                                                                <c:when test="${outboundRequest.status == 'InProgress' && item.pickedQuantity >= item.quantity}">
                                                                    <span class="badge bg-success">Complete</span>
                                                                </c:when>
                                                                <c:when test="${outboundRequest.status == 'InProgress' && item.pickedQuantity > 0}">
                                                                    <span class="badge bg-warning">Partial</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Pending</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Status Timeline -->
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Status Timeline</h5>
                                    </div>
                                    <div class="card-body">
                                        <ul class="timeline">
                                            <li class="timeline-item timeline-item-success pb-4">
                                                <span class="timeline-indicator timeline-indicator-success">
                                                    <i class="bx bx-plus-circle"></i>
                                                </span>
                                                <div class="timeline-event">
                                                    <div class="timeline-header">
                                                        <h6 class="mb-0">Created</h6>
                                                    </div>
                                                    <p class="mb-0 text-muted small">
                                                        <c:if test="${not empty outboundRequest.createdAt}">
                                                            ${outboundRequest.createdAt.toLocalDate()}
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </li>
                                            
                                            <c:choose>
                                                <c:when test="${outboundRequest.status == 'Rejected'}">
                                                    <li class="timeline-item timeline-item-danger pb-4">
                                                        <span class="timeline-indicator timeline-indicator-danger">
                                                            <i class="bx bx-x-circle"></i>
                                                        </span>
                                                        <div class="timeline-event">
                                                            <div class="timeline-header">
                                                                <h6 class="mb-0 text-danger">Rejected</h6>
                                                            </div>
                                                            <p class="mb-0 text-muted small">
                                                                <c:if test="${not empty outboundRequest.rejectedDate}">
                                                                    ${outboundRequest.rejectedDate.toLocalDate()}
                                                                </c:if>
                                                            </p>
                                                        </div>
                                                    </li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="timeline-item pb-4 ${outboundRequest.status == 'Created' ? 'timeline-item-transparent' : 'timeline-item-success'}">
                                                        <span class="timeline-indicator ${outboundRequest.status == 'Created' ? 'timeline-indicator-secondary' : 'timeline-indicator-success'}">
                                                            <i class="bx bx-check-circle"></i>
                                                        </span>
                                                        <div class="timeline-event">
                                                            <div class="timeline-header">
                                                                <h6 class="mb-0">Approved</h6>
                                                            </div>
                                                            <p class="mb-0 text-muted small">
                                                                <c:choose>
                                                                    <c:when test="${not empty outboundRequest.approvedDate}">
                                                                        ${outboundRequest.approvedDate.toLocalDate()}
                                                                    </c:when>
                                                                    <c:otherwise>Pending</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                        </div>
                                                    </li>
                                                    
                                                    <li class="timeline-item pb-4 ${outboundRequest.status == 'InProgress' || outboundRequest.status == 'Completed' ? 'timeline-item-success' : 'timeline-item-transparent'}">
                                                        <span class="timeline-indicator ${outboundRequest.status == 'InProgress' || outboundRequest.status == 'Completed' ? 'timeline-indicator-info' : 'timeline-indicator-secondary'}">
                                                            <i class="bx bx-loader"></i>
                                                        </span>
                                                        <div class="timeline-event">
                                                            <div class="timeline-header">
                                                                <h6 class="mb-0">In Progress</h6>
                                                            </div>
                                                            <p class="mb-0 text-muted small">
                                                                <c:choose>
                                                                    <c:when test="${outboundRequest.status == 'InProgress'}">Active</c:when>
                                                                    <c:when test="${outboundRequest.status == 'Completed'}">Done</c:when>
                                                                    <c:otherwise>Pending</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                        </div>
                                                    </li>
                                                    
                                                    <li class="timeline-item ${outboundRequest.status == 'Completed' ? 'timeline-item-success' : 'timeline-item-transparent'}">
                                                        <span class="timeline-indicator ${outboundRequest.status == 'Completed' ? 'timeline-indicator-success' : 'timeline-indicator-secondary'}">
                                                            <i class="bx bx-check-double"></i>
                                                        </span>
                                                        <div class="timeline-event">
                                                            <div class="timeline-header">
                                                                <h6 class="mb-0">Completed</h6>
                                                            </div>
                                                            <p class="mb-0 text-muted small">
                                                                <c:choose>
                                                                    <c:when test="${not empty outboundRequest.completedDate}">
                                                                        ${outboundRequest.completedDate.toLocalDate()}
                                                                    </c:when>
                                                                    <c:otherwise>Pending</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                        </div>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>
                                        </ul>
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
