package com.kh.myhouse.agent.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.agent.model.service.AgentService;
import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.member.model.exception.MemberException;


@Controller
@RequestMapping("/agent")
@SessionAttributes(value= {"memberLoggedIn"})
public class AgentController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AgentService agentService;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;

	@RequestMapping("/insertAgent")
	public String insertAgent(Agent agent, Model model) {
		
		//0.비밀번호 암호화 처리(random salt값을 이용해서 해싱처리됨)
		System.out.println("agent.getMemberPwd()="+agent.getMemberPwd());
		String rawPassword = agent.getMemberPwd();
		System.out.println("rawPassword="+rawPassword);
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		agent.setMemberPwd(encodedPassword);
		
		int result = agentService.insertAgent(agent);
		
		String msg = result>0?"회원가입성공!!":"회원가입실패!!";
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/checkMemberEmail")
	@ResponseBody
	public String checkMemberEmail(@RequestParam(value="memberEmail") String memberEmail) {
		
		int cnt = agentService.checkMember(memberEmail);
		
		String str = cnt>0?"true":"false";
		
		return str;
	}
	
	@RequestMapping("/loginCheck")
	@ResponseBody
	public Agent loginCheck(@RequestParam(value="memberEmail") String memberEmail,
							Model model){
		Agent a = agentService.selectOneAgent(memberEmail);
		
		return a;
	}
	
	@RequestMapping("/agentEnroll")
	public void AgentEnroll() {}
	
	@RequestMapping("/insertEstateAgent")
	public String insertEstateAgent(String companyName,
									String companyRegNo,
									String companyPhone,
									int memberNo,
									Model model) {
		Map<String, Object> map = new HashMap();
		map.put("companyName", companyName);
		map.put("companyRegNo", companyRegNo);
		map.put("companyPhone", companyPhone);
		map.put("memberNo", memberNo);
		
		String msg = "";
		
		int checkCompany = agentService.checkCompany(memberNo);
		if(checkCompany>0) {
			msg = "이미 신청 하셨습니다.";
			model.addAttribute("msg", msg);
			return "common/msg";
		}
		
		int companyCount = agentService.checkCompanyCount(companyRegNo);
		if(companyCount>2) {
			msg = "더이상 중개사무소 가입이 불가능합니다.";
			model.addAttribute("msg", msg);
			return "common/msg";
		}
		
		int result = agentService.insertEstateAgent(map);
		
		msg = result>0?"가입에 성공하셨습니다!":"가입에 실패하셨습니다!";
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/agentLogin")
	public ModelAndView memberLogin(@RequestParam String memberEmail,
							  @RequestParam String memberPwd,
							  ModelAndView mav) {
		if(logger.isDebugEnabled())
			logger.debug("로그인 요청!");
		
		String encodedPassword = bcryptPasswordEncoder.encode(memberPwd);
		System.out.println("암호화후: "+encodedPassword);
		
		try {

			Agent a = agentService.selectOneAgent(memberEmail);
			
			String msg = "";
			String loc = "/";
			
			if(a == null) {
				msg = "존재하지 않는 회원입니다.";
			}
			else {
				boolean bool = bcryptPasswordEncoder.matches(memberPwd, a.getMemberPwd());
				if(bool) {
					msg = "로그인 성공! ["+a.getMemberName()+"]님, 반갑습니다." ;
					mav.addObject("memberLoggedIn", a);
				}
				else {
					msg = "비밀번호가 틀렸습니다.";
				}
			}

			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("/common/msg");
			
		} catch(Exception e) {
			
			logger.error("로그인 요청 에러: ", e);
			throw new MemberException("로그인 요청에러: "+e.getMessage());
		}
		
		return mav;
	}
	
	@RequestMapping("/advertisedQuestion")
	public void advertisedQuestion(int memberNo, Model model) {
		List<Map<String, String>> list = agentService.estateListEnd(memberNo);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("advertisedReq")
	@ResponseBody
	public String advertisedReq(@RequestParam(value="advertiseDate") int advertiseDate,
								@RequestParam(value="estateNo") int estateNo) {
		Map<String, Integer> map = new HashMap();
		int price = 0;
		if(advertiseDate == 30) price = 50000;
		else if (advertiseDate == 60) price = 100000;
		else if (advertiseDate == 90) price = 140000;
		
		map.put("advertiseDate", advertiseDate);
		map.put("estateNo", estateNo);
		map.put("price", price);
		
		int result = agentService.updateAdvertised(map);
		
		return "";
	}
	
	@RequestMapping("/agentMypage")
	public void agentMypage() {
	}
	
	@RequestMapping("/estateList")
	public void estateList(String searchType, String searchKeyword, Model model) {
		Map<String, String> map = new HashMap();
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		try {			
			if(searchType.equals("상관없음")) searchType = null;
			else if(searchType.equals("아파트")) searchType = "A";
			else if(searchType.equals("빌라")) searchType = "B";
			else if(searchType.equals("원룸")) searchType = "O";
			else if(searchType.equals("오피스텔")) searchType = "P";
			if(searchKeyword.equals("")) searchKeyword = null;
		} catch(Exception e) {}
		
		map.put("searchType", searchType);
		map.put("searchKeyword", searchKeyword);
		
		List<Map<String, String>> list = agentService.estateList(map);
		
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/updateEstate")
	public String updateEstate(int estateNo, int memberNo, String phone
								,Model model) {
		Map<String, Object> map = new HashMap();
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		map.put("phone", phone);
		
		int result = agentService.updateEstate(map);
		
		String msg = result>0?"등록성공!":"등록실패!";
		
		model.addAttribute("msg", msg);
		model.addAttribute("loc", "/agent/estateList");
		
		return "common/msg";
	}
	
	@RequestMapping("/estateListEnd")
	public void estateListEnd(int memberNo, Model model) {
		
		List<Map<String, String>> list = agentService.estateListEnd(memberNo);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/warningMemo")
	public void warningMemo() {}
	
}
