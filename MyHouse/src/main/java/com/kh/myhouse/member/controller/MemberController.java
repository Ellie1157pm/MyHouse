package com.kh.myhouse.member.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.agent.model.service.AgentService;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.exception.MemberException;
import com.kh.myhouse.member.model.service.MemberService;
import com.kh.myhouse.member.model.vo.Member;

@Controller
@RequestMapping("/member")
@SessionAttributes(value= {"memberLoggedIn"})
public class MemberController {

	private Logger logger = LoggerFactory.getLogger(getClass());
			
	@Autowired
	MemberService memberService;
	
	@Autowired
	AgentService agentService;
	
	@Autowired
	EstateService estateService;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;		
	
	@RequestMapping("/insertMember.do")
	public String insertMember(Member member, Model model) {
		if(logger.isDebugEnabled())
			logger.debug("회원 등록 처리 요청!");

		String rawPassword = member.getMemberPwd();
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		
		member.setMemberPwd(encodedPassword);

		int result = memberService.insertMember(member);
		//회원 가입시, interest테이블에 회원번호를 insert해서 만들어둔다.
		int result_ = memberService.insertInterest(member);
		
		String loc = "/";
		String msg = result>0 && result_>0?"회원가입성공!":"회원가입실패!";
		
		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberEmail,
							  @RequestParam String memberPwd,
							  ModelAndView mav) {
		if(logger.isDebugEnabled())
			logger.debug("로그인 요청!");
		
		String encodedPassword = bcryptPasswordEncoder.encode(memberPwd);
		
		try {

			Member m = memberService.selectOneMember(memberEmail);
			
			String msg = "";
			String loc = "/";
			
			if(m == null || m.getQuitYN() == 'Y')
				msg = "존재하지 않는 회원입니다.";

			else {
				boolean bool = bcryptPasswordEncoder.matches(memberPwd, m.getMemberPwd());
				if(bool) {
					msg = "로그인 성공! ["+m.getMemberName()+"]님, 반갑습니다." ;
					mav.addObject("memberLoggedIn", m);
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
	
	@RequestMapping("/memberLogout.do")
	public String memberLogout(SessionStatus sessionStatus) {
		if(logger.isDebugEnabled())
			logger.debug("로그아웃 요청!");

		if(!sessionStatus.isComplete())
			sessionStatus.setComplete();
		
		return "redirect:/";
	}
	

	/*@RequestMapping("/memberView.do")
	public ModelAndView memberView(@RequestParam int memberNo) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("member", memberService.selectOneMember(memberNo));
		System.out.println("member@cont: " + memberService.selectOneMember(memberNo));
		mav.setViewName("member/memberView");
		return mav;
	}*/
	
	@RequestMapping("/memberView.do")
	public void memberView(int memberNo) {
	}
	
	@RequestMapping("/memberUpdate.do")
	public String memberUpdate(@RequestParam int memberNo, String memberName, String newPwd, char receiveMemoYN, Model model) {
		Map<String, Object> map = new HashMap();
		map.put("memberNo", memberNo);
		map.put("memberName", memberName);
		map.put("receiveMemoYN", receiveMemoYN);
		
		Member member = memberService.selectOneMember(memberNo);
		
		String msg = "";
		int result = 0;
	
		if(!newPwd.equals("")) {	
			String encodedPassword = bcryptPasswordEncoder.encode(newPwd);
			map.put("newPwd", encodedPassword);
			result = memberService.updateMember(map);
			msg = result>0?"회원정보 수정 성공! ":"회원정보 수정 실패! ";
		}
		else {
			map.put("newPwd", member.getMemberPwd());
			result = memberService.updateMember(map);
			msg = result>0?"회원정보 수정 성공!":"회원정보 수정 실패!";
		}
		
		if(result>0) member = memberService.selectOneMember(memberNo);
		
		model.addAttribute("msg", msg);
		model.addAttribute("memberLoggedIn", member);
		
		return "common/msg";
	}

	@RequestMapping("/checkMemberEmail.do")
	@ResponseBody
	public String checkEmail(@RequestParam(value="memberEmail") String memberEmail) {
		
		return memberService.checkEmail(memberEmail) > 0?"true":"false";	
	}
	
	/* 아이디 찾기 */
	@RequestMapping(value = "/findId.do" , method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public String findId(@ModelAttribute Member member) throws Exception {
		
		ArrayList <String> emailList = memberService.findId(member);

		String findEmail = "{\"memberEmail\":\""+emailList+"\"}";

		return findEmail;
	}
	
	/* 비밀번호 찾기 */
	@RequestMapping(value = "/findPwd.do", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public int findPwd(@ModelAttribute Member member) throws Exception {
		return memberService.findPwd(member);
	}
	
	/* 비밀번호 리셋 */
	//비밀번호 변경 후 변경한 비밀번호로 로그인 안됨. 해결해야 함
	@RequestMapping("/resetPwd.do")
	public String resetPwd(@RequestParam int memberNo, String resetPwd, Model model) throws Exception {
		Map<String, Object> map = new HashMap();
		
		map.put("memberNo", memberNo);
		String msg = "";
		System.out.println("resetPwd@cont=" + resetPwd);
		if(!resetPwd.equals("")) {
			String encodedPassword = bcryptPasswordEncoder.encode(resetPwd);
			map.put("resetPwd", encodedPassword);
			int result = memberService.resetPwd(map);
			System.out.println("resetPwd@cont=" + encodedPassword);
			msg = result>0?"비밀번호 변경 성공!":"비밀번호 변경 실패!";
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	/* 비밀번호 변경시 기존 비밀번호 매칭 확인 */
	@RequestMapping("/pwdIntegrity.do")
	@ResponseBody
	public String pwdIntegrity(@RequestParam(value="oldPwd") String oldPwd, 
							   @RequestParam(value="memberNo") int memberNo) {
		
		Member m = memberService.selectOneMember(memberNo);

		String str = bcryptPasswordEncoder.matches(oldPwd, m.getMemberPwd())?"true":"false";

		return str;
	}
	
	/* 관심매물 리스트 */
	@RequestMapping("/interestList")
	public ModelAndView interestList(@RequestParam int memberNo) {
		logger.debug("관심매물 요청!");
		ModelAndView mav = new ModelAndView();
		System.out.println("interest@cont=" + memberService.selectInterest(memberNo));
		logger.debug("interest", memberService.selectInterest(memberNo));
		mav.addObject("interest", memberService.selectInterest(memberNo));
		mav.setViewName("member/interestList");
	
		return mav;
	}
	
	/* 관심매물 설정(수정) */
	@RequestMapping("/updateInterestList")
	public void updateInterestList(int memberNo) {
		ModelAndView mav = new ModelAndView();
		Interest interest = memberService.selectInterest(memberNo);
		
		int result = memberService.updateInterest(interest);

		String loc = "/member/interestList?memberNo="+memberNo;
		String msg = "";
		if (result > 0) {
			msg = "관심매물수정성공!";
			mav.addObject("interest", interest);
		} else
			msg = "관심매물수정실패!";

		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg");
	}
	
	@RequestMapping("/deleteMember.do")
	public ModelAndView deleteMember(@RequestParam String memberNo, SessionStatus sessionStatus) {
		ModelAndView mav = new ModelAndView();
		int result = memberService.deleteMember(memberNo);
		System.out.println("memberNo@deleteMemberCont=" + memberNo);
		System.out.println("result@deleteMemberCont=" + result);
		String msg = "";
		String loc = "";
		if (result > 0) {
			msg = "회원탈퇴 성공!";
			loc = "/";
			sessionStatus.setComplete();
		}
		else {
			msg = "회원탈퇴 실패!";
			loc = "/";
		}
		
		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg");

		return mav;
	}
	
	@RequestMapping("/forSaleList")
	public void forSaleList(@RequestParam int memberNo, Model model) {
		System.out.println("memberNo@forSaleList=" + memberNo);
		List<Map<String, String>> list = memberService.forSaleList(memberNo);
		System.out.println("forSaleList@cont=" + list);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/cartList")
	public void cartList(@RequestParam int memberNo, Model model) {
		List<Map<String, String>> list = memberService.cartList(memberNo);
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/selectOneEstate")
	@ResponseBody
	public Map selectOneEstate(@RequestParam int estateNo) {
		Map<String, Object> map = new HashMap();
		
		Estate estate = memberService.selectOneEstate(estateNo);
		System.out.println("estate@cont=" + estate);
		map.put("estate", estate);
		
		List<EstateAttach> estateAttach = memberService.selectEstatePhoto(estateNo);
		map.put("estateAttach", estateAttach);
		
		Map<String, String> estateOption = memberService.selectEstateOption(estateNo);
		map.put("option", estateOption);
		
		return map;
		
	}
	
	//찜목록에서 삭제
	@RequestMapping("/deleteCartList")
	public String deleteCart(@RequestParam int memberNo, 
							 @RequestParam int estateNo,
							 Model model) {
		
		Map<String, Object> map = new HashMap();
		map.put("memberNo", memberNo);
		map.put("estateNo", estateNo);
		
		String msg = "";
		msg = memberService.deleteCartList(map)>0?"찜한 목록에서 삭제했습니다.":"삭제 실패!";
		model.addAttribute("msg", msg);
		return "common/msg";
	}
	
	@RequestMapping("/updateEstate.do")
	public void estateUpdate(int memberNo, int estateNo, Model model) {
		Estate estate = memberService.selectOneEstate(estateNo);
		List<EstateAttach> estateAttach = memberService.selectEstatePhoto(estateNo);
		Map<String, String> option = memberService.selectEstateOption(estateNo);
		System.out.println("selectedEstate@cont=" + estate);
		System.out.println("selectedEstateAttach@cont=" + estateAttach);
		System.out.println("selectedOption@cont=" + option);
		
		model.addAttribute("estateAttach", estateAttach);
		model.addAttribute("estate", estate);
		model.addAttribute("option", option);	
		}

	@PostMapping("/updateEstateEnd.do")
	public String estateUpdate(@RequestParam int memberNo,
			@RequestParam int estateNo,
			@RequestParam String address1,
			@RequestParam int address2,
			@RequestParam int address3,
			@RequestParam String phone1,
			@RequestParam String phone2,
			@RequestParam String phone3,
			@RequestParam char estateType,
			@RequestParam char transactiontype,
			@RequestParam int deposit,
			@RequestParam int[] mon,
			@RequestParam int manageMentFee,
			@RequestParam int estateArea,
			@RequestParam String estatecontent,
			@RequestParam String[] etcoption,
			@RequestParam String SubwayStation,
			@RequestParam String[] construction,
            @RequestParam String[] flooropt,
			MultipartFile[] upFile,
			HttpServletRequest request,
			Model model) {
		
		System.out.println("address1 주소명=="+address1);
		System.out.println("address2 주소상세=="+address2);
		String phone = phone1+phone2+phone3;
		System.out.println("phone 폰번호=="+phone);
		System.out.println("estateType 빌라,아파트,오피스텔=="+estateType);
		System.out.println("transactiontype 전세,매매,월세 라디오버튼값=="+transactiontype);
		System.out.println("deposit 보증금=="+deposit);
		System.out.println("mon 전세,매매,월세 가격입력값=="+Arrays.toString(mon));//mon[0]:월세 /mon[1]:전세 /mon[2]:매물가 
		System.out.println("ManageMenetFee 관리비=="+manageMentFee);
		System.out.println("estateArea 평수=="+estateArea);
		System.out.println("estatecontent 주변환경=="+estatecontent);
		System.out.println("etcoption 엘레베이터,애완동물 등=="+Arrays.toString(etcoption));
		System.out.println("SubwayStation 전철역=="+SubwayStation);
		System.out.println("upFile 파일명=="+Arrays.toString(upFile));
		
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
		List<EstateAttach> list = agentService.selectEstateAttach(estateNo);
		Estate estate = new Estate(estateNo, localCode, memberNo,
				0, phone, "0",
				address1, estateType, transactiontype, estateprice, 
				manageMentFee, estateArea, SubwayStation, 
				estatecontent, new Date(), deposit, address2+"동"+address3+"층", list);
		
		Map<String, Object> map = null;
		int result1 = 0;
		int result2 = 0;
		try {
			map = new HashMap();
			//1. 파일업로드
			String saveDirectory = request.getSession().getServletContext()
										  .getRealPath("/resources/upload/estateenroll");
			
//			List<EstateAttach> ea = agentService.selectEstateAttach(estateNo);
			
			//원래 저장된 이미지파일 삭제
			for(int i=0; i<list.size(); i++) {
				File f = new File(saveDirectory+"/"+list.get(i).getRenamedFileName());
				if(f.exists()) f.delete();			
			}
			
			result1 = agentService.estatePhotoDelete(estateNo);
			
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
					
					result2 = agentService.estatePhotoUpdate(map);
					
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
		
		int result3 = agentService.estateUpdate(estate);
		
		String msg = (result1>0&&result2>0&&result3>0)?"매물 수정 성공!":"매물 수정 실패!";
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	//매물 삭제를 하면 해당 매물번호의 ESTATE, ESTATE_PHOTO, TBL_OPTION의 모든 정보를 삭제한다.
	@RequestMapping("/deleteEstate.do")
	public String deleteEstate(@RequestParam int estateNo, Model model, HttpServletRequest request) {
		System.out.println("estateNo@deleteEstateCont=" + estateNo);
		//1. 매물 테이블의 컬럼 삭제
		int result1 = memberService.deleteEstate(estateNo);
		
		//2. 매물사진 테이블의 컬럼 삭제
		String saveDirectory = request.getSession().getServletContext()
				  .getRealPath("/resources/upload/estateenroll");
		
		//서버에 저장된 이미지파일 삭제
		List<EstateAttach> list = agentService.selectEstateAttach(estateNo);
		
		for(int i=0; i<list.size(); i++) {
			File f = new File(saveDirectory+"/"+list.get(i).getRenamedFileName());
			if(f.exists()) f.delete();			
		}
		int result2 = agentService.estatePhotoDelete(estateNo);
		
		//3. 매물 옵션 테이블의 컬럼 삭제
		int result3 = memberService.deleteEstateOption(estateNo);
		
		String msg = (result1>0&&result2>0&&result3>0)?"매물 삭제 성공!":"매물 삭제 실패!";
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
}