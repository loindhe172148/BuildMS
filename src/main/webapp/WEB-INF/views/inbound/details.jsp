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
        <jsp:param name="pageTitle" value="Inbound Request Details" />
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
                                <li class="breadcrumb-item active" aria-current="page">Request #${inboundRequest.id}</li>
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
                                    <i class="bx bx-download me-2"></i>Inbound Request #${inboundRequest.id}
                                </h4>
                                <c:choose>
                                    <c:when test="${inboundRequest.status == 'Created'}">
                                        <span class="badge bg-warning fs-6">Pending Approval</span>
                                    </c:when>
                                    <c:when test="${inboundRequest.status == 'Approved'}">
                                        <span class="badge bg-info fs-6">Approved</span>
                                    </c:when>
                                    <c:when test="${inboundRequest.status == 'InProgress'}">
                                        <span class="badge bg-primary fs-6">In Progress</span>
                                    </c:when>
                                    <c:when test="${inboundRequest.status == 'Completed'}">
                                        <span class="badge bg-success fs-6">Completed</span>
                                    </c:when>
                                    <c:when test="${inboundRequest.status == 'Rejected'}">
                                        <span class="badge bg-danger fs-6">Rejected</span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div>
                                <a href="${contextPath}/inbound" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i>Back to List
                                </a>
                                
                                <c:if test="${inboundRequest.status == 'Approved' || inboundRequest.status == 'InProgress'}">
                                    <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Staff'}">
                                        <a href="${contextPath}/inbound?action=execute&id=${inboundRequest.id}" class="btn btn-warning">
                                            <i class="bx bx-play me-1"></i>Execute
                                        </a>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Request Info -->
                            <div class="col-md-8">
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h5 class="mb-0">Request Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label text-muted">Request ID</label>
                                                <p class="mb-0 fw-semibold">#${inboundRequest.id}</p>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label text-muted">Type</label>
                                                <p class="mb-0 fw-semibold">${inboundRequest.type}</p>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label text-muted">Destination Warehouse</label>
                                                <p class="mb-0 fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty warehouse}">
                                                            ${warehouse.name}
                                                            <c:if test="${not empty warehouse.location}">
                                                                <br/><small class="text-muted">${warehouse.location}</small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label text-muted">Expected Date</label>
                                                <p class="mb-0 fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty inboundRequest.expectedDate}">
                                                            ${inboundRequest.expectedDate.toLocalDate()}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-12 mb-3">
                                                <label class="form-label text-muted">Notes</label>
                                                <p class="mb-0">
                                                    <c:choose>
                                                        <c:when test="${not empty inboundRequest.notes}">
                                                            ${inboundRequest.notes}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">No notes</span></c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Items -->
                                <div class="card mb-6">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Request Items</h5>
                                        <span class="badge bg-primary">${items.size()} items</span>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>SKU</th>
                                                    <th class="text-center">Expected Qty</th>
                                                    <th class="text-center">Received Qty</th>
                                                    <th>Target Location</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${items}">
                                                    <tr>
                                                        <td>
                                                            <strong>${requestScope['productName_'.concat(item.productId)]}</strong>
                                                        </td>
                                                        <td>
                                                            <span class="text-muted">${requestScope['productSku_'.concat(item.productId)]}</span>
                                                        </td>
                                                        <td class="text-center">${item.quantity}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${not empty item.receivedQuantity}">
                                                                    <c:choose>
                                                                        <c:when test="${item.receivedQuantity == item.quantity}">
                                                                            <span class="text-success">${item.receivedQuantity}</span>
                                                                        </c:when>
                                                                        <c:when test="${item.receivedQuantity < item.quantity}">
                                                                            <span class="text-warning">${item.receivedQuantity}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-info">${item.receivedQuantity}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty item.locationId}">
                                                                    ${requestScope['locationCode_'.concat(item.locationId)]}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Approval Actions (for Created status) -->
                                <c:if test="${inboundRequest.status == 'Created' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">Approval Actions</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <form action="${contextPath}/inbound" method="post">
                                                        <input type="hidden" name="action" value="approve" />
                                                        <input type="hidden" name="id" value="${inboundRequest.id}" />
                                                        <button type="submit" class="btn btn-success btn-lg w-100" 
                                                                onclick="return confirm('Approve this inbound request?')">
                                                            <i class="bx bx-check-circle me-2"></i>Approve Request
                                                        </button>
                                                    </form>
                                                </div>
                                                <div class="col-md-6">
                                                    <button type="button" class="btn btn-danger btn-lg w-100" 
                                                            data-bs-toggle="modal" data-bs-target="#rejectModal">
                                                        <i class="bx bx-x-circle me-2"></i>Reject Request
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Rejection Info (for Rejected status) -->
                                <c:if test="${inboundRequest.status == 'Rejected'}">
                                    <div class="card border-danger">
                                        <div class="card-header bg-danger text-white">
                                            <h5 class="mb-0"><i class="bx bx-x-circle me-2"></i>Request Rejected</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <label class="form-label text-muted">Rejected By</label>
                                                <p class="mb-0 fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty rejectedByUser}">${rejectedByUser.name}</c:when>
                                                        <c:otherwise>User #${inboundRequest.rejectedBy}</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label text-muted">Rejected Date</label>
                                                <p class="mb-0">${inboundRequest.rejectedDate.toLocalDate()}</p>
                                            </div>
                                            <div>
                                                <label class="form-label text-muted">Reason</label>
                                                <p class="mb-0 text-danger">${inboundRequest.rejectionReason}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            
                            <!-- Status Timeline -->
                            <div class="col-md-4">
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="bx bx-history me-2"></i>Status Timeline</h6>
                                    </div>
                                    <div class="card-body">
                                        <ul class="timeline mb-0">
                                            <li class="timeline-item timeline-item-transparent">
                                                <span class="timeline-point timeline-point-warning"></span>
                                                <div class="timeline-event">
                                                    <div class="timeline-header mb-1">
                                                        <h6 class="mb-0">Created</h6>
                                                    </div>
                                                    <p class="mb-0 text-muted small">
                                                        By: <c:choose>
                                                            <c:when test="${not empty createdByUser}">${createdByUser.name}</c:when>
                                                            <c:otherwise>User #${inboundRequest.createdBy}</c:otherwise>
                                                        </c:choose>
                                                        <br/>
                                                        ${inboundRequest.createdAt.toLocalDate()} ${inboundRequest.createdAt.toLocalTime().withNano(0)}
                                                    </p>
                                                </div>
                                            </li>
                                            
                                            <c:if test="${not empty inboundRequest.approvedBy}">
                                                <li class="timeline-item timeline-item-transparent">
                                                    <span class="timeline-point timeline-point-info"></span>
                                                    <div class="timeline-event">
                                                        <div class="timeline-header mb-1">
                                                            <h6 class="mb-0">Approved</h6>
                                                        </div>
                                                        <p class="mb-0 text-muted small">
                                                            By: <c:choose>
                                                                <c:when test="${not empty approvedByUser}">${approvedByUser.name}</c:when>
                                                                <c:otherwise>User #${inboundRequest.approvedBy}</c:otherwise>
                                                            </c:choose>
                                                            <br/>
                                                            <c:if test="${not empty inboundRequest.approvedDate}">
                                                                ${inboundRequest.approvedDate.toLocalDate()} ${inboundRequest.approvedDate.toLocalTime().withNano(0)}
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </li>
                                            </c:if>
                                            
                                            <c:if test="${inboundRequest.status == 'InProgress'}">
                                                <li class="timeline-item timeline-item-transparent">
                                                    <span class="timeline-point timeline-point-primary"></span>
                                                    <div class="timeline-event">
                                                        <div class="timeline-header mb-1">
                                                            <h6 class="mb-0">In Progress</h6>
                                                        </div>
                                                        <p class="mb-0 text-muted small">Execution started</p>
                                                    </div>
                                                </li>
                                            </c:if>
                                            
                                            <c:if test="${not empty inboundRequest.completedBy}">
                                                <li class="timeline-item timeline-item-transparent">
                                                    <span class="timeline-point timeline-point-success"></span>
                                                    <div class="timeline-event">
                                                        <div class="timeline-header mb-1">
                                                            <h6 class="mb-0">Completed</h6>
                                                        </div>
                                                        <p class="mb-0 text-muted small">
                                                            By: <c:choose>
                                                                <c:when test="${not empty completedByUser}">${completedByUser.name}</c:when>
                                                                <c:otherwise>User #${inboundRequest.completedBy}</c:otherwise>
                                                            </c:choose>
                                                            <br/>
                                                            <c:if test="${not empty inboundRequest.completedDate}">
                                                                ${inboundRequest.completedDate.toLocalDate()} ${inboundRequest.completedDate.toLocalTime().withNano(0)}
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </li>
                                            </c:if>
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
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${contextPath}/inbound" method="post">
                    <input type="hidden" name="action" value="reject" />
                    <input type="hidden" name="id" value="${inboundRequest.id}" />
                    <div class="modal-header">
                        <h5 class="modal-title">Reject Request</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="reason" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="reason" name="reason" rows="4" required 
                                      placeholder="Please provide a reason for rejection..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bx bx-x-circle me-1"></i>Reject
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
