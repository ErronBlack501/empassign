package com.example.empassign.dao;

import com.example.empassign.model.Lieu;
import com.example.empassign.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class LieuDao {

    public void save(Lieu lieu) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(lieu);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Lieu> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Lieu> query = em.createQuery("SELECT l FROM Lieu l ORDER BY l.codelieu", Lieu.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Lieu findById(Integer codelieu) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.find(Lieu.class, codelieu);
        } finally {
            em.close();
        }
    }

    public void update(Lieu lieu) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(lieu);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void delete(Lieu lieu) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Lieu managed = em.find(Lieu.class, lieu.getCodelieu());
            if (managed != null) {
                em.remove(managed);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
