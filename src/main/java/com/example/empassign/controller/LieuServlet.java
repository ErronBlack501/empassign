package com.example.empassign.controller;

import com.example.empassign.dao.LieuDao;
import com.example.empassign.model.Lieu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LieuServlet", urlPatterns = { "/lieux" })
public class LieuServlet extends HttpServlet {
    private final LieuDao lieuDao = new LieuDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Lieu selectedLieu = null;

        if ("delete".equals(action)) {
            String code = request.getParameter("code");
            if (code != null && !code.isEmpty()) {
                Lieu lieu = lieuDao.findById(Integer.valueOf(code));
                if (lieu != null) {
                    lieuDao.delete(lieu);
                }
            }
        } else if ("read".equals(action) || "edit".equals(action)) {
            String code = request.getParameter("code");
            if (code != null && !code.isEmpty()) {
                selectedLieu = lieuDao.findById(Integer.valueOf(code));
            }
        }

        List<Lieu> lieux = lieuDao.findAll();
        request.setAttribute("lieux", lieux);
        request.setAttribute("selectedLieu", selectedLieu);
        request.setAttribute("action", action);
        request.getRequestDispatcher("/WEB-INF/views/lieux.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("formAction");
        String code = request.getParameter("codelieu");
        String designation = request.getParameter("designation");
        String province = request.getParameter("province");

        if (designation != null && !designation.trim().isEmpty()) {
            if ("update".equals(action) && code != null && !code.isEmpty()) {
                Lieu lieu = new Lieu(Integer.valueOf(code), designation, province);
                lieuDao.update(lieu);
            } else {
                Lieu lieu = new Lieu(null, designation, province);
                lieuDao.save(lieu);
            }
        }

        response.sendRedirect("lieux");
    }
}
