package com.example.empassign.controller;

import com.example.empassign.dao.EmployeeDao;
import com.example.empassign.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployeeServlet", urlPatterns = { "/employees" })
public class EmployeeServlet extends HttpServlet {
    private final EmployeeDao employeeDao = new EmployeeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Employee selectedEmployee = null;

        if ("delete".equals(action)) {
            String code = request.getParameter("code");
            if (code != null && !code.isEmpty()) {
                Employee employee = employeeDao.findById(Integer.valueOf(code));
                if (employee != null) {
                    employeeDao.delete(employee);
                }
            }
        } else if ("read".equals(action) || "edit".equals(action)) {
            String code = request.getParameter("code");
            if (code != null && !code.isEmpty()) {
                selectedEmployee = employeeDao.findById(Integer.valueOf(code));
            }
        }

        String keyword = request.getParameter("keyword");
        List<Employee> employees;
        if (keyword != null && !keyword.trim().isEmpty()) {
            employees = employeeDao.searchByCodeOrName(keyword.trim());
        } else {
            employees = employeeDao.findAll();
        }

        request.setAttribute("employees", employees);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("selectedEmployee", selectedEmployee);
        request.setAttribute("action", action);
        request.getRequestDispatcher("/WEB-INF/views/employees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("formAction");
        String code = request.getParameter("codeemp");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String poste = request.getParameter("poste");

        if (nom != null && !nom.trim().isEmpty()) {
            if ("update".equals(action) && code != null && !code.isEmpty()) {
                Employee employee = new Employee(Integer.valueOf(code), nom, prenom, poste);
                employeeDao.update(employee);
            } else {
                Employee employee = new Employee(null, nom, prenom, poste);
                employeeDao.save(employee);
            }
        }

        response.sendRedirect("employees");
    }
}
