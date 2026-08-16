package com.example.empassign.controller;

import com.example.empassign.dao.AffectationDao;
import com.example.empassign.dao.EmployeeDao;
import com.example.empassign.dao.LieuDao;
import com.example.empassign.model.Affectation;
import com.example.empassign.model.AffectationId;
import com.example.empassign.model.Employee;
import com.example.empassign.model.Lieu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "AffectationServlet", urlPatterns = { "/affectations" })
public class AffectationServlet extends HttpServlet {
    private final AffectationDao affectationDao = new AffectationDao();
    private final EmployeeDao employeeDao = new EmployeeDao();
    private final LieuDao lieuDao = new LieuDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String codeemp = request.getParameter("codeemp");
            String codelieu = request.getParameter("codelieu");
            if (codeemp != null && codelieu != null && !codeemp.isEmpty() && !codelieu.isEmpty()) {
                Affectation affectation = affectationDao
                        .findById(new AffectationId(Integer.valueOf(codeemp), Integer.valueOf(codelieu)));
                if (affectation != null) {
                    affectationDao.delete(affectation);
                }
            }
        }

        List<Affectation> affectations = affectationDao.findAll();
        request.setAttribute("affectations", affectations);
        request.setAttribute("employees", employeeDao.findAll());
        request.setAttribute("lieux", lieuDao.findAll());
        request.getRequestDispatcher("/WEB-INF/views/affectations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String codeemp = request.getParameter("codeemp");
        String codelieu = request.getParameter("codelieu");
        String date = request.getParameter("date");

        if (codeemp != null && codelieu != null && !codeemp.isEmpty() && !codelieu.isEmpty() && date != null
                && !date.isEmpty()) {
            Employee employee = employeeDao.findById(Integer.valueOf(codeemp));
            Lieu lieu = lieuDao.findById(Integer.valueOf(codelieu));
            if (employee != null && lieu != null) {
                Affectation affectation = new Affectation(employee, lieu, LocalDate.parse(date));
                affectationDao.save(affectation);
            }
        }

        response.sendRedirect("affectations");
    }
}
