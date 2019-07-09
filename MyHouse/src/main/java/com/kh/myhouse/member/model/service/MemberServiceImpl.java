package com.kh.myhouse.member.model.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	public int updateMember(Member member) {
		return memberDAO.updateMember(member);
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
	public int updateInterest(int memberNo) {
		return memberDAO.updateInterest(memberNo);
	}
}
