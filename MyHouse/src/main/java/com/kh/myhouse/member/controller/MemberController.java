package com.kh.myhouse.member.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;

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
	BCryptPasswordEncoder bcryptPasswordEncoder;		
	
	@RequestMapping("/insertMember.do")
	public String insertMember(Member member, Model model) {
		if(logger.isDebugEnabled())
			logger.debug("회원 등록 처리 요청!");

		String rawPassword = member.getMemberPwd();
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		
		member.setMemberPwd(encodedPassword);

		int result = memberService.insertMember(member);
		
		String loc = "/";
		String msg = result>0?"회원가입성공!":"회원가입실패!";
		
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
		System.out.println("암호화후: "+encodedPassword);
		
		try {

			Member m = memberService.selectOneMember(memberEmail);
			
			String msg = "";
			String loc = "/";
			
			if(m == null) {
				msg = "존재하지 않는 회원입니다.";
			}
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
	

	@RequestMapping("/memberView.do")
	public ModelAndView memberView(@RequestParam String memberEmail) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("member", memberService.selectOneMember(memberEmail));
		mav.setViewName("member/memberView");
		return mav;
	}
	
	/*
	@RequestMapping("/memberUpdate.do")
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
	}
*/
	@RequestMapping("/checkMemberEmail.do")
	@ResponseBody
	public String checkEmail(@RequestParam(value="memberEmail") String memberEmail) {
		
		return memberService.checkEmail(memberEmail) > 0?"true":"false";	
	}
	
	/* 아이디 찾기 */
	@RequestMapping(value = "/findId" , method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public String findId(@ModelAttribute Member member, Model model , HttpServletResponse response) throws Exception {

		System.out.println(member.toString());


		ArrayList <String> emailList = memberService.findId(member);
		System.out.println(emailList.toString());
		System.out.println(emailList.get(0));
		String findEmail = "{\"member_email\":\""+emailList+"\"}";

		System.out.println(findEmail);

		return findEmail;
	}
	
	/* 관심매물 설정 */
//	@RequestMapping("/interestList.do")
}














