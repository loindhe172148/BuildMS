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
        <jsp:param name="pageTitle" value="Customer List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="customers" />
                <jsp:param name="activeSubMenu" value="customer-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Customers</li>
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
                        
                        <c:if test="${not empty sessionScope.warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bx bx-info-circle me-2"></i>
                                ${sessionScope.warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="warningMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-user me-2"></i>Customer Management
                            </h4>
                            <a href="${contextPath}/customer?action=add" class="btn btn-primary">
                                <i class="bx bx-plus me-1"></i>Add Customer
                            </a>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/customer" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Search by Code/Name -->
                                    <div class="col-md-5">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search by code or name..." />
                                        </div>
                                    </div>
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-outline-primary w-100">
                                            <i class="bx bx-filter-alt me-1"></i>Filter
                                        </button>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <a href="${contextPath}/customer?action=list" class="btn btn-outline-secondary w-100">
                                            <i class="bx bx-reset me-1"></i>Reset
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Customers Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Customers</h5>
                                <span class="badge bg-primary">${customers.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Contact Info</th>
                                            <th style="width: 100px;">Orders</th>
                                            <th style="width: 100px;">Status</th>
                                            <th style="width: 150px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty customers}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-user bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No customers found</p>
                                                            <a href="${contextPath}/customer?action=add" class="btn btn-primary btn-sm mt-3">
                                                                <i class="bx bx-plus me-1"></i>Add First Customer
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="customer" items="${customers}" varStatus="loop">
                                                    <c:set var="orderCount" value="${requestScope['orderCount_'.concat(customer.id)]}" />
                                                    <tr class="${customer.status == 'Inactive' ? 'table-secondary' : ''}">
                                                        <td><strong>${loop.index + 1}</strong></td>
                                                        <td>
                                                            <span class="fw-medium">${customer.code}</span>
                                                        </td>
                                                        <td>${customer.name}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty customer.contactInfo}">
                                                                    <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                                          title="${customer.contactInfo}">
                                                                        ${customer.contactInfo}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-label-${orderCount > 0 ? 'info' : 'secondary'}">
                                                                ${orderCount} order(s)
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${customer.status == 'Active'}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                <a href="${contextPath}/customer?action=edit&id=${customer.id}" 
                                                                   class="btn btn-sm btn-outline-primary" 
                                                                   data-bs-toggle="tooltip" title="Edit"
                                                                   aria-label="Edit customer">
                                                                    <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                </a>
                                                                <c:if test="${currentUser.role == 'Admin'}">
                                                                    <button type="button" 
                                                                            class="btn btn-sm ${customer.status == 'Active' ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                                            data-bs-toggle="modal" 
                                                                            data-bs-target="#toggleModal"
                                                                            data-customer-id="${customer.id}"
                                                                            data-customer-name="${customer.name}"
                                                                            data-customer-status="${customer.status}"
                                                                            title="${customer.status == 'Active' ? 'Deactivate' : 'Activate'}"
                                                                            aria-label="${customer.status == 'Active' ? 'Deactivate customer' : 'Activate customer'}">
                                                                        <i class="bx ${customer.status == 'Active' ? 'bx-block' : 'bx-check'}" aria-hidden="true"></i></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
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
    
    <!-- Toggle Status Confirmation Modal -->
    <c:if test="${currentUser.role == 'Admin'}">
        <div class="modal fade" id="toggleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bx bx-info-circle text-warning me-2"></i>Confirm Status Change
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="toggleMessage"></p>
                        <div class="alert alert-warning mb-0" id="toggleWarning" style="display: none;">
                            <i class="bx bx-info-circle me-1"></i>
                            <span id="toggleWarningText"></span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="toggleConfirmBtn" class="btn btn-warning">
                            <i class="bx bx-check me-1"></i>Confirm
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        // Toggle modal handler
        var toggleModal = document.getElementById('toggleModal');
        if (toggleModal) {
            toggleModal.addEventListener('show.bs.modal', function(event) {
                var button = event.relatedTarget;
                var customerId = button.getAttribute('data-customer-id');
                var customerName = button.getAttribute('data-customer-name');
                var customerStatus = button.getAttribute('data-customer-status');
                
                var isActive = customerStatus === 'Active';
                var action = isActive ? 'deactivate' : 'activate';
                var actionCapitalized = isActive ? 'Deactivate' : 'Activate';
                
                document.getElementById('toggleMessage').innerHTML = 
                    'Are you sure you want to <strong>' + action + '</strong> customer "<strong>' + customerName + '</strong>"?';
                
                var confirmBtn = document.getElementById('toggleConfirmBtn');
                confirmBtn.href = '${contextPath}/customer?action=toggle&id=' + customerId;
                confirmBtn.className = isActive ? 'btn btn-warning' : 'btn btn-success';
                confirmBtn.innerHTML = '<i class="bx bx-check me-1"></i>' + actionCapitalized;
                
                var warningDiv = document.getElementById('toggleWarning');
                var warningText = document.getElementById('toggleWarningText');
                
                if (isActive) {
                    warningDiv.style.display = 'block';
                    warningText.textContent = 'Inactive customers cannot have new sales orders created. Existing orders can still be processed.';
                } else {
                    warningDiv.style.display = 'none';
                }
            });
        }
        
        // Initialize tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function(tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>
