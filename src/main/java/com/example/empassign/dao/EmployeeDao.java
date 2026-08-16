package com.example.empassign.dao;

import com.example.empassign.model.Employee;
import com.example.empassign.util.HibernateUtil;
import com.example.empassign.util.SearchQueryUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class EmployeeDao {

    public void save(Employee employee) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(employee);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Employee> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Employee> query = em.createQuery("SELECT e FROM Employee e ORDER BY e.codeemp", Employee.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Employee findById(Integer codeemp) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.find(Employee.class, codeemp);
        } finally {
            em.close();
        }
    }

    public void update(Employee employee) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(employee);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void delete(Employee employee) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Employee managed = em.find(Employee.class, employee.getCodeemp());
            if (managed != null) {
                em.remove(managed);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Employee> searchByCodeOrName(String keyword) {
        String normalized = SearchQueryUtil.normalizeKeyword(keyword);
        if (normalized.isEmpty()) {
            return findAll();
        }

        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Employee> query;
            if (SearchQueryUtil.isNumericCode(normalized)) {
                query = em.createQuery(
                        "SELECT e FROM Employee e WHERE e.codeemp = :code ORDER BY e.codeemp",
                        Employee.class);
                query.setParameter("code", Integer.valueOf(normalized));
            } else {
                query = em.createQuery(
                        "SELECT e FROM Employee e WHERE LOWER(e.nom) LIKE :kw OR LOWER(e.prenom) LIKE :kw ORDER BY e.codeemp",
                        Employee.class);
                query.setParameter("kw", "%" + normalized + "%");
            }
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
