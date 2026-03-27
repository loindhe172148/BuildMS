package vn.edu.fpt.swp.util;

import java.util.Collections;
import java.util.List;

/**
 * Pagination result wrapper.
 */
public class PageResult<T> {
    private final List<T> items;
    private final int currentPage;
    private final int pageSize;
    private final long totalItems;
    private final int totalPages;

    public PageResult(List<T> items, int currentPage, int pageSize, long totalItems) {
        this.items = items != null ? items : Collections.emptyList();
        this.currentPage = Math.max(PageRequest.DEFAULT_PAGE, currentPage);
        this.pageSize = Math.max(1, pageSize);
        this.totalItems = Math.max(0L, totalItems);
        this.totalPages = (int) Math.max(1L, (long) Math.ceil((double) this.totalItems / this.pageSize));
    }

    public static <T> PageResult<T> of(List<T> items, long totalItems, PageRequest pageRequest) {
        return new PageResult<>(items, pageRequest.getPage(), pageRequest.getSize(), totalItems);
    }

    public List<T> getItems() {
        return items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public int getTotalPages() {
        return totalPages;
    }
}
