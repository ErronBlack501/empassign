package com.example.empassign.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;

public class HibernateUtil {
    private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = createEntityManagerFactory();

    private HibernateUtil() {
    }

    private static EntityManagerFactory createEntityManagerFactory() {
        Map<String, Object> properties = new HashMap<>();
        properties.put("jakarta.persistence.jdbc.url", jdbcUrl());
        properties.put("jakarta.persistence.jdbc.user", environment("DB_USER", "empassign"));
        properties.put("jakarta.persistence.jdbc.password", environment("DB_PASSWORD", "empassign"));
        return Persistence.createEntityManagerFactory("default", properties);
    }

    private static String jdbcUrl() {
        String host = environment("DB_HOST", "mysql");
        String port = environment("DB_PORT", "3306");
        return "jdbc:mysql://" + host + ":" + port
                + "/empassign?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    }

    private static String environment(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? defaultValue : value;
    }

    public static EntityManager getEntityManager() {
        return ENTITY_MANAGER_FACTORY.createEntityManager();
    }

    public static void close() {
        if (ENTITY_MANAGER_FACTORY != null && ENTITY_MANAGER_FACTORY.isOpen()) {
            ENTITY_MANAGER_FACTORY.close();
        }
    }
}
