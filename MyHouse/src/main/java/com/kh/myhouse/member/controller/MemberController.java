package com.kh.myhouse.member.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.cart.model.vo.Cart;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.exception.MemberException;
import com.kh.myhouse.member.model.service.MemberService;
import com.kh.myhouse.member.model.vo.Member;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/member")
@SessionAttributes(value= {"memberLoggedIn"})
public class MemberController {

	private Logger logger = LoggerFactory.getLogger(getClass());
			
	@Autowired
	MemberService memberService;
	
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
	public void memberView() {
	}
	
	@RequestMapping("/memberUpdate.do")
	public String memberUpdate(int memberNo, String newPwd, Model model) {
		Map<String, Object> map = new HashMap();
		map.put("memberNo", memberNo);
		
		String msg = "";
	
		if(!newPwd.equals("")) {
			
			String encodedPassword = bcryptPasswordEncoder.encode(newPwd);
			map.put("newPwd", encodedPassword);
			
			int result = memberService.updateMember(map);
			
			msg = result>0?"비밀번호변경 성공! ":"비밀번호 변경 실패! ";
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	/*@RequestMapping("/memberUpdate.do")
	public ModelAndView memberUpdate(Member member) {
		ModelAndView mav = new ModelAndView();
		System.out.println(member);

		// 1.비지니스로직 실행
		int result = memberService.updateMember(member);

		// 2.처리결과에 따라 view단 분기처리
		String loc = "/";
		String msg = "";
		if (result > 0) {
			msg = "회원정보수정성공!";
			mav.addObject("memberLoggedIn", member);
		} else
			msg = "회원정보수정실패!";

		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg");

		return mav;
	}*/

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
	
/*	 지역코드 가져오기 
	@RequestMapping("/getRegionCode")
	public String getRegionCode(@RequestParam String addr1, String addr2) {
		return addr1 + " " + addr2;
	}*/
	
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
			loc = "/member/memberView.do?memberNo=" + memberNo;
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
	
	//추가, 삭제 판단은 매퍼에서 select count(*) from cart where member_no = 37 and estate_no = 143
	//이런식으로 찍어봐서 있으면 삭제, 없으면 추가?
	//찜목록에 추가
	/*@RequestMapping("/insertCart")
	public String insertCart(int estateNo, int memberNo) {
		JSONObject obj = new JSONObject();
		
		Map<String, Object> map = new HashMap<>();
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		
		Cart cart = memberService.cartCheck(map);
		
		int like_check = 0;
		like_check = cart.getCartCheck();
		
		if()
	}*/
	
	//찜목록에서 삭제
	/*@RequestMapping("/deleteCart")
	public String deleteCart(int cartNo) {
		return "";
	}*/
}