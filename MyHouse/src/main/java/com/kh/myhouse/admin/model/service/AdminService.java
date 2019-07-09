package com.kh.myhouse.admin.model.service;

import java.util.List;
import java.util.Map;

public interface AdminService {

	List<Map<String, String>> selectMemberList();

	List<Map<String, String>> selectRealtorList();

	List<Map<String, String>> selectReportList();

	String selectMemberEmail(String recipient);

	int insertWarn(String memberNo, String memoContent);

	void newsAllData(String title);

	List<Map<String, String>> selectAllNews(int cPage);

}
