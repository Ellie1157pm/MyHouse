package com.kh.myhouse.member.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

public interface MemberService {

	int insertMember(Member member);
	
	Member selectOneMember(String memberEmail);

	int updateMember(Map<String, Object> map);

	int checkEmail(String memberEmail);

	ArrayList<String> findId(Member member);

	int deleteMember(String memberNo);

	Member selectOneMember(int memberNo);

	Interest selectInterest(int memberNo);
	
	int insertInterest(Member member);

	int updateInterest(Interest interest);

	List<Map<String, String>> forSaleList(int memberNo);

	List<Map<String, String>> cartList(int memberNo);


}