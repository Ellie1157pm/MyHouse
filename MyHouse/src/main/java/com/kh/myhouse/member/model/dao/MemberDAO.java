package com.kh.myhouse.member.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

public interface MemberDAO {

	int insertMember(Member member);

	Member selectOneMember(String memberEmail);

	int updateMember(Map map);

	int checkEmail(String memberEmail);

	List<Member> findId(Member member);

	int deleteMember(String memberNo);

	Member selectOneMember(int memberNo);

	int insertInterest(Member member);

	int updateInterest(Interest interest);

	Interest selectInterest(int memberNo);

	List<Map<String, String>> forSaleList(int memberNo);

	List<Map<String, String>> cartList(int memberNo);

}