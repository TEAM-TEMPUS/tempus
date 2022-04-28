package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class TradingInfoDao {
	DbConnect db = new DbConnect();
	
	public List<String> findCompleteTrandingsByMemberId(Long memberId) {
		List<String> gradeList = new ArrayList<>();
		DbConnect db = new DbConnect();		
		String sql = "select ti.grade from Trading_Info ti "
				+ "INNER JOIN Service s "
				+ "on ti.member_id = s.member_id and s.status = 'completion' "
				+ "where ti.member_id = ?";
		Connection conn = db.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = conn.prepareStatement(sql);
			ps.setLong(1, memberId);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				String grade = rs.getString("grade");
				
				gradeList.add(grade);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(ps, conn);
		}
		
		return gradeList;
	}
}
