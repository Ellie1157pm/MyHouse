package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

public interface AdminDAO {

	List<Map<String, String>> selectMemberList();

	List<Map<String, String>> selectRealtorList();

	List<Map<String, String>> selectReportList();

	String selectMemberEmail(String recipient);

	void newsAllData(String title);

	List<Map<String, String>> selectAllNews(RowBounds rb);

}
