package com.kh.myhouse.admin.model.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

public interface AdminService {

	List<Map<String, String>> selectMemberList(RowBounds rb);

	List<Map<String, String>> selectRealtorList(RowBounds rb);

	List<Map<String, String>> selectReportList(RowBounds rb);

	String selectMemberEmail(String recipient);

	int insertWarn(String memberNo, String memoContent);

	void newsAllData(String title);

	List<Map<String, String>> selectAllNews(RowBounds rb);

	int insertNotice(Map<String, String> param);

	List<Map<String, String>> selectAllNotice(RowBounds rb);

	int newsTotalPage();
	
	int noticeTotalPage();
	
	int memberTotalPage();
	
	int realtorTotalPage();
	
	int reportTotalPage();

	List<Map<String, String>> selectRecentNews();
	
	List<Map<String, String>> selectRecentNotice();

	int deleteNotice(int noticeNo);

	Map<String, Object> selectOneNotice(int noticeNo);
}
