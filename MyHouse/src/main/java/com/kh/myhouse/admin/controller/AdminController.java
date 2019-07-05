package com.kh.myhouse.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.myhouse.admin.model.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AdminService adminService;
	
	/*@RequestMapping("/info")
	public String adminInfo(Model model) {
		List<Map<String, String>> list = adminService.selectMemberList();
		logger.info("list={}", list);
		model.addAttribute("list", list);
		return "admin/adminInfo";
	}*/
	
	@RequestMapping("/listView")
	public String adminListView(@RequestParam String item,
								Model model) {
		List<Map<String, String>> list = null;
		if("member".equals(item))
			list = adminService.selectMemberList();
		else if("realtor".equals(item))
			list = adminService.selectRealtorList();
		else
			list = adminService.selectReportList();
			
		logger.info("list={}", list);
		model.addAttribute("list", list);
		return "admin/adminInfo";
	}
	
	@RequestMapping(value="/getRecipient", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, String> getMsgRecipient(@RequestParam("recipient") String recipient) {
		String email = adminService.selectMemberEmail(recipient);
		Map<String, String> map = new HashMap<>();
		map.put("email", email);
		return map;
	}
	
	@RequestMapping("/warn")
	public Map<String, String> warnRealtor(@RequestParam String memberNo,
											@RequestParam String warningReason) {
		Map<String, String> map = new HashMap<>();
		
		// 쪽지 대상자가 일반회원인지 중개회원인지 구분
		
		// 중개회원일 경우 경고테이블에 있으면 insert, 없으면 update
		
		
		return map;
	}
}
