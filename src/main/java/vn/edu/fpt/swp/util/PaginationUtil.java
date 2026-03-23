package vn.edu.fpt.swp.util;

import jakarta.servlet.http.HttpServletRequest;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

/**
 * Helpers for pagination parameter parsing and URL creation.
 */
public final class PaginationUtil {
    private PaginationUtil() {
    }

    public static PageRequest resolvePageRequest(HttpServletRequest request) {
        int page = parsePositiveInt(request.getParameter("page"), PageRequest.DEFAULT_PAGE);
        int size = parsePositiveInt(request.getParameter("size"), PageRequest.DEFAULT_SIZE);
        return PageRequest.of(page, size);
    }

    public static String buildBaseUrl(HttpServletRequest request, String servletPath, Map<String, String> params) {
        return buildBaseUrl(request, servletPath, "list", params);
    }

    public static String buildBaseUrl(HttpServletRequest request, String servletPath, String action,
                                      Map<String, String> params) {
        StringBuilder baseUrl = new StringBuilder(request.getContextPath())
            .append(servletPath)
            .append("?action=")
            .append(action);

        if (params != null) {
            for (Map.Entry<String, String> entry : params.entrySet()) {
                String value = entry.getValue();
                if (value == null || value.trim().isEmpty()) {
                    continue;
                }
                baseUrl.append('&')
                    .append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8))
                    .append('=')
                    .append(URLEncoder.encode(value.trim(), StandardCharsets.UTF_8));
            }
        }

        return baseUrl.toString();
    }

    public static int parsePositiveInt(String value, int fallback) {
        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }

        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
