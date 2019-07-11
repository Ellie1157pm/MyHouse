package com.kh.myhouse.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.myhouse.admin.model.service.AdminService;
import com.kh.myhouse.common.util.Utils;

@Controller
@RequestMapping("/admin")
public class AdminController {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AdminService adminService;
	
	@RequestMapping("/list")
	public String adminListView(@RequestParam(value="item", required=false, defaultValue="member") String item,
								@RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
								Model model) {
		List<Map<String, String>> list = null;
		
		// RowBounds를 이용한 페이징 처리
		int numPerPage = 6;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
				
		if("member".equals(item)) {
			list = adminService.selectMemberList(rb);
			totalContents = adminService.memberTotalPage();
		}
		else if("realtor".equals(item)) {
			list = adminService.selectRealtorList(rb);
			totalContents = adminService.realtorTotalPage();
		}
		else {
			list = adminService.selectReportList(rb);
			totalContents = adminService.reportTotalPage();
		}
			
		logger.info("list@adminListView={}", list);
		
		model.addAttribute("list", list);
		model.addAttribute("item", item);
		model.addAttribute("pageBar", Utils.getPageBar(totalContents, cPage, numPerPage, "/myhouse/admin/list?item="+item));
		return "admin/adminInfo";
	}
	
	@RequestMapping("/board")
	public String showAdminBoard(HttpServletRequest request,
			@RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
			@RequestParam(value="item", required=false, defaultValue="news") String item) throws Exception {
		List<Map<String, String>> list = null;
		
		// RowBounds를 이용한 페이징 처리
		int numPerPage = 8;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
		
		if("news".equals(item)) {
			list = adminService.selectAllNews(rb);
			totalContents = adminService.newsTotalPage();
		}
		else if("notice".equals(item)) {
			list = adminService.selectAllNotice(rb);
			totalContents = adminService.noticeTotalPage();
		}
		
		logger.info("list@showAdminBoard={}", list);
		
		request.setAttribute("list", list);
		request.setAttribute("item", item);
		request.setAttribute("pageBar", Utils.getPageBar(totalContents, cPage, numPerPage, "/myhouse/admin/board?item="+item));
		
		return "admin/adminBoard";
	}
	
	@RequestMapping("/indexBoard")
	public String showAdminIndexBoard() {
		return "admin/adminIndexBoard";
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
	
	@RequestMapping("/newsRss")
	public String saveTodayNews(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("EUC-KR");
		adminService.newsAllData("부동산");
		
		return "admin/board";
	}
	
	@RequestMapping("/noticeForm")
	public String noticeForm() {
		return "admin/noticeForm";
	}
	
	@RequestMapping(value="/noticeFormEnd", method=RequestMethod.POST)
	@ResponseBody
	public Object noticeFormEnd(@RequestBody Map<String, String> param) {
		Map<String, Object> map = new HashMap<>();
		logger.info("param@noticeFormEnd={}", param);
		
		int result = adminService.insertNotice(param);
		
		if(result>0) {
			map.put("msg", "공지 등록 성공!");
			map.put("result", result);
		}
		else {
			map.put("msg", "공지 등록 실패!");
			map.put("result", result);
		}
		
		return map;
	}
}