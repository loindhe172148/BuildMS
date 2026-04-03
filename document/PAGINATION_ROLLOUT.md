# Pagination Rollout Guide

## Scope
Pagination has been integrated across list/search flows in the application, including:
- Catalog/Setup: Product, Category, Customer, Warehouse, Location, User
- Operations: Inbound, Outbound, Movement, Transfer
- Sales: Sales Order list
- Inventory: Search, By Warehouse, By Product

## Shared Pattern
### Utility classes
- `vn.edu.fpt.swp.util.PageRequest`
- `vn.edu.fpt.swp.util.PageResult<T>`
- `vn.edu.fpt.swp.util.PaginationUtil`

### Controller contract
Controllers should set these request attributes for JSP pages:
- `currentPage`
- `totalPages`
- `pageSize`
- `totalItems`
- `paginationBaseUrl`

### DAO contract
For SQL Server paging use:
1. `COUNT(*)` query over the same filters
2. Data query with `ORDER BY ... OFFSET ? ROWS FETCH NEXT ? ROWS ONLY`

## URL Parameters
- `page`: 1-based page index
- `size`: page size (default handled by `PageRequest`)
- Existing filters are preserved in `paginationBaseUrl`

## JSP Integration
Use the shared component:
```jsp
<jsp:include page="/WEB-INF/common/pagination.jsp">
    <jsp:param name="currentPage" value="${currentPage}" />
    <jsp:param name="totalPages" value="${totalPages}" />
    <jsp:param name="baseUrl" value="${paginationBaseUrl}" />
</jsp:include>
```

## Notes
- Role-based access behavior remains unchanged.
- Build verification passed with `mvn -q -DskipTests compile` after rollout.
- When adding new list/search pages, follow the same DAO → Service → Controller → JSP pagination chain.
