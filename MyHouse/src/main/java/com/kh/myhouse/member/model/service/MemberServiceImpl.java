package com.kh.myhouse.member.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.dao.MemberDAO;
import com.kh.myhouse.member.model.vo.Member;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;

	@Override
	public int insertMember(Member member) {
		return memberDAO.insertMember(member);
	}

	@Override
	public Member selectOneMember(String memberEmail) {
		return memberDAO.selectOneMember(memberEmail);
	}

	@Override
	public int updateMember(Map map) {
		return memberDAO.updateMember(map);
	}

	@Override
	public int checkEmail(String memberEmail) {
		return memberDAO.checkEmail(memberEmail);
	}

	@Override
	public ArrayList<String> findId(Member member) {
		List<Member> list = memberDAO.findId(member);
		ArrayList<String> findId = new ArrayList<String>();
		for(int i=0; i<list.size(); i++) {
			String email = list.get(i).getMemberEmail();
			findId.add(email);
		}
		return findId;
	}

	@Override
	public int deleteMember(String memberNo) {
		return memberDAO.deleteMember(memberNo);
	}

	@Override
	public Member selectOneMember(int memberNo) {
		return memberDAO.selectOneMember(memberNo);
	}

	@Override
	public int insertInterest(Member member) {
		return memberDAO.insertInterest(member);
	}

	@Override
	public int updateInterest(Interest interest) {
		return memberDAO.updateInterest(interest);
	}

	@Override
	public Interest selectInterest(int memberNo) {
		return memberDAO.selectInterest(memberNo);
	}

	@Override
	public List<Map<String, String>> forSaleList(int memberNo) {
		return memberDAO.forSaleList(memberNo);
	}

	@Override
	public List<Map<String, String>> cartList(int memberNo) {
		return memberDAO.cartList(memberNo);
	}
}