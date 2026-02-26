<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Create Internal Outbound" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="outbound" />
                <jsp:param name="activeSubMenu" value="outbound-create" />
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
                                <li class="breadcrumb-item active" aria-current="page">Create Internal</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Create Internal Outbound Request
                            </h4>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h5 class="mb-0">Request Details</h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="${contextPath}/outbound" method="post" id="outboundForm">
                                            <input type="hidden" name="action" value="create" />
                                            
                                            <!-- Source Warehouse -->
                                            <div class="mb-4">
                                                <label for="warehouseId" class="form-label">Source Warehouse <span class="text-danger">*</span></label>
                                                <select class="form-select" id="warehouseId" name="warehouseId" required>
                                                    <option value="">Select warehouse...</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <option value="${wh.id}">${wh.name} - ${wh.location}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <!-- Outbound Reason -->
                                            <div class="mb-4">
                                                <label for="reason" class="form-label">Outbound Reason <span class="text-danger">*</span></label>
                                                <select class="form-select" id="reason" name="reason" required>
                                                    <option value="">Select reason...</option>
                                                    <c:forEach var="r" items="${reasons}">
                                                        <option value="${r}">${r}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <!-- Notes/Description -->
                                            <div class="mb-4">
                                                <label for="notes" class="form-label">Description/Notes <span id="notesRequired" class="text-danger d-none">*</span></label>
                                                <textarea class="form-control" id="notes" name="notes" rows="3" 
                                                          placeholder="Add description or notes..."></textarea>
                                                <small class="text-muted">Required when reason is "Other"</small>
                                            </div>
                                            
                                            <hr class="my-4" />
                                            
                                            <!-- Items Section -->
                                            <h6 class="mb-3">Items to Remove <span class="text-danger">*</span></h6>
                                            
                                            <div id="itemsContainer">
                                                <!-- Item template will be added here -->
                                            </div>
                                            
                                            <button type="button" class="btn btn-outline-primary mb-4" id="addItemBtn">
                                                <i class="bx bx-plus me-1"></i>Add Item
                                            </button>
                                            
                                            <hr class="my-4" />
                                            
                                            <div class="d-flex justify-content-between">
                                                <a href="${contextPath}/outbound" class="btn btn-outline-secondary">
                                                    <i class="bx bx-arrow-back me-1"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Create Request
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <!-- Help Card -->
                                <div class="card mb-6">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="bx bx-info-circle me-2"></i>Outbound Reasons</h6>
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-3">
                                                <strong>Damage/Disposal</strong>
                                                <p class="text-muted small mb-0">Remove damaged or expired items</p>
                                            </li>
                                            <li class="mb-3">
                                                <strong>Return to Supplier</strong>
                                                <p class="text-muted small mb-0">Return goods to vendor</p>
                                            </li>
                                            <li class="mb-3">
                                                <strong>Sample/Demo</strong>
                                                <p class="text-muted small mb-0">Items for demonstration</p>
                                            </li>
                                            <li class="mb-3">
                                                <strong>Adjustment</strong>
                                                <p class="text-muted small mb-0">Inventory corrections</p>
                                            </li>
                                            <li>
                                                <strong>Other</strong>
                                                <p class="text-muted small mb-0">Requires description</p>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <!-- Workflow Card -->
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="bx bx-git-branch me-2"></i>Workflow</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex flex-column">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-warning me-2">1</span>
                                                <span>Created (Pending)</span>
                                            </div>
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-info me-2">2</span>
                                                <span>Approved by Manager</span>
                                            </div>
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-primary me-2">3</span>
                                                <span>Picking In Progress</span>
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <span class="badge bg-success me-2">4</span>
                                                <span>Completed</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
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
    
    <script>
        // Products data for dropdown
        const products = [
            <c:forEach var="product" items="${products}" varStatus="status">
            { id: ${product.id}, name: "${fn:escapeXml(product.name)}", sku: "${fn:escapeXml(product.sku)}" }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        let itemCount = 0;
        
        function addItem() {
            itemCount++;
            const container = document.getElementById('itemsContainer');
            
            const itemHtml = `
                <div class="card bg-light mb-3" id="item-\${itemCount}">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h6 class="mb-0">Item #\${itemCount}</h6>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(\${itemCount})" aria-label="Remove item">
                                <i class="bx bx-trash" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label class="form-label">Product <span class="text-danger">*</span></label>
                                <select class="form-select" name="productId" required>
                                    <option value="">Select product...</option>
                                    \${products.map(p => `<option value="\${p.id}">\${p.sku} - \${p.name}</option>`).join('')}
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Quantity <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="quantity" min="1" value="1" required />
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            container.insertAdjacentHTML('beforeend', itemHtml);
        }
        
        function removeItem(id) {
            const item = document.getElementById('item-' + id);
            if (item) {
                item.remove();
            }
        }
        
        document.getElementById('addItemBtn').addEventListener('click', addItem);
        
        // Handle "Other" reason requiring notes
        document.getElementById('reason').addEventListener('change', function() {
            const notesRequired = document.getElementById('notesRequired');
            const notesField = document.getElementById('notes');
            
            if (this.value === 'Other') {
                notesRequired.classList.remove('d-none');
                notesField.required = true;
            } else {
                notesRequired.classList.add('d-none');
                notesField.required = false;
            }
        });
        
        // Validation
        document.getElementById('outboundForm').addEventListener('submit', function(e) {
            const items = document.querySelectorAll('#itemsContainer .card');
            if (items.length === 0) {
                e.preventDefault();
                alert('Please add at least one item.');
                return false;
            }
            
            // Check for duplicate products
            const selectedProducts = [];
            const productSelects = document.querySelectorAll('select[name="productId"]');
            for (let select of productSelects) {
                if (select.value) {
                    if (selectedProducts.includes(select.value)) {
                        e.preventDefault();
                        alert('Duplicate product detected. Each product can only be added once.');
                        return false;
                    }
                    selectedProducts.push(select.value);
                }
            }
        });
        
        // Add first item by default
        addItem();
    </script>
</body>
</html>
