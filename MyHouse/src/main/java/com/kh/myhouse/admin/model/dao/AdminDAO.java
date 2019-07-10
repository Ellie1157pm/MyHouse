package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

public interface AdminDAO {

	List<Map<String, String>> selectMemberList(RowBounds rb);

	List<Map<String, String>> selectRealtorList(RowBounds rb);

	List<Map<String, String>> selectReportList(RowBounds rb);

	String selectMemberEmail(String recipient);

	List<Map<String, String>> selectAllNews(RowBounds rb);

	public int insertNews(Map<String, String> news);

	int insertNotice(Map<String, String> param);

	int newsTotalPage();

	int noticeTotalPage();

	List<Map<String, String>> selectAllNotice(RowBounds rb);

	int memberTotalPage();
	
	int realtorTotalPage();
	
	int reportTotalPage();
}
