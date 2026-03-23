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
        <jsp:param name="pageTitle" value="Execute Outbound Transfer" />
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
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/transfer?action=view&id=${transfer.id}">${transfer.requestNumber}</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Execute Outbound</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-export me-2"></i>Execute Outbound: ${transfer.requestNumber}
                                </h4>
                                <p class="text-muted mb-0">Pick items from source warehouse for transfer</p>
                            </div>
                            <a href="${contextPath}/transfer?action=view&id=${transfer.id}" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i> Back to Transfer
                            </a>
                        </div>
                        
                        <!-- Transfer Summary -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="rounded-circle bg-label-danger p-3 me-3">
                                                <i class="bx bx-export fs-3"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Source Warehouse</h6>
                                                <h5 class="mb-0">${sourceWarehouse.name}</h5>
                                                <small class="text-muted">${sourceWarehouse.code}</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="rounded-circle bg-label-success p-3 me-3">
                                                <i class="bx bx-import fs-3"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Destination Warehouse</h6>
                                                <h5 class="mb-0">${destinationWarehouse.name}</h5>
                                                <small class="text-muted">${destinationWarehouse.code}</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Status-based Content -->
                        <c:choose>
                            <c:when test="${transfer.status == 'Approved'}">
                                <!-- Start Outbound -->
                                <div class="card">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0"><i class="bx bx-play me-2"></i>Start Outbound Picking</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="alert alert-info mb-4">
                                            <i class="bx bx-info-circle me-2"></i>
                                            Starting the outbound process will mark this transfer as "In Progress". 
                                            Review the items below and ensure all are available for picking.
                                        </div>
                                        
                                        <!-- Availability Check -->
                                        <h6 class="mb-3">Inventory Availability</h6>
                                        <div class="table-responsive mb-4">
                                            <table class="table table-bordered">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Product</th>
                                                        <th>SKU</th>
                                                        <th class="text-center">Required</th>
                                                        <th class="text-center">Available</th>
                                                        <th class="text-center">Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:set var="allAvailable" value="true" />
                                                    <c:forEach var="check" items="${availabilityCheck}">
                                                        <c:set var="item" value="${check.item}" />
                                                        <c:set var="available" value="${check.available}" />
                                                        <c:if test="${available < item.quantity}">
                                                            <c:set var="allAvailable" value="false" />
                                                        </c:if>
                                                        <tr>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty item.product}">${item.product.name}</c:when>
                                                                    <c:otherwise>Product #${item.productId}</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><code>${item.product.sku}</code></td>
                                                            <td class="text-center">${item.quantity}</td>
                                                            <td class="text-center">${available}</td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${available >= item.quantity}">
                                                                        <span class="badge bg-success">
                                                                            <i class="bx bx-check"></i> Available
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-danger">
                                                                            <i class="bx bx-x"></i> Insufficient
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        
                                        <c:choose>
                                            <c:when test="${allAvailable}">
                                                <form method="post" action="${contextPath}/transfer">
                                                    <input type="hidden" name="action" value="start-outbound">
                                                    <input type="hidden" name="id" value="${transfer.id}">
                                                    <div class="text-end">
                                                        <button type="submit" class="btn btn-primary btn-lg">
                                                            <i class="bx bx-play me-1"></i> Start Outbound
                                                        </button>
                                                    </div>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-danger">
                                                    <i class="bx bx-error-circle me-2"></i>
                                                    <strong>Cannot start outbound:</strong> Some items have insufficient inventory at the source warehouse.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:when>
                            
                            <c:when test="${transfer.status == 'InProgress'}">
                                <!-- Complete Outbound - Pick Items -->
                                <form method="post" action="${contextPath}/transfer" id="pickForm">
                                    <input type="hidden" name="action" value="complete-outbound">
                                    <input type="hidden" name="id" value="${transfer.id}">
                                    
                                    <div class="card">
                                        <div class="card-header bg-info text-white">
                                            <h5 class="mb-0"><i class="bx bx-check-circle me-2"></i>Complete Picking</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="alert alert-warning mb-4">
                                                <i class="bx bx-info-circle me-2"></i>
                                                Enter the actual quantities picked for each item. The picked quantities will be deducted from inventory.
                                            </div>
                                            
                                            <div class="table-responsive mb-4">
                                                <table class="table table-bordered">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>SKU</th>
                                                            <th class="text-center">Requested</th>
                                                            <th class="text-center">Available</th>
                                                            <th class="text-center" style="width: 150px;">Picked Qty</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="check" items="${availabilityCheck}" varStatus="status">
                                                            <c:set var="item" value="${check.item}" />
                                                            <c:set var="available" value="${check.available}" />
                                                            <tr>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.product}">${item.product.name}</c:when>
                                                                        <c:otherwise>Product #${item.productId}</c:otherwise>
                                                                    </c:choose>
                                                                    <input type="hidden" name="itemId[]" value="${item.id}">
                                                                </td>
                                                                <td><code>${item.product.sku}</code></td>
                                                                <td class="text-center">${item.quantity}</td>
                                                                <td class="text-center">${available}</td>
                                                                <td class="text-center">
                                                                    <input type="number" name="pickedQty[]" 
                                                                           class="form-control form-control-sm text-center"
                                                                           value="${item.quantity <= available ? item.quantity : available}"
                                                                           min="0" max="${available}" required>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            
                                            <div class="text-end">
                                                <button type="submit" class="btn btn-success btn-lg">
                                                    <i class="bx bx-check-double me-1"></i> Complete Outbound
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </c:when>
                            
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="bx bx-info-circle me-2"></i>
                                    This transfer is not in a state that requires outbound execution.
                                    Current status: <strong>${transfer.status}</strong>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
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
