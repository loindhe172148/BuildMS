# JSP Static Analysis Report — Smart WMS

**Date:** 2026-02-28  
**Scope:** All 53 feature JSP files under `src/main/webapp/WEB-INF/views/` (common files excluded)  
**Auditor:** Automated deep static analysis (EL/JSTL, XSS, CSRF, NPE, logic)

---

### 1.3 Systematic Unescaped Model Output (Medium Risk)

Affects nearly all list/detail views. Sampling the most dangerous patterns:

| Pattern | Affected Files | Impact | Fix |
|---------|---------------|--------|-----|
| `${data.sourceWarehouse.name}` | transfer views | Stored XSS if Admin injects malicious warehouse name | `<c:out value="..."/>` |
| `${data.creator.fullName}` | transfer, sales-order views | Same | `<c:out value="..."/>` |
| `${product.name}`, `${product.sku}` | product, inbound, outbound, movement views | Same | `<c:out value="..."/>` |
| `${customer.name}`, `${customer.contactInfo}` | customer, sales-order views | Same | `<c:out value="..."/>` |
| `${warehouse.name}`, `${warehouse.location}` | warehouse, transfer, inbound views | Same | `<c:out value="..."/>` |
| `${order.orderNo}` | sales-order views | Same | `<c:out value="..."/>` |

**Global fix:** Replace every `${model.property}` in HTML body/attributes with `<c:out value="${model.property}"/>`.


## 4. Hidden Field Manipulation

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 21 | **MEDIUM** | `transfer/list.jsp` | 166-167 | Approve form inline in table row: `<input type="hidden" name="id" value="${data.request.id}">`. User can modify the id via DevTools to approve any transfer | Privilege escalation — approve other transfers they shouldn't have access to | Server-side must re-validate that the user has permission for the specific resource ID |
| 22 | **MEDIUM** | `sales-order/list.jsp` | 165-166 | Confirm order form with hidden `id` — same manipulation risk | Confirm orders the user shouldn't access | Server-side authorization check per resource |
| 23 | **MEDIUM** | `transfer/view.jsp` | 88-89 | Approve form and reject modal both use hidden `id` field | ID tampering | Server-side validation |
| 24 | **MEDIUM** | `transfer/execute-outbound.jsp` | 191-192 | Hidden `productId[]` values sent alongside `pickedQty[]`. Attacker can add extra product IDs or modify quantities | Inventory manipulation — pick different products/quantities than intended | Server must validate productId belongs to request and pickedQty is within bounds |
| 25 | **MEDIUM** | `transfer/execute-inbound.jsp` | 181-182 | Hidden `productId[]` + `receivedQty[]` + `locationId[]` — all manipulable | Receive goods to unauthorized locations or inflate quantities | Server-side validation of all submitted arrays against the actual request items |

---

## 5. Possible NullPointerException

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 26 | **MEDIUM** | `transfer/view.jsp` | 174 | `${creator.fullName}` — no null guard on `creator`. If `createdBy` references a deleted user, NPE | 500 error page shown | Wrap in `<c:if test="${not empty creator}">` or `${not empty creator ? creator.fullName : 'Unknown'}` |
| 27 | **MEDIUM** | `transfer/view.jsp` | 195-206 | `${sourceWarehouse.name}`, `${sourceWarehouse.location}`, `${destinationWarehouse.name}`, `${destinationWarehouse.location}` — no null guards | 500 error if warehouse deleted | Wrap each in `<c:if test="${not empty sourceWarehouse}">` |
| 28 | **MEDIUM** | `outbound/details.jsp` | 157 | `${sourceWarehouse.name}` — no null check | 500 error | Add null guard |
| 29 | **MEDIUM** | `outbound/details.jsp` | 163 | `${createdByUser.fullName}` — no null check | 500 error | Add null guard |
| 30 | **MEDIUM** | `sales-order/view.jsp` | 192-198 | `${customer.code}`, `${customer.name}`, `${customer.contactInfo}` — no null guard on `customer` object | 500 error if customer deleted | Wrap in `<c:if test="${not empty customer}">` |
| 31 | **MEDIUM** | `inbound/list.jsp` | 131 | `${requests.size()}` — if `requests` is null, NPE | 500 error | Use `${not empty requests ? requests.size() : 0}` or `${fn:length(requests)}` |
| 32 | **MEDIUM** | `outbound/list.jsp` | 131 | `${requests.size()}` — same null risk | 500 error | Same fix as #31 |
| 33 | **MEDIUM** | `movement/list.jsp` | 127 | `${requests.size()}` — same null risk | 500 error | Same fix as #31 |
| 34 | **MEDIUM** | `movement/execute.jsp` | 156 | `${itemsWithDetails.size()}` — null risk | 500 error | Same fix |
| 35 | **MEDIUM** | `transfer/list.jsp` | 155-156 | `<fmt:parseDate value="${data.request.createdAt}" ...>` — if `createdAt` is null, `fmt:parseDate` throws ParseException | 500 error | Wrap in `<c:if test="${not empty data.request.createdAt}">` |
| 36 | **LOW** | `transfer/execute-outbound.jsp` | 139 | `${check.product.sku}` used without null guard after line 136 checks `check.product` for name but SKU line has no guard | NPE if product is null | Add `<c:if test="${not empty check.product}">` around SKU output too |
| 37 | **MEDIUM** | `inbound/details.jsp` | 305 | `${inboundRequest.rejectedDate.toLocalDate()}` — `rejectedDate` could be null even when status is Rejected if DB column wasn't populated | NPE | Wrap in `<c:if test="${not empty inboundRequest.rejectedDate}">` |

