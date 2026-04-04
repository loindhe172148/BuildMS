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
        <jsp:param name="pageTitle" value="Execute Movement" />
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
                                <li class="breadcrumb-item active" aria-current="page">Execute #<c:out value="${movementRequest.id}"/></li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-play-circle me-2"></i>Execute Movement #<c:out value="${movementRequest.id}"/>
                                </h4>
                                <p class="text-muted mb-0">Review inventory and confirm movement execution</p>
                            </div>
                            <a href="${contextPath}/movement?action=details&id=${movementRequest.id}" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to Details
                            </a>
                        </div>
                        
                        <!-- Status Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar avatar-lg me-3 rounded bg-label-primary">
                                                <i class="bx bx-transfer bx-lg"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-0">Movement #<c:out value="${movementRequest.id}"/></h6>
                                                <small class="text-muted">
                                                    <i class="bx bx-building-house me-1"></i><c:out value="${warehouse.name}"/>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <p class="text-muted mb-0">Status</p>
                                        <span class="badge bg-success fs-6">Approved</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Availability Summary -->
                        <div class="alert ${allItemsAvailable ? 'alert-success' : 'alert-danger'} mb-6">
                            <i class="bx ${allItemsAvailable ? 'bx-check-circle' : 'bx-error-circle'} me-2"></i>
                            <c:choose>
                                <c:when test="${allItemsAvailable}">
                                    <strong>All items available.</strong> Sufficient inventory at all source locations. Ready to execute.
                                </c:when>
                                <c:otherwise>
                                    <strong>Insufficient inventory.</strong> One or more items do not have enough stock at the source location. Resolve before executing.
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Movement Items -->
                        <div class="card mb-6">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Items to Move</h5>
                                <span class="badge bg-primary">${fn:length(itemsWithDetails)} items</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">#</th>
                                            <th>Product</th>
                                            <th>From Location</th>
                                            <th>To Location</th>
                                            <th>Qty to Move</th>
                                            <th>Source Available</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="itemData" items="${itemsWithDetails}" varStatus="status">
                                            <c:set var="item" value="${itemData.item}" />
                                            <c:set var="product" value="${itemData.product}" />
                                            <c:set var="srcLoc" value="${itemData.sourceLocation}" />
                                            <c:set var="destLoc" value="${itemData.destinationLocation}" />
                                            <c:set var="srcQty" value="${itemData.sourceQuantity}" />
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>
                                                    <strong><c:out value="${product.sku}"/></strong>
                                                    <br><small class="text-muted"><c:out value="${product.name}"/></small>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <span class="badge bg-label-danger me-2">FROM</span>
                                                        <div>
                                                            <strong><c:out value="${srcLoc.code}"/></strong>
                                                            <br><small class="text-muted"><c:out value="${srcLoc.type}"/></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <span class="badge bg-label-success me-2">TO</span>
                                                        <div>
                                                            <strong><c:out value="${destLoc.code}"/></strong>
                                                            <br><small class="text-muted"><c:out value="${destLoc.type}"/></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="fs-5 fw-bold text-primary"><c:out value="${item.quantity}"/></span>
                                                    <span class="text-muted"><c:out value="${product.unit}"/></span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${srcQty >= item.quantity}">
                                                            <span class="text-success"><c:out value="${srcQty}"/></span>
                                                            <i class="bx bx-check-circle text-success ms-1"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger fw-bold"><c:out value="${srcQty}"/></span>
                                                            <i class="bx bx-error-circle text-danger ms-1" 
                                                               title="Insufficient quantity"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${srcQty >= item.quantity}">
                                                            <span class="badge bg-success">Sufficient</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Insufficient</span>
                                                            <br><small class="text-danger">Short by <c:out value="${item.quantity - srcQty}"/></small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
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
                                                    Inventory will be deducted from source and added to destination locations. This cannot be undone.
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
                                            <form action="${contextPath}/movement" method="post" class="d-inline" 
                                                  onsubmit="return confirm('Execute this movement? Inventory will be updated. This cannot be undone.');">
                                                <input type="hidden" name="action" value="start" />
                                                <input type="hidden" name="id" value="${movementRequest.id}" />
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
