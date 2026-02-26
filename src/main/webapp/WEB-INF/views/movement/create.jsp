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
        <jsp:param name="pageTitle" value="Create Internal Movement" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="movement" />
                <jsp:param name="activeSubMenu" value="movement-create" />
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
                                <li class="breadcrumb-item active" aria-current="page">Create</li>
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
                        <h4 class="mb-6">
                            <i class="bx bx-transfer me-2"></i>Create Internal Movement
                        </h4>
                        
                        <!-- Step 1: Select Warehouse -->
                        <c:if test="${empty selectedWarehouseId}">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Step 1: Select Warehouse</h5>
                                </div>
                                <div class="card-body">
                                    <form action="${contextPath}/movement" method="get">
                                        <input type="hidden" name="action" value="create" />
                                        
                                        <c:choose>
                                            <c:when test="${isStaff}">
                                                <p class="text-muted">You will be creating a movement in your assigned warehouse.</p>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-right-arrow-alt me-1"></i>Continue
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Warehouse <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="warehouseId" required>
                                                            <option value="">-- Select Warehouse --</option>
                                                            <c:forEach var="wh" items="${warehouses}">
                                                                <option value="${wh.id}">${wh.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-right-arrow-alt me-1"></i>Continue
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Step 2: Add Movement Items -->
                        <c:if test="${not empty selectedWarehouseId}">
                            <form action="${contextPath}/movement" method="post" id="movementForm">
                                <input type="hidden" name="action" value="create" />
                                <input type="hidden" name="warehouseId" value="${selectedWarehouseId}" />
                                
                                <!-- Warehouse Info -->
                                <div class="card mb-6">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="text-muted">Warehouse:</span>
                                                <strong class="ms-2">
                                                    <i class="bx bx-building-house me-1"></i>${selectedWarehouse.name}
                                                </strong>
                                            </div>
                                            <c:if test="${not isStaff}">
                                                <a href="${contextPath}/movement?action=create" class="btn btn-sm btn-outline-secondary">
                                                    <i class="bx bx-edit me-1"></i>Change Warehouse
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Movement Items -->
                                <div class="card mb-6">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Movement Items</h5>
                                        <button type="button" class="btn btn-sm btn-primary" onclick="addMovementItem()">
                                            <i class="bx bx-plus me-1"></i>Add Item
                                        </button>
                                    </div>
                                    <div class="card-body">
                                        <div id="movementItems">
                                            <!-- Item template will be added here -->
                                        </div>
                                        
                                        <c:if test="${empty productsWithInventory}">
                                            <div class="alert alert-warning mb-0">
                                                <i class="bx bx-info-circle me-2"></i>
                                                No products with inventory in this warehouse. Please add inventory first.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Notes -->
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h5 class="mb-0">Additional Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label">Notes (Optional)</label>
                                            <textarea class="form-control" name="notes" rows="3" 
                                                      placeholder="Enter any additional notes..."></textarea>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Submit Buttons -->
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${contextPath}/movement" class="btn btn-outline-secondary">
                                        <i class="bx bx-x me-1"></i>Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary" id="submitBtn">
                                        <i class="bx bx-check me-1"></i>Create Movement
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        
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
    
    <c:if test="${not empty selectedWarehouseId}">
    <script>
        // Products with inventory data
        const productsWithInventory = [
            <c:forEach var="pi" items="${productsWithInventory}" varStatus="status">
            {
                id: ${pi.product.id},
                sku: '<c:out value="${pi.product.sku}" escapeXml="true"/>',
                name: '<c:out value="${pi.product.name}" escapeXml="true"/>',
                totalQty: ${pi.totalQuantity},
                inventories: [
                    <c:forEach var="inv" items="${pi.inventories}" varStatus="invStatus">
                    { locationId: ${inv.locationId}, quantity: ${inv.quantity} }<c:if test="${not invStatus.last}">,</c:if>
                    </c:forEach>
                ]
            }<c:if test="${not status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Locations data
        const locations = [
            <c:forEach var="loc" items="${locations}" varStatus="status">
            { id: ${loc.id}, code: '<c:out value="${loc.code}" escapeXml="true"/>', type: '<c:out value="${loc.type}" escapeXml="true"/>' }<c:if test="${not status.last}">,</c:if>
            </c:forEach>
        ];
        
        let itemCounter = 0;
        
        function addMovementItem() {
            if (productsWithInventory.length === 0) {
                alert('No products with inventory available in this warehouse.');
                return;
            }
            
            itemCounter++;
            const itemHtml = `
                <div class="movement-item border rounded p-3 mb-3" id="item_${itemCounter}">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <h6 class="mb-0">Item #${itemCounter}</h6>
                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(${itemCounter})" aria-label="Remove item">
                            <i class="bx bx-trash" aria-hidden="true"></i>
                        </button>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product <span class="text-danger">*</span></label>
                            <select class="form-select" name="productId" required onchange="onProductChange(${itemCounter}, this)">
                                <option value="">-- Select Product --</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Quantity <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="quantity" min="1" required 
                                   placeholder="Enter quantity" id="qty_${itemCounter}">
                            <small class="text-muted" id="availableQty_${itemCounter}"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Source Location <span class="text-danger">*</span></label>
                            <select class="form-select" name="sourceLocationId" required 
                                    id="sourceLocation_${itemCounter}" onchange="onSourceChange(${itemCounter}, this)">
                                <option value="">-- Select Source Location --</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Destination Location <span class="text-danger">*</span></label>
                            <select class="form-select" name="destinationLocationId" required id="destLocation_${itemCounter}">
                                <option value="">-- Select Destination Location --</option>
                            </select>
                        </div>
                    </div>
                </div>
            `;
            
            document.getElementById('movementItems').insertAdjacentHTML('beforeend', itemHtml);
            
            // Populate product dropdown
            const productSelect = document.querySelector(`#item_${itemCounter} select[name="productId"]`);
            productsWithInventory.forEach(p => {
                const option = document.createElement('option');
                option.value = p.id;
                option.textContent = `${p.sku} - ${p.name} (Total: ${p.totalQty})`;
                productSelect.appendChild(option);
            });
            
            // Populate destination location dropdown
            const destSelect = document.getElementById(`destLocation_${itemCounter}`);
            locations.forEach(l => {
                const option = document.createElement('option');
                option.value = l.id;
                option.textContent = `${l.code} (${l.type})`;
                destSelect.appendChild(option);
            });
        }
        
        function removeItem(itemId) {
            document.getElementById('item_' + itemId).remove();
        }
        
        function onProductChange(itemId, selectElement) {
            const productId = parseInt(selectElement.value);
            const sourceSelect = document.getElementById('sourceLocation_' + itemId);
            const availableQtyEl = document.getElementById('availableQty_' + itemId);
            const qtyInput = document.getElementById('qty_' + itemId);
            
            // Reset source location
            sourceSelect.innerHTML = '<option value="">-- Select Source Location --</option>';
            availableQtyEl.textContent = '';
            qtyInput.value = '';
            qtyInput.max = '';
            
            if (!productId) return;
            
            // Find product
            const product = productsWithInventory.find(p => p.id === productId);
            if (!product) return;
            
            // Populate source locations with inventory
            product.inventories.forEach(inv => {
                const loc = locations.find(l => l.id === inv.locationId);
                if (loc && inv.quantity > 0) {
                    const option = document.createElement('option');
                    option.value = inv.locationId;
                    option.textContent = `${loc.code} (${loc.type}) - Qty: ${inv.quantity}`;
                    option.dataset.quantity = inv.quantity;
                    sourceSelect.appendChild(option);
                }
            });
        }
        
        function onSourceChange(itemId, selectElement) {
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const availableQty = selectedOption.dataset.quantity || 0;
            const availableQtyEl = document.getElementById('availableQty_' + itemId);
            const qtyInput = document.getElementById('qty_' + itemId);
            
            availableQtyEl.textContent = `Available: ${availableQty}`;
            qtyInput.max = availableQty;
        }
        
        // Validation before submit
        document.getElementById('movementForm').addEventListener('submit', function(e) {
            const items = document.querySelectorAll('.movement-item');
            if (items.length === 0) {
                e.preventDefault();
                alert('At least one movement item is required.');
                return;
            }
            
            // Check each item for source != destination
            let hasError = false;
            items.forEach((item, index) => {
                const sourceSelect = item.querySelector('[name="sourceLocationId"]');
                const destSelect = item.querySelector('[name="destinationLocationId"]');
                
                if (sourceSelect.value && destSelect.value && sourceSelect.value === destSelect.value) {
                    alert(`Item #${index + 1}: Source and destination locations must be different.`);
                    hasError = true;
                }
            });
            
            if (hasError) {
                e.preventDefault();
            }
        });
        
        // Add first item by default
        addMovementItem();
    </script>
    </c:if>
</body>
</html>
