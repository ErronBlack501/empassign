package com.example.empassign.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class AffectationId implements Serializable {

    @Column(name = "codeemp")
    private Integer codeemp;

    @Column(name = "codelieu")
    private Integer codelieu;

    public AffectationId() {
    }

    public AffectationId(Integer codeemp, Integer codelieu) {
        this.codeemp = codeemp;
        this.codelieu = codelieu;
    }

    public Integer getCodeemp() {
        return codeemp;
    }

    public void setCodeemp(Integer codeemp) {
        this.codeemp = codeemp;
    }

    public Integer getCodelieu() {
        return codelieu;
    }

    public void setCodelieu(Integer codelieu) {
        this.codelieu = codelieu;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        AffectationId that = (AffectationId) o;
        return Objects.equals(codeemp, that.codeemp) && Objects.equals(codelieu, that.codelieu);
    }

    @Override
    public int hashCode() {
        return Objects.hash(codeemp, codelieu);
    }
}
