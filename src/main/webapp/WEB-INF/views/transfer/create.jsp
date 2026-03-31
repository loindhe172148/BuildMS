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
                                        <c:choose>
                                            <c:when test="${isManager}">
                                                <select name="sourceWarehouseId" class="form-select" disabled>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <c:if test="${wh.id == lockedSourceWarehouseId}">
                                                            <option value="<c:out value='${wh.id}'/>" selected><c:out value="${wh.name}"/></option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                                <input type="hidden" name="sourceWarehouseId" value="${lockedSourceWarehouseId}" />
                                            </c:when>
                                            <c:otherwise>
                                                <select name="sourceWarehouseId" class="form-select" onchange="this.form.submit()">
                                                    <option value="">Select Source Warehouse</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <option value="<c:out value='${wh.id}'/>" <c:out value="${selectedSourceWarehouseId == wh.id ? 'selected' : ''}"/>>
                                                            <c:out value="${wh.name}"/>
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </c:otherwise>
                                        </c:choose>
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
                                                            <option value="<c:out value='${wh.id}'/>"><c:out value="${wh.name}"/></option>
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
                {id: ${p.product.id}, name: "<c:out value='${p.product.name}'/>", sku: "<c:out value='${p.product.sku}'/>", available: ${p.totalQuantity}, unit: "<c:out value='${p.product.unit}'/>"}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];

            // Per-product location breakdown: { productId -> [{id, code, type, qty}] }
            const productLocations = {
                <c:forEach var="p" items="${products}" varStatus="pStatus">
                "${p.product.id}": [
                    <c:forEach var="loc" items="${p.locations}" varStatus="lStatus">
                    {id: ${loc.locationId}, code: "<c:out value='${loc.locationCode}'/>", type: "<c:out value='${loc.locationType}'/>", qty: ${loc.quantity}}<c:if test="${!lStatus.last}">,</c:if>
                    </c:forEach>
                ]<c:if test="${!pStatus.last}">,</c:if>
                </c:forEach>
            };
            
            function updateUI() {
                const items = itemsContainer.querySelectorAll('.item-row');
                noItemsMessage.style.display = items.length === 0 ? 'block' : 'none';
                submitBtn.disabled = items.length === 0;
            }
            
            function getSelectedProductIds() {
                const selectedIds = [];
                itemsContainer.querySelectorAll('.product-select').forEach(select => {
                    if (select.value) {
                        selectedIds.push(parseInt(select.value));
                    }
                });
                return selectedIds;
            }
            
            function updateAllDropdowns() {
                const selectedIds = getSelectedProductIds();
                itemsContainer.querySelectorAll('.product-select').forEach(select => {
                    const currentValue = select.value;
                    Array.from(select.options).forEach(option => {
                        if (option.value && option.value !== currentValue) {
                            option.disabled = selectedIds.includes(parseInt(option.value));
                        }
                    });
                });
            }

            function populateLocationDropdown(locationSelect, productId, availableDisplay, qtyInput) {
                // Reset
                locationSelect.innerHTML = '<option value="">-- Any location --</option>';
                locationSelect.disabled = true;
                availableDisplay.value = '-';

                if (!productId) return;

                const product = products.find(p => p.id === parseInt(productId));
                if (product) {
                    availableDisplay.value = product.available + ' ' + product.unit;
                    qtyInput.max = product.available;
                }

                const locs = productLocations[productId] || [];
                if (locs.length === 0) return;

                locs.forEach(loc => {
                    const opt = document.createElement('option');
                    opt.value = loc.id;
                    opt.textContent = loc.code + ' [' + loc.type + '] — ' + loc.qty + ' ' + (product ? product.unit : '');
                    locationSelect.appendChild(opt);
                });
                locationSelect.disabled = false;
            }
            
            function addItemRow() {
                const row = document.createElement('div');
                row.className = 'item-row row mb-3 g-2 align-items-end';
                
                const selectedIds = getSelectedProductIds();
                
                // --- Product column ---
                const colProduct = document.createElement('div');
                colProduct.className = 'col-md-4';
                const labelProduct = document.createElement('label');
                labelProduct.className = 'form-label';
                labelProduct.innerHTML = 'Product <span class="text-danger">*</span>';
                const select = document.createElement('select');
                select.name = 'productId[]';
                select.className = 'form-select product-select';
                select.required = true;
                
                const defaultOption = document.createElement('option');
                defaultOption.value = '';
                defaultOption.textContent = 'Select Product';
                select.appendChild(defaultOption);
                
                products.forEach(p => {
                    const option = document.createElement('option');
                    option.value = p.id;
                    option.setAttribute('data-available', p.available);
                    option.textContent = p.name + ' (' + p.sku + ')';
                    option.disabled = selectedIds.includes(p.id);
                    select.appendChild(option);
                });
                
                colProduct.appendChild(labelProduct);
                colProduct.appendChild(select);

                // --- Source Location column ---
                const colLoc = document.createElement('div');
                colLoc.className = 'col-md-3';
                const labelLoc = document.createElement('label');
                labelLoc.className = 'form-label';
                labelLoc.textContent = 'Source Location';
                const locationSelect = document.createElement('select');
                locationSelect.name = 'sourceLocationId[]';
                locationSelect.className = 'form-select location-select';
                locationSelect.disabled = true;
                const defaultLocOption = document.createElement('option');
                defaultLocOption.value = '';
                defaultLocOption.textContent = '-- Any location --';
                locationSelect.appendChild(defaultLocOption);
                colLoc.appendChild(labelLoc);
                colLoc.appendChild(locationSelect);
                
                // --- Quantity column ---
                const colQty = document.createElement('div');
                colQty.className = 'col-md-2';
                colQty.innerHTML = `
                    <label class="form-label">Quantity <span class="text-danger">*</span></label>
                    <input type="number" name="quantity[]" class="form-control quantity-input" min="1" value="1" required>
                `;
                
                // --- Available column ---
                const colAvail = document.createElement('div');
                colAvail.className = 'col-md-2';
                colAvail.innerHTML = `
                    <label class="form-label">Available</label>
                    <input type="text" class="form-control available-display" readonly value="-">
                `;
                
                // --- Remove button column ---
                const colBtn = document.createElement('div');
                colBtn.className = 'col-md-1';
                colBtn.innerHTML = `
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="button" class="btn btn-outline-danger w-100 remove-item-btn">
                        <i class="bx bx-trash"></i>
                    </button>
                `;
                
                row.appendChild(colProduct);
                row.appendChild(colLoc);
                row.appendChild(colQty);
                row.appendChild(colAvail);
                row.appendChild(colBtn);

                const availableDisplay = colAvail.querySelector('.available-display');
                const qtyInput = colQty.querySelector('.quantity-input');
                
                // Events
                row.querySelector('.remove-item-btn').addEventListener('click', function() {
                    row.remove();
                    updateUI();
                    updateAllDropdowns();
                });
                
                select.addEventListener('change', function() {
                    const productId = this.value;
                    populateLocationDropdown(locationSelect, productId, availableDisplay, qtyInput);

                    // When location selected, update available display to that location's qty
                    locationSelect.addEventListener('change', function() {
                        if (!this.value) {
                            // "Any" selected: show total available
                            const product = products.find(p => p.id === parseInt(productId));
                            if (product) availableDisplay.value = product.available + ' ' + product.unit;
                        } else {
                            const locs = productLocations[productId] || [];
                            const loc = locs.find(l => l.id === parseInt(this.value));
                            if (loc) {
                                const product = products.find(p => p.id === parseInt(productId));
                                availableDisplay.value = loc.qty + ' ' + (product ? product.unit : '');
                                qtyInput.max = loc.qty;
                            }
                        }
                    }, { once: false });

                    updateAllDropdowns();
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
