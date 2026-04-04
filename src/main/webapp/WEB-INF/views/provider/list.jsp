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
        <jsp:param name="pageTitle" value="Provider List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="providers" />
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
                                <li class="breadcrumb-item active" aria-current="page">Providers</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                <c:out value="${sessionScope.successMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                <c:out value="${sessionScope.errorMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bx bx-info-circle me-2"></i>
                                <c:out value="${sessionScope.warningMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="warningMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-store me-2"></i>Provider Management
                            </h4>
                            <a href="${contextPath}/provider?action=add" class="btn btn-primary">
                                <i class="bx bx-plus me-1"></i>Add Provider
                            </a>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/provider" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Search by Code/Name -->
                                    <div class="col-md-5">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="<c:out value='${keyword}'/>" placeholder="Search by code or name..." />
                                        </div>
                                    </div>
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="Active" <c:out value="${status == 'Active' ? 'selected' : ''}"/>>Active</option>
                                            <option value="Inactive" <c:out value="${status == 'Inactive' ? 'selected' : ''}"/>>Inactive</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-outline-primary w-100">
                                            <i class="bx bx-filter-alt me-1"></i>Filter
                                        </button>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <a href="${contextPath}/provider?action=list" class="btn btn-outline-secondary w-100">
                                            <i class="bx bx-reset me-1"></i>Reset
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Providers Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Providers</h5>
                                <span class="badge bg-primary"><c:out value="${totalItems}"/> total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Contact Info</th>
                                            <th style="width: 100px;">Status</th>
                                            <th style="width: 150px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty providers}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-store bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No providers found</p>
                                                            <a href="${contextPath}/provider?action=add" class="btn btn-primary btn-sm mt-3">
                                                                <i class="bx bx-plus me-1"></i>Add First Provider
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="provider" items="${providers}" varStatus="loop">
                                                    <tr class="${provider.status == 'Inactive' ? 'table-secondary' : ''}">
                                                        <td><strong><c:out value="${(currentPage - 1) * pageSize + loop.index + 1}"/></strong></td>
                                                        <td>
                                                            <span class="fw-medium"><c:out value="${provider.code}"/></span>
                                                        </td>
                                                        <td><c:out value="${provider.name}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty provider.contactInfo}">
                                                                    <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                                          title="${fn:escapeXml(provider.contactInfo)}">
                                                                        <c:out value="${provider.contactInfo}"/>
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${provider.status == 'Active'}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                <a href="${contextPath}/provider?action=edit&id=${provider.id}" 
                                                                   class="btn btn-sm btn-outline-primary" 
                                                                   data-bs-toggle="tooltip" title="Edit"
                                                                   aria-label="Edit provider">
                                                                    <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-sm ${provider.status == 'Active' ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                                        data-bs-toggle="modal" 
                                                                        data-bs-target="#toggleModal"
                                                                        data-provider-id="<c:out value='${provider.id}'/>"
                                                                        data-provider-name="<c:out value='${provider.name}'/>"
                                                                        data-provider-status="<c:out value='${provider.status}'/>"
                                                                        title="${provider.status == 'Active' ? 'Deactivate' : 'Activate'}"
                                                                        aria-label="${provider.status == 'Active' ? 'Deactivate provider' : 'Activate provider'}">
                                                                    <i class="bx ${provider.status == 'Active' ? 'bx-block' : 'bx-check'}" aria-hidden="true"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${not empty providers}">
                                <div class="card-footer border-top">
                                    <jsp:include page="/WEB-INF/common/pagination.jsp">
                                        <jsp:param name="currentPage" value="${currentPage}" />
                                        <jsp:param name="totalPages" value="${totalPages}" />
                                        <jsp:param name="baseUrl" value="${paginationBaseUrl}" />
                                    </jsp:include>
                                </div>
                            </c:if>
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
    
    <!-- Toggle Status Confirmation Modal -->
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
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        // Toggle modal handler
        var toggleModal = document.getElementById('toggleModal');
        if (toggleModal) {
            toggleModal.addEventListener('show.bs.modal', function(event) {
                var button = event.relatedTarget;
                var providerId = button.getAttribute('data-provider-id');
                var providerName = button.getAttribute('data-provider-name');
                var providerStatus = button.getAttribute('data-provider-status');
                
                var isActive = providerStatus === 'Active';
                var action = isActive ? 'deactivate' : 'activate';
                var actionCapitalized = isActive ? 'Deactivate' : 'Activate';
                
                document.getElementById('toggleMessage').innerHTML = 
                    'Are you sure you want to <strong>' + action + '</strong> provider "<strong>' + providerName + '</strong>"?';
                
                var confirmBtn = document.getElementById('toggleConfirmBtn');
                confirmBtn.href = '${contextPath}/provider?action=toggle&id=' + providerId;
                confirmBtn.className = isActive ? 'btn btn-warning' : 'btn btn-success';
                confirmBtn.innerHTML = '<i class="bx bx-check me-1"></i>' + actionCapitalized;
                
                var warningDiv = document.getElementById('toggleWarning');
                var warningText = document.getElementById('toggleWarningText');
                
                if (isActive) {
                    warningDiv.style.display = 'block';
                    warningText.textContent = 'Inactive providers cannot be selected for new inbound requests. Existing requests remain unchanged.';
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
