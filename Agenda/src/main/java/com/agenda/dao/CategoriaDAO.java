package com.agenda.dao;

import com.agenda.config.DBConnection;
import com.agenda.model.Categoria;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> findAll() {
        List<Categoria> list = new ArrayList<>();
        String sql = "SELECT id, nome FROM categorias ORDER BY nome";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Categoria(
                        rs.getInt("id"),
                        rs.getString("nome")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}