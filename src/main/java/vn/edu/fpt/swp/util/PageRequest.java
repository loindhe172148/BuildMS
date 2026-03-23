package vn.edu.fpt.swp.util;

/**
 * Pagination request model (1-based page index).
 */
public class PageRequest {
    public static final int DEFAULT_PAGE = 1;
    public static final int DEFAULT_SIZE = 10;
    public static final int MAX_SIZE = 100;

    private final int page;
    private final int size;

    public PageRequest(int page, int size) {
        this.page = Math.max(DEFAULT_PAGE, page);
        int resolvedSize = size <= 0 ? DEFAULT_SIZE : size;
        this.size = Math.min(resolvedSize, MAX_SIZE);
    }

    public static PageRequest of(int page, int size) {
        return new PageRequest(page, size);
    }

    public int getPage() {
        return page;
    }

    public int getSize() {
        return size;
    }

    public int getOffset() {
        return (page - 1) * size;
    }
}
