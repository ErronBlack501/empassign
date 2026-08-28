package com.example.empassign.model;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "lieu")
public class Lieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "codelieu")
    private Integer codelieu;

    @Column(name = "designation", nullable = false)
    private String designation;

    @Column(name = "province")
    private String province;

    @OneToMany(mappedBy = "lieu", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Affectation> affectations = new ArrayList<>();

    public Lieu() {
    }

    public Lieu(Integer codelieu, String designation, String province) {
        this.codelieu = codelieu;
        this.designation = designation;
        this.province = province;
    }

    public Integer getCodelieu() {
        return codelieu;
    }

    public void setCodelieu(Integer codelieu) {
        this.codelieu = codelieu;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public List<Affectation> getAffectations() {
        return affectations;
    }

    public void setAffectations(List<Affectation> affectations) {
        this.affectations = affectations;
    }
}
