<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%--
    Delete Confirmation Modal Component
    
    Usage:
    1. Include this component in your page
    2. Add a button/link that triggers the modal:
       <a href="#" class="btn btn-danger" 
          data-bs-toggle="modal" 
          data-bs-target="#deleteModal"
          data-delete-url="${contextPath}/product?action=delete&id=${product.id}"
          data-item-name="${product.name}">
           Delete
       </a>
    
    The modal will automatically populate with the item name and form action.
--%>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-3">
                    <i class="bx bx-error-circle text-danger" style="font-size: 4rem;"></i>
                </div>
                <p class="text-center mb-0">
                    Are you sure you want to delete <strong id="deleteItemName"></strong>?
                </p>
                <p class="text-center text-muted small">
                    This action cannot be undone.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="bx bx-trash me-1"></i> Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var deleteModal = document.getElementById('deleteModal');
    if (deleteModal) {
        deleteModal.addEventListener('show.bs.modal', function(event) {
            var button = event.relatedTarget;
            var deleteUrl = button.getAttribute('data-delete-url');
            var itemName = button.getAttribute('data-item-name') || 'this item';
            
            document.getElementById('deleteItemName').textContent = itemName;
            document.getElementById('deleteForm').action = deleteUrl;
        });
    }
});
</script>
