package com.kh.myhouse.agent.controller;


import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.agent.model.service.AgentService;
import com.kh.myhouse.agent.model.vo.Agent;

import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.member.model.exception.MemberException;


@Controller
@RequestMapping("/agent")
@SessionAttributes(value= {"memberLoggedIn"})
public class AgentController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AgentService agentService;
	
	@Autowired
	private EstateService estateService;
	
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
			} else {
				if(a.getQuitYN() == 'Y') {
					msg = "회원탈퇴된 아이디 입니다.";
					mav.addObject("msg", msg);
					
					mav.setViewName("/common/msg");
					return mav;
				}
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
	
	@RequestMapping("/updateAgent")
	public String updateAgent(int memberNo, String newPwd) {
		System.out.println("memberNo@controller="+memberNo);
		System.out.println("newPwd@controller="+newPwd);
		return "common/msg";
	}
	
	@RequestMapping("/agentDeleteImg")
	@ResponseBody
	public boolean agentDeleteImg(int memberNo, String renamedFileNamed,
									HttpServletRequest request) {
		
		String saveDirectory = request.getSession().getServletContext()
				  .getRealPath("/resources/upload/agentprofileimg");

		System.out.println("renamedFileNamed밖@controller="+renamedFileNamed);
		if(!renamedFileNamed.equals("")) {
			System.out.println("renamedFileNamed안@controller="+renamedFileNamed);
			File f = new File(saveDirectory+"/"+renamedFileNamed);
			if(f.exists()) f.delete();
		}
		
		int result = agentService.agentDeleteImg(memberNo);
		
		boolean bool = result>0?true:false;
		
		return bool;
	}
	
	@RequestMapping("/agentDelete")
	public String agentDelete(int memberNo, SessionStatus sessionStatus,Model model){
		int result = agentService.agentDelete(memberNo);
		
		String msg = result>0?"회원탈퇴성공!":"회원탈퇴실패!";
		
		if(msg.equals("회원탈퇴성공!")) {
			if(!sessionStatus.isComplete()) sessionStatus.setComplete();
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}

	@RequestMapping("/estateList")
	public void estateList(String searchType, String searchKeyword, Model model) {
		Map<String, Object> map = new HashMap();
		int cPage = 1;
		int numPerPage = 10;
		
		int pageStart = (cPage-1)*numPerPage+1;
		int pageEnd = pageStart+9;
		
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
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);
		
		List<Map<String, Object>> list = agentService.estateList(map);
		
		
		model.addAttribute("list", list);
	}
	

	@RequestMapping("/estateListAdd")
	@ResponseBody
	public List<Map<String, Object>> estateListAdd(String searchType, String searchKeyword, int cPage){
		
		Map<String, Object> map = new HashMap();
		int numPerPage = 10;
		
		int pageStart = (cPage-1)*numPerPage+1;
		int pageEnd = pageStart+9;
		
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
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);
		
		List<Map<String, Object>> list = agentService.estateList(map);
		
		return list;
	}
	
	@RequestMapping("/estateReqView")
	@ResponseBody
	public Map estateReqView(@RequestParam int estateNo) {
		Map<String, Object> map = new HashMap();
		
		Estate e = agentService.selectEstate(estateNo);
		map.put("estate", e);
		
		List<EstateAttach> ea = agentService.selectEstateAttach(estateNo);
		map.put("estateAttach", ea);
		
		Map<String, String> optMap = agentService.selectOption(estateNo);
		map.put("option", optMap);
		
		return map;
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
	
	@RequestMapping("/estateModified")
	public void estateModified(int estateNo, Model model) {
		Estate e = agentService.selectEstate(estateNo);
		Map<String, String> optMap = agentService.selectOption(estateNo);
		
		model.addAttribute("estate", e);
		model.addAttribute("option", optMap);
	}
	
	@RequestMapping("/estateUpdate")
	public void estateUpdate(
			@RequestParam int estateNo,
			@RequestParam String address1,
			@RequestParam String address2,
			@RequestParam String phone1,
			@RequestParam String phone2,
			@RequestParam String phone3,
			@RequestParam char estateType,
			@RequestParam char transactiontype,
			@RequestParam int deposit,
			@RequestParam int[] mon,
			@RequestParam int ManageMenetFee,
			@RequestParam int estateArea,
			@RequestParam String estatecontent,
			@RequestParam String[] etcoption,
			@RequestParam String SubwayStation,
			@RequestParam String[] construction,
            @RequestParam String[] flooropt,
			MultipartFile[] upFile,
			HttpServletRequest request,
			Model model) {
		
		String phone = phone1+phone2+phone3;
		
		//지역코드 얻어오기
		String address= (address1.substring(0,6));	
		String localCode = estateService.selectLocalCodeFromRegion(address); 
		System.out.println("localCode 지역코드의 값 =="+localCode);

		//전세 매매 월세 코드에 맞는 ,전세 ,월세 ,매매값 넣기
		int estateprice= 0;
		if(transactiontype=='J') {
			estateprice = mon[1];
		}
		else if(transactiontype=='M') {
			estateprice = mon[0];
		}
		else {
			estateprice = mon[2];
		}
		System.out.println("estateNo@controller="+estateNo);
		Estate estate =new Estate(estateNo, localCode, 0,
				0, phone, "0",
				address1, estateType, transactiontype, estateprice, 
				ManageMenetFee, estateArea, SubwayStation, 
				estatecontent, null, deposit, address2);
		
		Map<String, Object> map = null;
		
		try {
			map = new HashMap();
			//1. 파일업로드
			String saveDirectory = request.getSession().getServletContext()
										  .getRealPath("/resources/upload/estateenroll");
			
			//원래 저장된 이미지파일 삭제
			
			int result1 = agentService.estatePhotoDelete(estateNo);
			
			for(int i=0; i<upFile.length; i++) {
				if(!upFile[i].isEmpty()) {
					String originalFileName = upFile[i].getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);
					
					String renamedFileName = sdf.format(new Date())+"_"+rndNum+"."+ext;
					
					map.put("estateNo", estateNo);
					map.put("originalFileName", originalFileName);
					map.put("renamedFileName", renamedFileName);
					
					int result2 = agentService.estatePhotoUpdate(map);
					
					try {
						//서버 지정위치에 파일 보관
						upFile[i].transferTo(new File(saveDirectory+"/"+renamedFileName));
					} catch(Exception e) {
						e.printStackTrace();
					}
				}
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		int result = agentService.estateUpdate(estate);
		
	}
	
	@RequestMapping("/warningMemo")
	public void warningMemo() {}
	
}