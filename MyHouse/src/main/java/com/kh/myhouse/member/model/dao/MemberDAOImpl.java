package com.kh.myhouse.member.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int insertMember(Member member) {
		return sqlSession.insert("member.insertMember", member);
	}

	@Override
	public Member selectOneMember(String memberEmail) {
		return sqlSession.selectOne("member.selectOneMember", memberEmail);
	}

	@Override
	public int updateMember(Map map) {
		return sqlSession.update("member.updateMember", map);
	}

	@Override
	public int checkEmail(String memberEmail) {
		return sqlSession.selectOne("member.checkEmail", memberEmail);
	}

	@Override
	public List<Member> findId(Member member) {
		return sqlSession.selectList("member.findId", member);
	}
	
	@Override
	public int deleteMember(String memberNo) {
		return sqlSession.update("member.deleteMember", memberNo);
	}

	@Override
	public Member selectOneMember(int memberNo) {
		return sqlSession.selectOne("member.selectOneMember_", memberNo);
	}
	
	@Override
	public int insertInterest(Member member) {
		return sqlSession.insert("member.insertInterest", member);
	}
	
	@Override
	public Interest selectInterest(int memberNo) {
		return sqlSession.selectOne("member.selectInterest", memberNo);
	}

	@Override
	public int updateInterest(Interest interest) {
		return sqlSession.update("member.updateInterest", interest);
	}

	@Override
	public List<Map<String, String>> forSaleList(int memberNo) {
		return sqlSession.selectList("member.forSaleList", memberNo);
	}

	@Override
	public List<Map<String, String>> cartList(int memberNo) {
		return sqlSession.selectList("member.cartList", memberNo);
	}
	
	

}