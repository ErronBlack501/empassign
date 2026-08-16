package com.example.empassign.util;

public final class SearchQueryUtil {

    private SearchQueryUtil() {
    }

    public static String normalizeKeyword(String keyword) {
        if (keyword == null) {
            return "";
        }
        return keyword.trim().toLowerCase();
    }

    public static boolean isNumericCode(String value) {
        if (value == null) {
            return false;
        }
        return value.trim().matches("\\d+");
    }
}
