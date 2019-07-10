package com.kh.myhouse.member.model.dao;

import java.util.List;

import com.kh.myhouse.member.model.vo.Member;

public interface MemberDAO {

	int insertMember(Member member);

	Member selectOneMember(String memberEmail);

	int updateMember(Member member);

	int checkEmail(String memberEmail);

	List<Member> findId(Member member);

	int deleteMember(String memberNo);

	Member selectOneMember(int memberNo);

	int insertInterest(Member member);

	int updateInterest(int memberNo);

}