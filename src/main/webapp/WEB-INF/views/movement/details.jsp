<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
                                <li class="breadcrumb-item active" aria-current="page">Details #<c:out value="${movementRequest.id}"/></li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                <c:out value="${sessionScope.successMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                <c:out value="${sessionScope.errorMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-transfer me-2"></i>Movement #<c:out value="${movementRequest.id}"/>
                            </h4>
                            <div>
                                <a href="${contextPath}/movement" class="btn btn-outline-secondary me-2">
                                    <i class="bx bx-arrow-back me-1"></i>Back to List
                                </a>
                                <%-- Approve/Reject buttons: Admin/Manager, status = Created --%>
                                <c:if test="${(currentUser.role == 'Admin' || currentUser.role == 'Manager') && movementRequest.status == 'Created'}">
                                    <form action="${contextPath}/movement" method="post" class="d-inline me-2">
                                        <input type="hidden" name="action" value="approve" />
                                        <input type="hidden" name="id" value="${movementRequest.id}" />
                                        <button type="submit" class="btn btn-success"
                                                onclick="return confirm('Approve this movement request?')">
                                            <i class="bx bx-check me-1"></i>Approve
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-danger me-2"
                                            data-bs-toggle="modal" data-bs-target="#rejectModal">
                                        <i class="bx bx-x me-1"></i>Reject
                                    </button>
                                </c:if>
                                <c:if test="${movementRequest.status == 'Approved'}">
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
                                        <p class="fw-bold">#<c:out value="${movementRequest.id}"/></p>
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
                                            <c:when test="${movementRequest.status == 'Approved'}">
                                                <span class="badge bg-success">Approved</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'InProgress'}">
                                                <span class="badge bg-info">In Progress</span>
                                            </c:when>
                                            <c:when test="${movementRequest.status == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><c:out value="${movementRequest.status}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Warehouse</p>
                                        <p class="fw-bold">
                                            <i class="bx bx-building-house me-1"></i><c:out value="${warehouse.name}"/>
                                        </p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Created By</p>
                                        <p class="fw-bold"><c:out value="${createdByUser.name}"/></p>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <p class="text-muted mb-1">Created Date</p>
                                        <p class="fw-bold">
                                            <c:if test="${not empty movementRequest.createdAt}">
                                                <c:out value="${movementRequest.createdAt.toLocalDate()}"/> <c:out value="${movementRequest.createdAt.toLocalTime().toString().substring(0, 5)}"/>
                                            </c:if>
                                        </p>
                                    </div>
                                    <!-- Approved by info -->
                                    <c:if test="${movementRequest.status == 'Approved' and not empty approvedByUser}">
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Approved By</p>
                                            <p class="fw-bold"><c:out value="${approvedByUser.name}"/></p>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Approved Date</p>
                                            <p class="fw-bold">
                                                <c:if test="${not empty movementRequest.approvedDate}">
                                                    <c:out value="${movementRequest.approvedDate.toLocalDate()}"/> <c:out value="${movementRequest.approvedDate.toLocalTime().toString().substring(0, 5)}"/>
                                                </c:if>
                                            </p>
                                        </div>
                                    </c:if>
                                    <!-- Rejected by info -->
                                    <c:if test="${movementRequest.status == 'Rejected' and not empty rejectedByUser}">
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Rejected By</p>
                                            <p class="fw-bold"><c:out value="${rejectedByUser.name}"/></p>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Rejected Date</p>
                                            <p class="fw-bold">
                                                <c:if test="${not empty movementRequest.rejectedDate}">
                                                    <c:out value="${movementRequest.rejectedDate.toLocalDate()}"/> <c:out value="${movementRequest.rejectedDate.toLocalTime().toString().substring(0, 5)}"/>
                                                </c:if>
                                            </p>
                                        </div>
                                    </c:if>
                                    <!-- Completed by info -->
                                    <c:if test="${movementRequest.status == 'Completed' and not empty completedByUser}">
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Completed By</p>
                                            <p class="fw-bold"><c:out value="${completedByUser.name}"/></p>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <p class="text-muted mb-1">Completed Date</p>
                                            <p class="fw-bold">
                                                <c:if test="${not empty movementRequest.completedDate}">
                                                    <c:out value="${movementRequest.completedDate.toLocalDate()}"/> <c:out value="${movementRequest.completedDate.toLocalTime().toString().substring(0, 5)}"/>
                                                </c:if>
                                            </p>
                                        </div>
                                    </c:if>
                                </div>
                                <c:if test="${not empty movementRequest.notes}">
                                    <div class="row">
                                        <div class="col-12">
                                            <p class="text-muted mb-1">Notes</p>
                                            <p><c:out value="${movementRequest.notes}"/></p>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${movementRequest.status == 'Rejected' and not empty movementRequest.rejectionReason}">
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="alert alert-danger mb-0">
                                                <strong><i class="bx bx-x-circle me-1"></i>Rejection Reason:</strong>
                                                <c:out value="${movementRequest.rejectionReason}"/>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Movement Items -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Movement Items</h5>
                                <span class="badge bg-primary">${fn:length(itemsWithDetails)} items</span>
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
                                                        <strong><c:out value="${product.sku}"/></strong>
                                                    </a>
                                                    <br><small class="text-muted"><c:out value="${product.name}"/></small>
                                                </td>
                                                <td>
                                                    <i class="bx bx-log-out-circle text-danger me-1"></i>
                                                    <c:out value="${srcLoc.code}"/>
                                                    <span class="text-muted">(<c:out value="${srcLoc.type}"/>)</span>
                                                </td>
                                                <td>
                                                    <i class="bx bx-log-in-circle text-success me-1"></i>
                                                    <c:out value="${destLoc.code}"/>
                                                    <span class="text-muted">(<c:out value="${destLoc.type}"/>)</span>
                                                </td>
                                                <td>
                                                    <span class="fw-bold"><c:out value="${item.quantity}"/></span>
                                                    <span class="text-muted"><c:out value="${product.unit}"/></span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                    </main>
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

    <%-- Reject Modal --%>
    <c:if test="${(currentUser.role == 'Admin' || currentUser.role == 'Manager') && movementRequest.status == 'Created'}">
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rejectModalLabel">
                        <i class="bx bx-x-circle text-danger me-1"></i>Reject Movement Request #<c:out value="${movementRequest.id}"/>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${contextPath}/movement" method="post">
                    <input type="hidden" name="action" value="reject" />
                    <input type="hidden" name="id" value="${movementRequest.id}" />
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="rejectReason" class="form-label fw-bold">Rejection Reason <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="rejectReason" name="reason" rows="4"
                                      placeholder="Enter the reason for rejection..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bx bx-x me-1"></i>Confirm Rejection
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </c:if>
</body>
</html>
