package com.example.empassign.dao;

import com.example.empassign.model.Affectation;
import com.example.empassign.model.AffectationId;
import com.example.empassign.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class AffectationDao {

    public void save(Affectation affectation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(affectation);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Affectation> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Affectation> query = em.createQuery(
                    "SELECT DISTINCT a FROM Affectation a JOIN FETCH a.employee e JOIN FETCH a.lieu l ORDER BY a.date",
                    Affectation.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Affectation findById(AffectationId id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Affectation> query = em.createQuery(
                    "SELECT a FROM Affectation a JOIN FETCH a.employee e JOIN FETCH a.lieu l WHERE a.id = :id",
                    Affectation.class);
            query.setParameter("id", id);
            return query.getResultList().stream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }

    public void update(Affectation affectation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(affectation);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void delete(Affectation affectation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Affectation managed = em.find(Affectation.class, affectation.getId());
            if (managed != null) {
                em.remove(managed);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
