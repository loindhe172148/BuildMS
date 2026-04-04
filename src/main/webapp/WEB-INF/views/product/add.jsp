<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Add Product" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="products" />
                <jsp:param name="activeSubMenu" value="product-add" />
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
                                    <a href="${contextPath}/product?action=list">Products</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Add Product</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Add New Product
                            </h4>
                        </div>
                        
                        <!-- Form Card -->
                        <div class="row">
                            <div class="col-xxl-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Product Information</h5>
                                    </div>
                                    <div class="card-body">
                                        
                                        <!-- Error Alert -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                <c:out value="${errorMessage}"/>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/product" method="post">
                                            <input type="hidden" name="action" value="add" />
                                            
                                            <!-- SKU -->
                                            <div class="mb-4">
                                                <label class="form-label" for="sku">
                                                    SKU <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-barcode"></i></span>
                                                    <input type="text" class="form-control" id="sku" name="sku" 
                                                           value="<c:out value='${sku}'/>" placeholder="e.g., PRD-001, SKU-ABC123"
                                                           required maxlength="100" />
                                                </div>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Unique identifier for this product. Use alphanumeric characters and hyphens.
                                                </div>
                                            </div>
                                            
                                            <!-- Name -->
                                            <div class="mb-4">
                                                <label class="form-label" for="name">
                                                    Product Name <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-package" aria-hidden="true"></i></span>
                                                    <input type="text" class="form-control" id="name" name="name" 
                                                           value="<c:out value='${name}'/>" placeholder="Enter product name"
                                                           required maxlength="255" />
                                                </div>
                                            </div>
                                            
                                            <!-- Category -->
                                            <div class="mb-4">
                                                <label class="form-label" for="categoryId">
                                                    Category <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="categoryId" name="categoryId" required>
                                                    <option value="">Select a category</option>
                                                    <c:forEach var="cat" items="${categories}">
                                                        <option value="<c:out value='${cat.id}'/>" 
                                                                data-unit="<c:out value='${cat.defaultUnit}'/>"
                                                                <c:out value="${categoryId == cat.id ? 'selected' : ''}"/>>
                                                            <c:out value="${cat.name}"/>
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <!-- Unit (Readonly, inherited from category) -->
                                            <div class="mb-4">
                                                <label class="form-label text-muted" for="unit">
                                                    Unit of Measure <i class="bx bx-info-circle ms-1" title="Unit will be inherited from the selected category"></i>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-lighter text-muted"><i class="bx bx-ruler"></i></span>
                                                    <input type="text" class="form-control bg-lighter text-muted" id="unit" name="unit" 
                                                           value="<c:out value='${unit}'/>" placeholder="Select a category first..." readonly />
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex justify-content-end gap-3 mt-5">
                                                <a href="${contextPath}/product?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Save Product
                                                </button>
                                            </div>
                                        </form>
                                        
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Help Card -->
                            <div class="col-xxl-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-help-circle me-2"></i>Tips for Creating Products
                                        </h6>
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                <strong>SKU</strong> must be unique across all products
                                            </li>
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Use consistent naming conventions for SKUs
                                            </li>
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Select the appropriate category for the product
                                            </li>
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Unit of measure helps with inventory tracking
                                            </li>
                                            <li class="mb-0">
                                                <i class="bx bx-check text-success me-2"></i>
                                                New products are set to <strong>Active</strong> by default
                                            </li>
                                        </ul>
                                    </div>
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
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var categorySelect = document.getElementById('categoryId');
            var unitInput = document.getElementById('unit');
            
            // Initialization: run once on page load to set unit based on old selection (if validation failed)
            updateUnit();
            
            // Listen for changes
            categorySelect.addEventListener('change', updateUnit);
            
            function updateUnit() {
                var selectedOption = categorySelect.options[categorySelect.selectedIndex];
                var defaultUnit = selectedOption.getAttribute('data-unit');
                
                if (defaultUnit) {
                    unitInput.value = defaultUnit;
                } else if (categorySelect.value === "") {
                    unitInput.value = "";
                    unitInput.placeholder = "Select a category first...";
                } else {
                    unitInput.value = "";
                    unitInput.placeholder = "No default unit available";
                }
            }
        });
    </script>
</body>
</html>
