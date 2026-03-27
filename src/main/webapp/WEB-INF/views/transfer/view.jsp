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
                                <li class="breadcrumb-item active" aria-current="page">#<c:out value="${transfer.id}"/></li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-transfer me-2"></i>Transfer #<c:out value="${transfer.id}"/>
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
                                    <c:out value="${transfer.status}"/>
                                </span>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${contextPath}/transfer" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i> Back to List
                                </a>
                                
                                <!-- Approve/Reject: only dest WH Manager or Admin, Status = Created -->
                                <c:if test="${transfer.status == 'Created' && (isAdmin || (isAtDestWH && currentUser.role == 'Manager'))}">
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
                                
                                <!-- Execute Outbound: only source WH Staff/Manager or Admin, Status = Approved -->
                                <c:if test="${transfer.status == 'Approved' && (isAdmin || isAtSourceWH)}">
                                    <a href="${contextPath}/transfer?action=execute-outbound&id=${transfer.id}" class="btn btn-primary">
                                        <i class="bx bx-play me-1"></i> Execute Outbound
                                    </a>
                                </c:if>
                                
                                <!-- Continue Outbound: only source WH Staff/Manager or Admin, Status = InProgress -->
                                <c:if test="${transfer.status == 'InProgress' && (isAdmin || isAtSourceWH)}">
                                    <a href="${contextPath}/transfer?action=execute-outbound&id=${transfer.id}" class="btn btn-info">
                                        <i class="bx bx-check-circle me-1"></i> Complete Outbound
                                    </a>
                                </c:if>
                                
                                <!-- Execute Inbound: only dest WH Staff/Manager or Admin, Status = InTransit -->
                                <c:if test="${transfer.status == 'InTransit' && (isAdmin || isAtDestWH)}">
                                    <a href="${contextPath}/transfer?action=execute-inbound&id=${transfer.id}" class="btn btn-primary">
                                        <i class="bx bx-download me-1"></i> Execute Inbound
                                    </a>
                                </c:if>
                                
                                <!-- Complete Inbound: only dest WH Staff/Manager or Admin, Status = Receiving -->
                                <c:if test="${transfer.status == 'Receiving' && (isAdmin || isAtDestWH)}">
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
                                                <th class="ps-0" width="40%">Request ID:</th>
                                                <td><strong>#<c:out value="${transfer.id}"/></strong></td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Type:</th>
                                                <td><span class="badge bg-label-info"><c:out value="${transfer.type}"/></span></td>
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
                                                        <c:out value="${transfer.status}"/>
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Created By:</th>
                                                <td><c:out value="${not empty creator ? creator.fullName : 'Unknown'}"/></td>
                                            </tr>
                                            <tr>
                                                <th class="ps-0">Created At:</th>
                                                <td>
                                                    <c:if test="${not empty transfer.createdAt}">
                                                        <c:out value="${transfer.createdAt.toLocalDate()}"/> <c:out value="${transfer.createdAt.toLocalTime().toString().substring(0, 5)}"/>
                                                    </c:if>
                                                </td>
                                            </tr>
                                            <c:if test="${not empty transfer.notes}">
                                                <tr>
                                                    <th class="ps-0">Notes:</th>
                                                    <td><c:out value="${transfer.notes}"/></td>
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
                                                    <strong><c:out value="${not empty sourceWarehouse ? sourceWarehouse.name : 'N/A'}"/></strong>
                                                    <br>
                                                    <small class="text-muted"><c:out value="${not empty sourceWarehouse ? sourceWarehouse.location : ''}"/></small>
                                                </div>
                                            </div>
                                            <div class="col-2 d-flex align-items-center justify-content-center">
                                                <i class="bx bx-right-arrow-alt fs-1 text-primary"></i>
                                            </div>
                                            <div class="col-5 text-center">
                                                <div class="border rounded p-3 bg-light">
                                                    <i class="bx bx-import fs-1 text-success mb-2"></i>
                                                    <h6 class="text-muted mb-1">Destination</h6>
                                                    <strong><c:out value="${not empty destinationWarehouse ? destinationWarehouse.name : 'N/A'}"/></strong>
                                                    <br>
                                                    <small class="text-muted"><c:out value="${not empty destinationWarehouse ? destinationWarehouse.location : ''}"/></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Workflow Progress -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="bx bx-git-branch me-2"></i>Transfer Workflow</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center text-center">
                                    <%-- Step 1: Created --%>
                                    <div class="flex-fill">
                                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center 
                                            ${transfer.status != 'Rejected' ? 'bg-success' : 'bg-success'} text-white" 
                                            style="width:40px;height:40px;">
                                            <i class="bx bx-check"></i>
                                        </div>
                                        <div class="mt-1"><small><strong>Created</strong></small></div>
                                        <div><small class="text-muted">Source WH</small></div>
                                    </div>
                                    <div class="flex-fill pt-0"><hr></div>
                                    <%-- Step 2: Approved by Dest WH --%>
                                    <div class="flex-fill">
                                        <c:choose>
                                            <c:when test="${transfer.status == 'Rejected'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-danger text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-x"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Rejected</strong></small></div>
                                            </c:when>
                                            <c:when test="${transfer.status == 'Created'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-warning text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-time"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Pending Approval</strong></small></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-success text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-check"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Approved</strong></small></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div><small class="text-muted">Dest WH Manager</small></div>
                                    </div>
                                    <div class="flex-fill pt-0"><hr></div>
                                    <%-- Step 3: Outbound by Source WH --%>
                                    <div class="flex-fill">
                                        <c:choose>
                                            <c:when test="${transfer.status == 'InTransit' || transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-success text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-check"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Outbound Done</strong></small></div>
                                            </c:when>
                                            <c:when test="${transfer.status == 'InProgress'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-info text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-loader-alt bx-spin"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Picking...</strong></small></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-secondary text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-minus"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Outbound</strong></small></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div><small class="text-muted">Source WH</small></div>
                                    </div>
                                    <div class="flex-fill pt-0"><hr></div>
                                    <%-- Step 4: Inbound & Complete by Dest WH --%>
                                    <div class="flex-fill">
                                        <c:choose>
                                            <c:when test="${transfer.status == 'Completed'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-success text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-check-double"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Completed</strong></small></div>
                                            </c:when>
                                            <c:when test="${transfer.status == 'Receiving'}">
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-info text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-loader-alt bx-spin"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Receiving...</strong></small></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-secondary text-white" style="width:40px;height:40px;">
                                                    <i class="bx bx-minus"></i>
                                                </div>
                                                <div class="mt-1"><small><strong>Inbound</strong></small></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div><small class="text-muted">Dest WH</small></div>
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
                                        <c:forEach var="data" items="${items}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty data.product}">
                                                            <c:out value="${data.product.name}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Product #<c:out value="${data.item.productId}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty data.product}">
                                                        <code><c:out value="${data.product.sku}"/></code>
                                                    </c:if>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-label-primary"><c:out value="${data.item.quantity}"/></span>
                                                    <c:if test="${not empty data.product}"><span class="text-muted small"><c:out value="${data.product.unit}"/></span></c:if>
                                                </td>
                                                <c:if test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <td class="text-center">
                                                        <span class="badge bg-label-info"><c:out value="${data.item.pickedQuantity != null ? data.item.pickedQuantity : 0}"/></span>
                                                        <c:if test="${not empty data.product}"><span class="text-muted small"><c:out value="${data.product.unit}"/></span></c:if>
                                                    </td>
                                                </c:if>
                                                <c:if test="${transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <td class="text-center">
                                                        <span class="badge bg-label-success"><c:out value="${data.item.receivedQuantity != null ? data.item.receivedQuantity : 0}"/></span>
                                                        <c:if test="${not empty data.product}"><span class="text-muted small"><c:out value="${data.product.unit}"/></span></c:if>
                                                    </td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty items}">
                                            <tr>
                                                <c:set var="colCount" value="4" />
                                                <c:if test="${transfer.status == 'InProgress' || transfer.status == 'InTransit' || transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <c:set var="colCount" value="${colCount + 1}" />
                                                </c:if>
                                                <c:if test="${transfer.status == 'Receiving' || transfer.status == 'Completed'}">
                                                    <c:set var="colCount" value="${colCount + 1}" />
                                                </c:if>
                                                <td colspan="${colCount}" class="text-center text-muted py-4">
                                                    No items in this transfer.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Rejection Info -->
                        <c:if test="${transfer.status == 'Rejected' && not empty transfer.rejectionReason}">
                            <div class="card mt-4">
                                <div class="card-header bg-danger text-white">
                                    <h5 class="mb-0"><i class="bx bx-x-circle me-2"></i>Rejection Details</h5>
                                </div>
                                <div class="card-body">
                                    <p class="mb-0"><strong>Reason:</strong> <c:out value="${transfer.rejectionReason}"/></p>
                                </div>
                            </div>
                        </c:if>
                        
                    </main>
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
    
    <!-- Reject Modal — only rendered when user can approve/reject -->
    <c:if test="${transfer.status == 'Created' && (isAdmin || (isAtDestWH && currentUser.role == 'Manager'))}">
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
                        <p class="text-muted mb-3">
                            As the destination warehouse manager, you are rejecting this incoming transfer 
                            from <strong><c:out value="${not empty sourceWarehouse ? sourceWarehouse.name : 'source'}"/></strong>.
                        </p>
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
    </c:if>
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
