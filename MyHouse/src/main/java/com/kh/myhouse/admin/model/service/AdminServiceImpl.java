package com.kh.myhouse.admin.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.admin.model.dao.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired 
	private AdminDAO adminDAO;
}
