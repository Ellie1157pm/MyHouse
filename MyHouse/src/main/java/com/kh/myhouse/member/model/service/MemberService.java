package com.kh.myhouse.member.model.service;

import java.util.ArrayList;

import com.kh.myhouse.member.model.vo.Member;

public interface MemberService {

	int insertMember(Member member);

	Member selectOneMember(String memberEmail);

	int updateMember(Member member);

	int checkEmail(String memberEmail);

	ArrayList<String> findId(Member member);

}
