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
	public Agent loginCheck(@RequestParam(value="memberEmail") String memberEmail){
		Agent a = agentService.selectOneAgent(memberEmail);
		
		return a;
	}
	
	@RequestMapping("/agentEnroll")
	public void AgentEnroll() {}
	
	@RequestMapping("/insertEstateAgent")
	public String insertEstateAgent(String companyName,
									String companyRegNo,
									String companyPhone,
									Model model) {
		Map<String, String> map = new HashMap();
		map.put("companyName", companyName);
		map.put("companyRegNo", companyRegNo);
		map.put("companyPhone", companyPhone);
		
		String msg = "";
		
		int companyCount = agentService.checkCompanyCount(companyRegNo);
		if(companyCount>2) {
			msg = "더이상 회원가입이 불가능합니다.";
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
	public void advertisedQuestion() {}
	
	@RequestMapping("/agentMypage")
	public void agentMypage(int memberNo) {
		System.out.println("memberNo@controller="+memberNo);
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
	
	@RequestMapping("/estateListEnd")
	public void estateListEnd(int memberNo, Model model) {
		
		List<Map<String, String>> list = agentService.estateListEnd(memberNo);
		
		System.out.println("list@controller="+list);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/warningMemo")
	public void warningMemo() {}
	
}