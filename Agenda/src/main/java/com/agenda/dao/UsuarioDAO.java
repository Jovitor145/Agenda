package com.agenda.dao;

import com.agenda.config.DBConnection;
import com.agenda.model.Usuario;
import java.sql.*;

public class UsuarioDAO {

    // Busca apenas por email
    public Usuario findByEmail(String email) {
        String sql = "SELECT id, nome, email, senha FROM usuarios WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
                            rs.getInt("id"),
                            rs.getString("nome"),
                            rs.getString("email"),
                            rs.getString("senha") // Retorna o Hash
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Verifica se email já existe
    public boolean emailExiste(String email) {
        return findByEmail(email) != null;
    }

    public boolean create(Usuario u) {
        String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSenha()); // Já deve vir Hasheada

            int rows = ps.executeUpdate();
            if (rows == 1) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) u.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void atualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nome=?, email=?, senha=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSenha());
            ps.setInt(4, u.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar usuário: " + e.getMessage(), e);
        }
    }
}