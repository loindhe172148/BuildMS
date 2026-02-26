<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Edit Category" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="categories" />
                <jsp:param name="activeSubMenu" value="category-list" />
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
                                    <a href="${contextPath}/category?action=list">Categories</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Category</li>
                            </ol>
                        </nav>
                        
                        <div class="row">
                            <div class="col-md-8 col-lg-6">
                                <div class="card mb-6">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="mb-0">
                                            <i class="bx bx-edit me-2"></i>Edit Category
                                        </h5>
                                        <span class="badge bg-label-primary">ID: ${category.id}</span>
                                    </div>
                                    <div class="card-body">
                                        
                                        <!-- Error Message -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                ${errorMessage}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Edit Category Form -->
                                        <form action="${contextPath}/category" method="post">
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="id" value="${category.id}" />
                                            
                                            <div class="mb-4">
                                                <label class="form-label" for="name">
                                                    Category Name <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" 
                                                       class="form-control" 
                                                       id="name" 
                                                       name="name" 
                                                       value="${category.name}"
                                                       placeholder="Enter category name" 
                                                       maxlength="255"
                                                       required 
                                                       autofocus />
                                                <div class="form-text">Maximum 255 characters</div>
                                            </div>
                                            
                                            <div class="mb-4">
                                                <label class="form-label" for="description">Description</label>
                                                <textarea class="form-control" 
                                                          id="description" 
                                                          name="description" 
                                                          rows="4" 
                                                          maxlength="500"
                                                          placeholder="Enter category description (optional)">${category.description}</textarea>
                                                <div class="form-text">Maximum 500 characters</div>
                                            </div>
                                            
                                            <div class="mt-6">
                                                <button type="submit" class="btn btn-primary me-3">
                                                    <i class="bx bx-save me-1"></i>Update Category
                                                </button>
                                                <a href="${contextPath}/category?action=list" class="btn btn-outline-secondary">
                                                    Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Info Card -->
                            <div class="col-md-4 col-lg-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-info-circle me-2 text-info"></i>Category Info
                                        </h6>
                                        <ul class="small mb-0">
                                            <li>Category name must be unique</li>
                                            <li>Changing the name won't affect associated products</li>
                                            <li>Description is optional</li>
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
