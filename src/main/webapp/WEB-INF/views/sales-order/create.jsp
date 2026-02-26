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
        <jsp:param name="pageTitle" value="Create Sales Order" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="sales-orders" />
                <jsp:param name="activeSubMenu" value="sales-order-create" />
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
                                    <a href="${contextPath}/sales-order">Sales Orders</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Create Order</li>
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
                                <i class="bx bx-cart-add me-2"></i>Create Sales Order
                            </h4>
                        </div>
                        
                        <c:choose>
                            <c:when test="${empty customers}">
                                <div class="alert alert-warning">
                                    <i class="bx bx-info-circle me-2"></i>
                                    No customers available. 
                                    <a href="${contextPath}/customer?action=create">Create a customer first</a>.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${contextPath}/sales-order" id="salesOrderForm">
                                    <input type="hidden" name="action" value="create">
                                    
                                    <!-- Customer Selection -->
                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <h5 class="mb-0">Customer Information</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <label for="customerId" class="form-label">Customer <span class="text-danger">*</span></label>
                                                    <select id="customerId" name="customerId" class="form-select" required>
                                                        <option value="">Select Customer</option>
                                                        <c:forEach var="customer" items="${customers}">
                                                            <option value="${customer.id}">${customer.name} (${customer.code})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Order Items -->
                                    <div class="card mb-4">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">Order Items</h5>
                                            <button type="button" class="btn btn-sm btn-outline-primary" id="addItemBtn">
                                                <i class="bx bx-plus me-1"></i> Add Item
                                            </button>
                                        </div>
                                        <div class="card-body">
                                            <div id="itemsContainer">
                                                <!-- Item rows will be added here -->
                                            </div>
                                            <div id="noItemsMessage" class="text-center text-muted py-3">
                                                <i class="bx bx-info-circle me-1"></i> Click "Add Item" to add products to this order
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="${contextPath}/sales-order" class="btn btn-outline-secondary">
                                            <i class="bx bx-x me-1"></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                                            <i class="bx bx-save me-1"></i> Save as Draft
                                        </button>
                                    </div>
                                </form>
                            </c:otherwise>
                        </c:choose>
                        
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
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const itemsContainer = document.getElementById('itemsContainer');
            const noItemsMessage = document.getElementById('noItemsMessage');
            const addItemBtn = document.getElementById('addItemBtn');
            const submitBtn = document.getElementById('submitBtn');
            let itemCount = 0;
            
            // Products data
            const products = [
                <c:forEach var="product" items="${products}" varStatus="status">
                    {id: ${product.id}, name: '<c:out value="${product.name}" escapeXml="true"/>', sku: '<c:out value="${product.sku}" escapeXml="true"/>'}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            function updateUI() {
                const items = itemsContainer.querySelectorAll('.item-row');
                noItemsMessage.style.display = items.length === 0 ? 'block' : 'none';
                submitBtn.disabled = items.length === 0;
            }
            
            function addItemRow() {
                itemCount++;
                const row = document.createElement('div');
                row.className = 'item-row row mb-3 align-items-end';
                row.innerHTML = `
                    <div class="col-md-6">
                        <label class="form-label">Product <span class="text-danger">*</span></label>
                        <select name="productId[]" class="form-select product-select" required>
                            <option value="">Select Product</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Quantity <span class="text-danger">*</span></label>
                        <input type="number" name="quantity[]" class="form-control" min="1" value="1" required>
                    </div>
                    <div class="col-md-3">
                        <button type="button" class="btn btn-outline-danger remove-item-btn">
                            <i class="bx bx-trash" aria-hidden="true"></i> Remove
                        </button>
                    </div>
                `;
                
                // Populate product dropdown safely
                const productSelect = row.querySelector('.product-select');
                products.forEach(p => {
                    const option = document.createElement('option');
                    option.value = p.id;
                    option.textContent = p.name + ' (' + p.sku + ')';
                    productSelect.appendChild(option);
                });
                
                // Add remove event
                row.querySelector('.remove-item-btn').addEventListener('click', function() {
                    row.remove();
                    updateUI();
                });
                
                // Check for duplicate products
                row.querySelector('.product-select').addEventListener('change', function() {
                    validateDuplicates();
                });
                
                itemsContainer.appendChild(row);
                updateUI();
            }
            
            function validateDuplicates() {
                const selects = itemsContainer.querySelectorAll('.product-select');
                const selectedValues = [];
                let hasDuplicate = false;
                
                selects.forEach(select => {
                    if (select.value) {
                        if (selectedValues.includes(select.value)) {
                            hasDuplicate = true;
                            select.classList.add('is-invalid');
                        } else {
                            select.classList.remove('is-invalid');
                            selectedValues.push(select.value);
                        }
                    }
                });
                
                if (hasDuplicate) {
                    alert('Duplicate product detected. Each product can only be added once.');
                }
                
                return !hasDuplicate;
            }
            
            addItemBtn.addEventListener('click', addItemRow);
            
            document.getElementById('salesOrderForm').addEventListener('submit', function(e) {
                if (!validateDuplicates()) {
                    e.preventDefault();
                    return false;
                }
            });
            
            updateUI();
        });
    </script>
</body>
</html>
