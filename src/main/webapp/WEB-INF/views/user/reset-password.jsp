<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact"
      data-assets-path="${contextPath}/assets/"
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Reset Password" />
    </jsp:include>
</head>
<body>
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">

            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="users" />
                <jsp:param name="activeSubMenu" value="user-list" />
            </jsp:include>

            <div class="layout-page">
                <jsp:include page="/WEB-INF/common/navbar.jsp" />

                <div class="content-wrapper">
                    <main class="container-xxl flex-grow-1 container-p-y">
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />

                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">
                                            <i class="bx bx-lock-open me-2"></i>Reset Password for <c:out value="${targetUser.username}"/>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="${contextPath}/user" method="post">
                                            <input type="hidden" name="action" value="resetPassword" />
                                            <input type="hidden" name="id" value="${targetUser.id}" />

                                            <div class="mb-3">
                                                <label class="form-label">Username</label>
                                                <input type="text" class="form-control" value="<c:out value='${targetUser.username}'/>" disabled />
                                            </div>

                                            <div class="mb-3">
                                                <label for="newPassword" class="form-label">
                                                    New Password <span class="text-danger">*</span>
                                                </label>
                                                <input type="password" class="form-control" id="newPassword" 
                                                       name="newPassword" minlength="6" required 
                                                       placeholder="At least 6 characters" />
                                            </div>

                                            <div class="mb-4">
                                                <label for="confirmPassword" class="form-label">
                                                    Confirm Password <span class="text-danger">*</span>
                                                </label>
                                                <input type="password" class="form-control" id="confirmPassword" 
                                                       name="confirmPassword" minlength="6" required 
                                                       placeholder="Re-enter password" />
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-check me-1"></i>Reset Password
                                                </button>
                                                <a href="${contextPath}/user?action=edit&id=${targetUser.id}" class="btn btn-outline-secondary">
                                                    Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <jsp:include page="/WEB-INF/common/footer.jsp" />
                    <div class="content-backdrop fade"></div>
                </div>
            </div>
        </div>
        <div class="layout-overlay layout-menu-toggle"></div>
    </div>

    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
