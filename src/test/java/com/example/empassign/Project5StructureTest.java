package com.example.empassign;

import com.example.empassign.model.Affectation;
import com.example.empassign.model.Employee;
import com.example.empassign.model.Lieu;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class Project5StructureTest {

    @Test
    public void entities_should_be_present() {
        assertNotNull(Employee.class);
        assertNotNull(Lieu.class);
        assertNotNull(Affectation.class);
    }

    @Test
    public void mysql_persistence_should_be_configured() throws IOException {
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("META-INF/persistence.xml");
        assertNotNull(inputStream, "persistence.xml should be present");

        String xml = readFully(inputStream);
        assertTrue(xml.contains("mysql"), "The persistence configuration should target MySQL");
        assertTrue(xml.contains("hibernate.dialect"),
                "The persistence configuration should declare a Hibernate dialect");
        assertTrue(xml.contains("jakarta.persistence.jdbc.url"),
                "The persistence configuration should include JDBC URL");
    }

    private String readFully(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[4096];
        int read;
        while ((read = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, read);
        }
        return new String(buffer.toByteArray(), StandardCharsets.UTF_8);
    }
}
