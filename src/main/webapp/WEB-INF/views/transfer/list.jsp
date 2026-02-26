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
        <jsp:param name="pageTitle" value="Transfer Requests" />
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
                                <li class="breadcrumb-item active" aria-current="page">Transfer Requests</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${param.success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0">
                                <i class="bx bx-transfer me-2"></i>Transfer Requests
                            </h4>
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                <a href="${contextPath}/transfer?action=create" class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i> Create Transfer
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form method="get" action="${contextPath}/transfer" class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Status</label>
                                        <select name="status" class="form-select">
                                            <option value="">All Status</option>
                                            <option value="Created" ${selectedStatus == 'Created' ? 'selected' : ''}>Created</option>
                                            <option value="Approved" ${selectedStatus == 'Approved' ? 'selected' : ''}>Approved</option>
                                            <option value="InProgress" ${selectedStatus == 'InProgress' ? 'selected' : ''}>Outbound In Progress</option>
                                            <option value="InTransit" ${selectedStatus == 'InTransit' ? 'selected' : ''}>In Transit</option>
                                            <option value="Receiving" ${selectedStatus == 'Receiving' ? 'selected' : ''}>Receiving</option>
                                            <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-outline-primary">
                                            <i class="bx bx-filter-alt me-1"></i> Filter
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Transfers Table -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Transfer Request List</h5>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Source Warehouse</th>
                                            <th>Destination Warehouse</th>
                                            <th>Status</th>
                                            <th>Created By</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty transfers}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-4">
                                                        <i class="bx bx-info-circle me-1"></i> No transfer requests found
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="data" items="${transfers}">
                                                    <tr>
                                                        <td><strong>#${data.request.id}</strong></td>
                                                        <td>
                                                            <c:if test="${not empty data.sourceWarehouse}">
                                                                ${data.sourceWarehouse.name}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty data.destinationWarehouse}">
                                                                ${data.destinationWarehouse.name}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${data.request.status == 'Created'}">
                                                                    <span class="badge bg-label-secondary">Created</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'Approved'}">
                                                                    <span class="badge bg-label-info">Approved</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'InProgress'}">
                                                                    <span class="badge bg-label-warning">Picking</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'InTransit'}">
                                                                    <span class="badge bg-label-primary">In Transit</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'Receiving'}">
                                                                    <span class="badge bg-label-warning">Receiving</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'Completed'}">
                                                                    <span class="badge bg-label-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${data.request.status == 'Rejected'}">
                                                                    <span class="badge bg-label-danger">Rejected</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-label-secondary">${data.request.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty data.creator}">
                                                                ${data.creator.fullName}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:parseDate value="${data.request.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <div class="dropdown">
                                                                <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown" aria-label="More actions">
                                                                    <i class="bx bx-dots-vertical-rounded" aria-hidden="true"></i>
                                                                </button>
                                                                <div class="dropdown-menu">
                                                                    <a class="dropdown-item" href="${contextPath}/transfer?action=view&id=${data.request.id}">
                                                                        <i class="bx bx-show me-1"></i> View Details
                                                                    </a>
                                                                    
                                                                    <c:if test="${data.request.status == 'Created' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                                                        <form action="${contextPath}/transfer" method="post" style="display: inline;">
                                                                            <input type="hidden" name="action" value="approve">
                                                                            <input type="hidden" name="id" value="${data.request.id}">
                                                                            <button type="submit" class="dropdown-item">
                                                                                <i class="bx bx-check-circle me-1"></i> Approve
                                                                            </button>
                                                                        </form>
                                                                    </c:if>
                                                                    
                                                                    <c:if test="${data.request.status == 'Approved' || data.request.status == 'InProgress'}">
                                                                        <a class="dropdown-item" href="${contextPath}/transfer?action=execute-outbound&id=${data.request.id}">
                                                                            <i class="bx bx-export me-1"></i> Execute Outbound
                                                                        </a>
                                                                    </c:if>
                                                                    
                                                                    <c:if test="${data.request.status == 'InTransit' || data.request.status == 'Receiving'}">
                                                                        <a class="dropdown-item" href="${contextPath}/transfer?action=execute-inbound&id=${data.request.id}">
                                                                            <i class="bx bx-import me-1"></i> Execute Inbound
                                                                        </a>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
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
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
