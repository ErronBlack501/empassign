package com.example.empassign;

import com.example.empassign.util.SearchQueryUtil;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SearchQueryUtilTest {

    @Test
    void shouldTrimAndNormalizeKeyword() {
        assertEquals("alex", SearchQueryUtil.normalizeKeyword("  ALEX  "));
        assertEquals("muller", SearchQueryUtil.normalizeKeyword("  MULLER "));
    }

    @Test
    void shouldDetectNumericCodeSearch() {
        assertTrue(SearchQueryUtil.isNumericCode("123"));
    }
}
