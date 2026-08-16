package com.example.empassign.model;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "employe")
public class Employee {

    @Id
    @Column(name = "codeemp")
    private Integer codeemp;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "prenom")
    private String prenom;

    @Column(name = "poste")
    private String poste;

    @OneToMany(mappedBy = "employee", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Affectation> affectations = new ArrayList<>();

    public Employee() {
    }

    public Employee(Integer codeemp, String nom, String prenom, String poste) {
        this.codeemp = codeemp;
        this.nom = nom;
        this.prenom = prenom;
        this.poste = poste;
    }

    public Integer getCodeemp() {
        return codeemp;
    }

    public void setCodeemp(Integer codeemp) {
        this.codeemp = codeemp;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public List<Affectation> getAffectations() {
        return affectations;
    }

    public void setAffectations(List<Affectation> affectations) {
        this.affectations = affectations;
    }
}
