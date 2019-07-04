package com.kh.myhouse.admin.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.myhouse.admin.model.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AdminService adminService;
	
	@RequestMapping("/info")
	public String adminInfo(Model model) {
		List<Map<String, String>> list = adminService.selectMemberList();
		logger.info("list={}", list);
		model.addAttribute("list", list);
		return "admin/adminInfo";
	}
}
