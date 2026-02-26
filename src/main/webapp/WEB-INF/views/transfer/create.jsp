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
        <jsp:param name="pageTitle" value="Create Transfer Request" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="transfers" />
                <jsp:param name="activeSubMenu" value="transfer-create" />
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
                                <li class="breadcrumb-item active" aria-current="page">Create Transfer</li>
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
                            <h4 class="mb-0">
                                <i class="bx bx-transfer me-2"></i>Create Transfer Request
                            </h4>
                        </div>
                        
                        <!-- Step 1: Select Warehouses -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Step 1: Select Warehouses</h5>
                            </div>
                            <div class="card-body">
                                <form method="get" action="${contextPath}/transfer" class="row g-3">
                                    <input type="hidden" name="action" value="create">
                                    <div class="col-md-5">
                                        <label class="form-label">Source Warehouse <span class="text-danger">*</span></label>
                                        <select name="sourceWarehouseId" class="form-select" onchange="this.form.submit()">
                                            <option value="">Select Source Warehouse</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.id}" ${selectedSourceWarehouseId == wh.id ? 'selected' : ''}>
                                                    ${wh.name} (${wh.code})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-center justify-content-center">
                                        <i class="bx bx-right-arrow-alt fs-2 text-primary"></i>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label">Destination Warehouse</label>
                                        <select name="destinationWarehouseId" class="form-select" disabled>
                                            <option value="">Select after choosing source</option>
                                        </select>
                                        <small class="text-muted">Select in Step 2 below</small>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Step 2: Complete Form (only if source selected) -->
                        <c:if test="${not empty selectedSourceWarehouseId}">
                            <form method="post" action="${contextPath}/transfer" id="transferForm">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="sourceWarehouseId" value="${selectedSourceWarehouseId}">
                                
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0">Step 2: Destination & Notes</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Destination Warehouse <span class="text-danger">*</span></label>
                                                <select name="destinationWarehouseId" class="form-select" required>
                                                    <option value="">Select Destination Warehouse</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <c:if test="${wh.id != selectedSourceWarehouseId}">
                                                            <option value="${wh.id}">${wh.name} (${wh.code})</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Notes</label>
                                                <textarea name="notes" class="form-control" rows="2" 
                                                          placeholder="Optional transfer notes..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Step 3: Select Items to Transfer</h5>
                                        <button type="button" class="btn btn-sm btn-outline-primary" id="addItemBtn">
                                            <i class="bx bx-plus me-1"></i> Add Item
                                        </button>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${empty products}">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="bx bx-info-circle me-2"></i>
                                                    No products with inventory available at the source warehouse.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div id="itemsContainer">
                                                    <!-- Item rows will be added here -->
                                                </div>
                                                <div id="noItemsMessage" class="text-center text-muted py-3">
                                                    <i class="bx bx-info-circle me-1"></i> Click "Add Item" to add products to transfer
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Actions -->
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${contextPath}/transfer" class="btn btn-outline-secondary">
                                        <i class="bx bx-x me-1"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                                        <i class="bx bx-save me-1"></i> Create Transfer
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        
                        <c:if test="${empty selectedSourceWarehouseId}">
                            <div class="alert alert-info">
                                <i class="bx bx-info-circle me-2"></i>
                                Please select a source warehouse to see available products.
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
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <c:if test="${not empty products}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const itemsContainer = document.getElementById('itemsContainer');
            const noItemsMessage = document.getElementById('noItemsMessage');
            const addItemBtn = document.getElementById('addItemBtn');
            const submitBtn = document.getElementById('submitBtn');
            
            // Products with inventory
            const products = [
                <c:forEach var="p" items="${products}" varStatus="status">
                    {id: ${p.product.id}, name: "${p.product.name}", sku: "${p.product.sku}", available: ${p.totalQuantity}}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            function updateUI() {
                const items = itemsContainer.querySelectorAll('.item-row');
                noItemsMessage.style.display = items.length === 0 ? 'block' : 'none';
                submitBtn.disabled = items.length === 0;
            }
            
            function addItemRow() {
                const row = document.createElement('div');
                row.className = 'item-row row mb-3 align-items-end';
                row.innerHTML = `
                    <div class="col-md-5">
                        <label class="form-label">Product <span class="text-danger">*</span></label>
                        <select name="productId[]" class="form-select product-select" required>
                            <option value="">Select Product</option>
                            ${products.map(p => `<option value="${p.id}" data-available="${p.available}">${p.name} (${p.sku}) - Available: ${p.available}</option>`).join('')}
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Quantity <span class="text-danger">*</span></label>
                        <input type="number" name="quantity[]" class="form-control quantity-input" min="1" value="1" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Available</label>
                        <input type="text" class="form-control available-display" readonly value="-">
                    </div>
                    <div class="col-md-2">
                        <button type="button" class="btn btn-outline-danger remove-item-btn" aria-label="Remove item">
                            <i class="bx bx-trash" aria-hidden="true"></i>
                        </button>
                    </div>
                `;
                
                // Add event listeners
                row.querySelector('.remove-item-btn').addEventListener('click', function() {
                    row.remove();
                    updateUI();
                });
                
                row.querySelector('.product-select').addEventListener('change', function() {
                    const selected = this.options[this.selectedIndex];
                    const available = selected.getAttribute('data-available') || '-';
                    row.querySelector('.available-display').value = available;
                    
                    const qtyInput = row.querySelector('.quantity-input');
                    if (available !== '-') {
                        qtyInput.max = available;
                    }
                });
                
                itemsContainer.appendChild(row);
                updateUI();
            }
            
            addItemBtn.addEventListener('click', addItemRow);
            updateUI();
        });
    </script>
    </c:if>
</body>
</html>
