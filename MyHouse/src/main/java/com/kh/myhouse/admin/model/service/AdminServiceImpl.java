package com.kh.myhouse.admin.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.admin.model.dao.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired 
	private AdminDAO adminDAO;

	@Override
	public List<Map<String, String>> selectMemberList() {
		return adminDAO.selectMemberList();
	}
}
