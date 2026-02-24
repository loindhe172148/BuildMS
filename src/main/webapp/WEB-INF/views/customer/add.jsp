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
        <jsp:param name="pageTitle" value="Add Customer" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="customers" />
                <jsp:param name="activeSubMenu" value="customer-add" />
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
                                    <a href="${contextPath}/customer?action=list">Customers</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Add Customer</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Add New Customer
                            </h4>
                            <a href="${contextPath}/customer?action=list" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to List
                            </a>
                        </div>
                        
                        <div class="row">
                            <!-- Form Card -->
                            <div class="col-xl-8">
                                <div class="card mb-6">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="mb-0">Customer Information</h5>
                                        <small class="text-muted float-end">
                                            <span class="text-danger">*</span> Required fields
                                        </small>
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
                                        
                                        <form action="${contextPath}/customer" method="post">
                                            <input type="hidden" name="action" value="add" />
                                            
                                            <!-- Customer Code -->
                                            <div class="mb-4">
                                                <label for="code" class="form-label">
                                                    Customer Code <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="code" name="code" 
                                                       placeholder="Enter customer code (e.g., CUS001)" 
                                                       value="${code}" 
                                                       maxlength="50" 
                                                       required />
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Unique identifier for the customer. Cannot be changed easily.
                                                </div>
                                            </div>
                                            
                                            <!-- Customer Name -->
                                            <div class="mb-4">
                                                <label for="name" class="form-label">
                                                    Customer Name <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       placeholder="Enter customer name" 
                                                       value="${name}" 
                                                       maxlength="255" 
                                                       required />
                                            </div>
                                            
                                            <!-- Contact Info -->
                                            <div class="mb-4">
                                                <label for="contactInfo" class="form-label">Contact Information</label>
                                                <textarea class="form-control" id="contactInfo" name="contactInfo" 
                                                          rows="4" 
                                                          maxlength="500"
                                                          placeholder="Enter contact details (phone, email, address, etc.)">${contactInfo}</textarea>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Optional. Include phone numbers, email addresses, or physical address.
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex gap-3 pt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Create Customer
                                                </button>
                                                <a href="${contextPath}/customer?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Help Card -->
                            <div class="col-xl-4">
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-help-circle text-primary me-2"></i>
                                            Customer Guidelines
                                        </h6>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-label-primary p-2 me-3">
                                                <i class="bx bx-hash"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Customer Code</h6>
                                                <small class="text-muted">
                                                    Must be unique. Use a consistent format like CUS001, CUS002, etc.
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-label-info p-2 me-3">
                                                <i class="bx bx-user"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Customer Name</h6>
                                                <small class="text-muted">
                                                    Full company or individual name for identification.
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-label-success p-2 me-3">
                                                <i class="bx bx-phone"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Contact Info</h6>
                                                <small class="text-muted">
                                                    Include all relevant contact details for order processing.
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-bulb text-warning me-2"></i>
                                            Quick Tips
                                        </h6>
                                        <ul class="mb-0 ps-3">
                                            <li class="mb-2">
                                                New customers are <strong>Active</strong> by default
                                            </li>
                                            <li class="mb-2">
                                                Only <strong>Admin</strong> can deactivate customers
                                            </li>
                                            <li class="mb-2">
                                                Inactive customers cannot have new sales orders
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
