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
                                    <a href="${contextPath}/transfer?action=view&id=${transfer.id}">#<c:out value="${transfer.id}"/></a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Execute Outbound</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-export me-2"></i>Execute Outbound: #<c:out value="${transfer.id}"/>
                                </h4>
                                <p class="text-muted mb-0">Review inventory and confirm outbound shipment</p>
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
                                                <h5 class="mb-0"><c:out value="${sourceWarehouse.name}"/></h5>
                                                <small class="text-muted"><c:out value="${sourceWarehouse.location}"/></small>
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
                                                <h5 class="mb-0"><c:out value="${destinationWarehouse.name}"/></h5>
                                                <small class="text-muted"><c:out value="${destinationWarehouse.location}"/></small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Inventory Availability Check -->
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="bx bx-check-shield me-2"></i>Inventory Availability Check</h5>
                            </div>
                            <div class="card-body">
                                <c:set var="allAvailable" value="${true}" />
                                <c:forEach var="check" items="${availability}">
                                    <c:if test="${check.available < check.item.quantity}">
                                        <c:set var="allAvailable" value="${false}" />
                                    </c:if>
                                </c:forEach>
                                
                                <div class="alert ${allAvailable ? 'alert-success' : 'alert-danger'} mb-4">
                                    <i class="bx ${allAvailable ? 'bx-check-circle' : 'bx-error-circle'} me-2"></i>
                                    <c:choose>
                                        <c:when test="${allAvailable}">
                                            <strong>All items are available.</strong> You can proceed with outbound execution. Inventory will be deducted automatically.
                                        </c:when>
                                        <c:otherwise>
                                            <strong>Insufficient inventory.</strong> Some items do not have enough stock at the source warehouse.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
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
                                            <c:forEach var="check" items="${availability}">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty check.product}">${check.product.name}</c:when>
                                                            <c:otherwise>Product #${check.item.productId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty check.product}">
                                                            <code><c:out value="${check.product.sku}"/></code>
                                                        </c:if>
                                                    </td>
                                                    <td class="text-center"><c:out value="${check.item.quantity}"/> <c:if test="${not empty check.product}"><span class="text-muted"><c:out value="${check.product.unit}"/></span></c:if></td>
                                                    <td class="text-center"><c:out value="${check.available}"/> <c:if test="${not empty check.product}"><span class="text-muted"><c:out value="${check.product.unit}"/></span></c:if></td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${check.available >= check.item.quantity}">
                                                                <span class="badge bg-success">
                                                                    <i class="bx bx-check"></i> Sufficient
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">
                                                                    <i class="bx bx-x"></i> Insufficient
                                                                </span>
                                                                <br>
                                                                <small class="text-danger">Short by <c:out value="${check.item.quantity - check.available}"/></small>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Execute Button -->
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <c:choose>
                                            <c:when test="${allAvailable}">
                                                <p class="text-muted mb-0">
                                                    This will deduct inventory and mark goods as in transit. This action cannot be undone.
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
                                        <c:when test="${allAvailable}">
                                            <form method="post" action="${contextPath}/transfer"
                                                  onsubmit="return confirm('Execute outbound? Inventory will be deducted and goods marked as in transit. This cannot be undone.');">
                                                <input type="hidden" name="action" value="start-outbound">
                                                <input type="hidden" name="id" value="${transfer.id}">
                                                <button type="submit" class="btn btn-success btn-lg">
                                                    <i class="bx bx-check-double me-1"></i> Confirm & Execute Outbound
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-success btn-lg" disabled
                                                    title="Resolve inventory shortages before executing">
                                                <i class="bx bx-check-double me-1"></i> Confirm & Execute Outbound
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
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
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
