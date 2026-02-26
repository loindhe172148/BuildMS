<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!-- Navbar -->
<nav class="layout-navbar container-xxl navbar-detached navbar navbar-expand-xl align-items-center bg-navbar-theme" id="layout-navbar">
    <div class="layout-menu-toggle navbar-nav align-items-xl-center me-4 me-xl-0 d-xl-none">
        <a class="nav-item nav-link px-0 me-xl-6" href="javascript:void(0)" aria-label="Toggle navigation menu">
            <i class="icon-base bx bx-menu icon-md" aria-hidden="true"></i>
        </a>
    </div>

    <div class="navbar-nav-right d-flex align-items-center justify-content-end" id="navbar-collapse">
        <!-- Search -->
        <div class="navbar-nav align-items-center me-auto">
            <div class="nav-item d-flex align-items-center">
                <label for="global-search" class="w-px-22 h-px-22">
                    <i class="icon-base bx bx-search icon-md" aria-hidden="true"></i>
                    <span class="visually-hidden">Search</span>
                </label>
                <input type="text" class="form-control border-0 shadow-none ps-1 ps-sm-2 d-md-block d-none" 
                       placeholder="Search..." aria-label="Search the warehouse management system" id="global-search" />
            </div>
        </div>
        <!-- /Search -->

        <ul class="navbar-nav flex-row align-items-center ms-md-auto">
            <!-- Notifications -->
            <li class="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-2">
                <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown" 
                   data-bs-auto-close="outside" aria-expanded="false" aria-label="View notifications">
                    <span class="position-relative">
                        <i class="icon-base bx bx-bell icon-md" aria-hidden="true"></i>
                        <span class="badge rounded-pill bg-danger badge-dot badge-notifications border" aria-label="New notifications"></span>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end p-0">
                    <li class="dropdown-menu-header border-bottom">
                        <div class="dropdown-header d-flex align-items-center py-3">
                            <h6 class="mb-0 me-auto">Notifications</h6>
                            <div class="d-flex align-items-center h6 mb-0">
                                <span class="badge bg-label-primary me-2">0 New</span>
                                <a href="javascript:void(0)" class="dropdown-notifications-all p-2" data-bs-toggle="tooltip" 
                                   data-bs-placement="top" title="Mark all as read" aria-label="Mark all notifications as read">
                                    <i class="icon-base bx bx-envelope-open text-heading icon-md" aria-hidden="true"></i>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="dropdown-notifications-list scrollable-container">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item list-group-item-action dropdown-notifications-item">
                                <div class="d-flex">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="avatar">
                                            <span class="avatar-initial rounded-circle bg-label-info">
                                                <i class="icon-base bx bx-info-circle"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="small mb-1">No new notifications</h6>
                                        <small class="mb-0 d-block text-body">Check back later</small>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li class="border-top">
                        <div class="d-grid p-4">
                            <a class="btn btn-primary btn-sm d-flex" href="${contextPath}/notifications">
                                <small class="align-middle">View all notifications</small>
                            </a>
                        </div>
                    </li>
                </ul>
            </li>
            <!-- /Notifications -->

            <!-- User -->
            <li class="nav-item navbar-dropdown dropdown-user dropdown">
                <a class="nav-link dropdown-toggle hide-arrow p-0" href="javascript:void(0);" data-bs-toggle="dropdown" aria-label="Open user menu">
                    <div class="avatar avatar-online">
                        <span class="avatar-initial rounded-circle bg-label-primary">
                            <c:choose>
                                <c:when test="${not empty currentUser.name}">
                                    ${currentUser.name.substring(0,1).toUpperCase()}
                                </c:when>
                                <c:otherwise>
                                    ${currentUser.username.substring(0,1).toUpperCase()}
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="${contextPath}/profile">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3">
                                    <div class="avatar avatar-online">
                                        <span class="avatar-initial rounded-circle bg-label-primary">
                                            <c:choose>
                                                <c:when test="${not empty currentUser.name}">
                                                    ${currentUser.name.substring(0,1).toUpperCase()}
                                                </c:when>
                                                <c:otherwise>
                                                    ${currentUser.username.substring(0,1).toUpperCase()}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="mb-0">
                                        <c:choose>
                                            <c:when test="${not empty currentUser.name}">
                                                ${currentUser.name}
                                            </c:when>
                                            <c:otherwise>
                                                ${currentUser.username}
                                            </c:otherwise>
                                        </c:choose>
                                    </h6>
                                    <small class="text-body-secondary">${currentUser.role}</small>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li>
                        <div class="dropdown-divider my-1"></div>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${contextPath}/profile">
                            <i class="icon-base bx bx-user icon-md me-3"></i><span>My Profile</span>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${contextPath}/auth?action=changePassword">
                            <i class="icon-base bx bx-lock-alt icon-md me-3"></i><span>Change Password</span>
                        </a>
                    </li>
                    <li>
                        <div class="dropdown-divider my-1"></div>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${contextPath}/auth?action=logout">
                            <i class="icon-base bx bx-power-off icon-md me-3"></i><span>Log Out</span>
                        </a>
                    </li>
                </ul>
            </li>
            <!--/ User -->
        </ul>
    </div>
</nav>
<!-- / Navbar -->
