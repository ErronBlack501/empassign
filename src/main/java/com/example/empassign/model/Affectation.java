package com.example.empassign.model;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "affecter")
public class Affectation {

    @EmbeddedId
    private AffectationId id;

    @MapsId("codeemp")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "codeemp", nullable = false)
    private Employee employee;

    @MapsId("codelieu")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "codelieu", nullable = false)
    private Lieu lieu;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    public Affectation() {
    }

    public Affectation(Employee employee, Lieu lieu, LocalDate date) {
        this.employee = employee;
        this.lieu = lieu;
        this.date = date;
        this.id = new AffectationId(employee.getCodeemp(), lieu.getCodelieu());
    }

    public AffectationId getId() {
        return id;
    }

    public void setId(AffectationId id) {
        this.id = id;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
        if (this.id == null) {
            this.id = new AffectationId();
        }
        this.id.setCodeemp(employee != null ? employee.getCodeemp() : null);
    }

    public Lieu getLieu() {
        return lieu;
    }

    public void setLieu(Lieu lieu) {
        this.lieu = lieu;
        if (this.id == null) {
            this.id = new AffectationId();
        }
        this.id.setCodelieu(lieu != null ? lieu.getCodelieu() : null);
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }
}