---

## 6. EL / JSTL Issues

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 38 | **HIGH** | `outbound/details.jsp` | 15 | `<jsp:param name="pageTitle" value="Outbound Request #${request.id}" />` — `request` resolves to the implicit `HttpServletRequest` object, not the outbound request. `HttpServletRequest` has no `id` property → renders as empty | Page title shows "Outbound Request #" with no ID | Change to `value="Outbound Request #${outboundRequest.id}"` |
| 39 | **LOW** | `transfer/execute-outbound.jsp` | 130 | `<c:set var="allAvailable" value="true" />` — sets a String `"true"`, not Boolean. The `<c:when test="${allAvailable}">` coercion works, but `<c:set var="allAvailable" value="false" />` inside the loop overwrites it as String `"false"`. This is fragile. | Works by accident through EL coercion but is non-idiomatic and confusing | Use `<c:set var="allAvailable" value="${true}" />` and `<c:set var="allAvailable" value="${false}" />` for proper boolean types |
| 40 | **LOW** | `transfer/execute-outbound.jsp` | 166 | Same pattern: `<c:set var="allAvailable2" value="true"/>` / `"false"` | Same fragility | Same fix |
| 41 | **LOW** | `transfer/create.jsp` | 2 | `<%@ page import="java.net.URLEncoder" %>` — unused Java import (no scriptlet usage) | Dead code / potential confusion | Remove the import directive |

---

## 7. Conditional Rendering Logic Issues

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 42 | **MEDIUM** | `transfer/view.jsp` | 216-231 | `colspan="6"` on the empty-items row, but the actual column count varies dynamically (4-6 columns depending on status due to conditional `<th>` elements for Picked/Received columns) | Table layout breaks — empty row doesn't span full width when status shows extra columns | Compute colspan dynamically or use a fixed max-column approach |
| 43 | **LOW** | `movement/list.jsp` | 79 | "Create Movement" button shown to ALL roles (no role check), but per design only Admin/Manager/Staff should create movements | All authenticated users see the button (Sales role too) — server rejects, but confusing UX | Add `<c:if test="${currentUser.role == 'Admin' \|\| currentUser.role == 'Manager' \|\| currentUser.role == 'Staff'}">` |
| 44 | **LOW** | `customer/edit.jsp` | 170-183 | Toggle customer status uses GET links (`<a href="...?action=toggle&id=...">`) for a state-changing operation | GET requests can be triggered by link prefetch, bookmarks, or crawlers — accidental state changes. Also CSRF-trivial via `<img src>`. | Change to POST form with button |
| 45 | **MEDIUM** | `sales-order/view.jsp` | 165 | Cancel button rendered when status is not Completed/Cancelled, but `FulfillmentRequested` status should arguably not allow Cancel from UI since outbound requests exist | Business logic leak — user may cancel order with active outbound requests | Add `order.status != 'FulfillmentRequested'` to the condition, or rely on the cancel.jsp validation (which does check) |

---

## 8. Incorrect Dynamic URL Generation

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 46 | **LOW** | `sales-order/generate-outbound.jsp` | 106 | `${warehouse.name} (${warehouse.code})` — `Warehouse` model has no `code` property per the model spec (only `id`, `name`, `location`, `createdAt`) | Renders as empty `()` after warehouse name | Change to `${warehouse.location}` or remove `(${warehouse.code})` |
| 47 | **LOW** | `outbound/details.jsp` | ~339 | Related request "View" link goes to `?action=view` but OutboundController may not have a `view` action (it uses `details`) | 404 or blank page when clicking View on related outbound request | Change to `?action=details` |

---

## 9. Form Binding Issues

| # | Severity | File | Line(s) | Issue | Impact | Suggested Fix |
|---|----------|------|---------|-------|--------|---------------|
| 48 | **MEDIUM** | `inbound/execute.jsp` | ~155 | Location `<select name="locationId">` has no `required` attribute. User can submit empty location for received items. | Inventory received with no location — data integrity issue | Add `required` attribute to the select, or validate server-side that locationId is not empty |
| 49 | **MEDIUM** | `inbound/create.jsp` | 142 | `<input type="text" name="locationId" placeholder="Optional" />` — locationId is sent as a text string, but LocationId should be a numeric foreign key | Server receives arbitrary text instead of a valid location ID — may cause SQL errors or silent failures | Use a `<select>` dropdown populated with valid locations, or validate input as numeric on server side |
| 50 | **LOW** | `transfer/execute-inbound.jsp` | 181 | `receivedQty[]` default value is `${data.item.quantity}` (the original requested qty), not `${data.item.pickedQuantity}`. User might receive more than was picked. | Inventory inflation if user doesn't adjust. Picked was 5, they receive 10 by default. | Default to `${data.item.pickedQuantity != null ? data.item.pickedQuantity : data.item.quantity}` and set `max="${data.item.pickedQuantity}"` |

---

## 10. Missing `fmt` Taglib Declaration

| # | Severity | File(s) | Issue | Suggested Fix |
|---|----------|---------|-------|---------------|
| 51 | **LOW** | `inbound/details.jsp`, `inbound/execute.jsp`, `inbound/create.jsp` | Missing `<%@ taglib prefix="fmt" ...%>`. These files use `.toLocalDate()` EL method directly instead of `<fmt:formatDate>`, which works but formatting is inconsistent across the app | Add `<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>` and use `<fmt:formatDate>` for consistent date formatting |

---
