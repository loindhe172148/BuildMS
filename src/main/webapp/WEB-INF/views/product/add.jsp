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
                                                ${errorMessage}
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
                                                           value="${sku}" placeholder="e.g., PRD-001, SKU-ABC123"
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
                                                           value="${name}" placeholder="Enter product name"
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
                                                        <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>
                                                            ${cat.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <!-- Unit -->
                                            <div class="mb-4">
                                                <label class="form-label" for="unit">Unit of Measure</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-ruler"></i></span>
                                                    <input type="text" class="form-control" id="unit" name="unit" 
                                                           value="${unit}" placeholder="e.g., pcs, kg, box, carton"
                                                           maxlength="50" list="unitSuggestions" />
                                                </div>
                                                <datalist id="unitSuggestions">
                                                    <option value="pcs">
                                                    <option value="kg">
                                                    <option value="g">
                                                    <option value="box">
                                                    <option value="carton">
                                                    <option value="pack">
                                                    <option value="set">
                                                    <option value="unit">
                                                    <option value="pair">
                                                    <option value="dozen">
                                                    <option value="liter">
                                                    <option value="meter">
                                                </datalist>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Optional. Common units: pcs, kg, box, carton, pack
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
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
