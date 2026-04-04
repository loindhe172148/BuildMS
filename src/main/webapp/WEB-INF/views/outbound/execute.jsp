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
                                    <a href="${contextPath}/outbound?action=details&id=${outboundRequest.id}">Request #<c:out value="${outboundRequest.id}"/></a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Execute</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-package me-2"></i>Execute Outbound #<c:out value="${outboundRequest.id}"/>
                                </h4>
                                <p class="text-muted mb-0">Review inventory availability and confirm execution</p>
                            </div>
                            <a href="${contextPath}/outbound?action=details&id=${outboundRequest.id}" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to Details
                            </a>
                        </div>
                        
                        <!-- Request Info Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <span class="text-muted">Status:</span>
                                        <span class="badge bg-info ms-2">Ready to Execute</span>
                                    </div>
                                    <div class="col-md-4">
                                        <span class="text-muted">Source:</span>
                                        <strong class="ms-2"><c:out value="${not empty warehouse ? warehouse.name : 'N/A'}"/></strong>
                                    </div>
                                    <div class="col-md-4">
                                        <span class="text-muted">Reason:</span>
                                        <span class="badge bg-label-secondary ms-2">
                                            <c:choose>
                                                <c:when test="${not empty outboundRequest.reason}">${outboundRequest.reason}</c:when>
                                                <c:when test="${not empty outboundRequest.salesOrderId}">Sales Order</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Inventory Availability Summary -->
                        <div class="card mb-6">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="bx bx-check-shield me-2"></i>Inventory Availability Check</h5>
                            </div>
                            <div class="card-body">
                                <div class="alert ${allItemsAvailable ? 'alert-success' : 'alert-danger'} mb-4">
                                    <i class="bx ${allItemsAvailable ? 'bx-check-circle' : 'bx-error-circle'} me-2"></i>
                                    <c:choose>
                                        <c:when test="${allItemsAvailable}">
                                            <strong>All items are available.</strong> You can proceed with execution. Inventory will be deducted automatically.
                                        </c:when>
                                        <c:otherwise>
                                            <strong>Insufficient inventory.</strong> One or more items do not have enough stock. Resolve the shortages before executing.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Product</th>
                                                <th>SKU</th>
                                                <th class="text-center">Requested</th>
                                                <th class="text-center">Available</th>
                                                <th class="text-center">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${items}">
                                                <c:set var="productName" value="${requestScope['productName_'.concat(item.productId)]}" />
                                                <c:set var="productSku" value="${requestScope['productSku_'.concat(item.productId)]}" />
                                                <c:set var="productUnit" value="${requestScope['productUnit_'.concat(item.productId)]}" />
                                                <c:set var="available" value="${requestScope['available_'.concat(item.productId)]}" />
                                                <tr>
                                                    <td>
                                                        <strong><c:out value="${productName}"/></strong>
                                                    </td>
                                                    <td><code><c:out value="${productSku}"/></code></td>
                                                    <td class="text-center">
                                                        <c:out value="${item.quantity}"/>
                                                        <span class="text-muted"><c:out value="${productUnit}"/></span>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:out value="${available != null ? available : 0}"/>
                                                        <span class="text-muted"><c:out value="${productUnit}"/></span>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${available >= item.quantity}">
                                                                <span class="badge bg-success">
                                                                    <i class="bx bx-check me-1"></i>Sufficient
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">
                                                                    <i class="bx bx-x me-1"></i>Insufficient
                                                                </span>
                                                                <br>
                                                                <small class="text-danger">
                                                                    Short by <c:out value="${item.quantity - (available != null ? available : 0)}"/>
                                                                </small>
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
                        
                        <!-- Execute Button -->
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1">Confirm & Execute</h6>
                                        <c:choose>
                                            <c:when test="${allItemsAvailable}">
                                                <p class="text-muted mb-0">
                                                    This will deduct inventory and mark the request as completed. This action cannot be undone.
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-danger mb-0">
                                                    <i class="bx bx-error-circle me-1"></i>
                                                    Cannot execute — resolve inventory shortages first.
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:choose>
                                        <c:when test="${allItemsAvailable}">
                                            <form action="${contextPath}/outbound" method="post"
                                                  onsubmit="return confirm('Execute this outbound request? Inventory will be deducted. This cannot be undone.');">
                                                <input type="hidden" name="action" value="start" />
                                                <input type="hidden" name="id" value="${outboundRequest.id}" />
                                                <button type="submit" class="btn btn-success btn-lg">
                                                    <i class="bx bx-check-double me-1"></i>Confirm & Execute
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-success btn-lg" disabled
                                                    title="Resolve inventory shortages before executing">
                                                <i class="bx bx-check-double me-1"></i>Confirm & Execute
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
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
</body>
</html>
