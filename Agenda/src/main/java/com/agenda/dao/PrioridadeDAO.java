package com.agenda.dao;

import com.agenda.config.DBConnection;
import com.agenda.model.Prioridade;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrioridadeDAO {

    public List<Prioridade> findAll() {
        List<Prioridade> list = new ArrayList<>();
        String sql = "SELECT id, nome, cor FROM prioridades ORDER BY id";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Prioridade(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getString("cor")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}