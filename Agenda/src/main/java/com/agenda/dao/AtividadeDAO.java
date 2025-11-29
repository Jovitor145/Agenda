package com.agenda.dao;

import com.agenda.config.DBConnection;
import com.agenda.model.Atividade;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AtividadeDAO {

    // --- CREATE ---
    public void salvar(Atividade atividade) {
        String sql = "INSERT INTO atividades (titulo, descricao, data, status, usuario_id, categoria_id, prioridade_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            preencherStatement(stmt, atividade);
            stmt.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao salvar: " + e.getMessage(), e);
        }
    }

    // --- UPDATE (Edição Completa) ---
    public void atualizar(Atividade atividade) {
        String sql = "UPDATE atividades SET titulo=?, descricao=?, data=?, status=?, usuario_id=?, categoria_id=?, prioridade_id=? WHERE id=? AND usuario_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            preencherStatement(stmt, atividade);
            stmt.setInt(8, atividade.getId());
            stmt.setInt(9, atividade.getUsuarioId());
            
            stmt.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar: " + e.getMessage(), e);
        }
    }

    // --- UPDATE (Apenas Status) ---
    public void atualizarStatus(int id, int usuarioId, String novoStatus) {
        String sql = "UPDATE atividades SET status=? WHERE id=? AND usuario_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus);
            stmt.setInt(2, id);
            stmt.setInt(3, usuarioId);
            stmt.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao mudar status: " + e.getMessage(), e);
        }
    }

    // --- DELETE ---
    public void excluir(int id, int usuarioId) {
        String sql = "DELETE FROM atividades WHERE id=? AND usuario_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, usuarioId);
            stmt.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir: " + e.getMessage(), e);
        }
    }

    // --- READ (Buscar Um) ---
    public Atividade buscarPorId(int id, int usuarioId) {
        String sql = "SELECT * FROM atividades WHERE id=? AND usuario_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.setInt(2, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar: " + e.getMessage(), e);
        }
        return null;
    }

    // --- READ (Listar Todos) ---
    public List<Atividade> listarPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM atividades WHERE usuario_id = ? ORDER BY status DESC, data ASC"; // Pendentes primeiro
        List<Atividade> lista = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar: " + e.getMessage(), e);
        }
        return lista;
    }

    // --- Métodos Auxiliares para evitar repetição de código ---
    
    private void preencherStatement(PreparedStatement stmt, Atividade a) throws SQLException {
        stmt.setString(1, a.getTitulo());
        stmt.setString(2, a.getDescricao());
        
        if (a.getDataVencimento() != null) {
            stmt.setDate(3, java.sql.Date.valueOf(a.getDataVencimento()));
        } else {
            stmt.setDate(3, null);
        }
        
        // Se status vier nulo no objeto, assume PENDENTE
        stmt.setString(4, a.getStatus() != null ? a.getStatus() : "PENDENTE");
        stmt.setInt(5, a.getUsuarioId());
        
        if (a.getCategoriaId() > 0) stmt.setInt(6, a.getCategoriaId()); else stmt.setNull(6, java.sql.Types.INTEGER);
        if (a.getPrioridadeId() > 0) stmt.setInt(7, a.getPrioridadeId()); else stmt.setNull(7, java.sql.Types.INTEGER);
    }

    private Atividade mapearResultSet(ResultSet rs) throws SQLException {
        Atividade a = new Atividade();
        a.setId(rs.getInt("id"));
        a.setTitulo(rs.getString("titulo"));
        a.setDescricao(rs.getString("descricao"));
        
        java.sql.Date dataSql = rs.getDate("data");
        if (dataSql != null) a.setDataVencimento(dataSql.toLocalDate());
        
        a.setStatus(rs.getString("status"));
        a.setUsuarioId(rs.getInt("usuario_id"));
        a.setCategoriaId(rs.getInt("categoria_id"));
        a.setPrioridadeId(rs.getInt("prioridade_id"));
        return a;
    }
}