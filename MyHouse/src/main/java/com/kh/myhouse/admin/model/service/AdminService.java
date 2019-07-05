package com.kh.myhouse.admin.model.service;

import java.util.List;
import java.util.Map;

public interface AdminService {

	List<Map<String, String>> selectMemberList();

	List<Map<String, String>> selectRealtorList();

	List<Map<String, String>> selectReportList();

	String selectMemberEmail(String recipient);

}
