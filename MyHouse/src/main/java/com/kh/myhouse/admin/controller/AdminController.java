package com.kh.myhouse.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
											@RequestParam String memoContent) {
		Map<String, String> map = new HashMap<>();

		int result = adminService.insertWarn(memberNo, memoContent);
		String msg = result>0?"신고 처리 성공!":"신고 처리 실패!";
		map.put("msg", msg);

		return map;
	}
	
	@RequestMapping("/news.do")
	public String newsSearch(HttpServletRequest req) throws Exception {
		req.setCharacterEncoding("EUC-KR");
		String title = req.getParameter("title");
		if(title == null) {
			title = "부동산";
		}
		
		String page = req.getParameter("page");
		if(page == null) 
			page = "1";
		int cPage = Integer.parseInt(page);
		adminService.newsAllData(title);
		List<Map<String, String>> list = adminService.newsAllData(cPage);
//		int totalPage = adminService.newsTotalPage();
		int totalPage = 10;
		
		req.setAttribute("list", list);
		req.setAttribute("cpage", cPage);
		req.setAttribute("totalPage", totalPage);
		req.setAttribute("title", title);
		
		return "admin/newsTest";
	}
}