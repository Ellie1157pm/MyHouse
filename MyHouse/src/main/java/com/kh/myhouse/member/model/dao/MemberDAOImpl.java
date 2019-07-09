package com.kh.myhouse.member.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
	public int updateMember(Member member) {
		return sqlSession.update("member.updateMember", member);
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
	public int updateInterest(int memberNo) {
		return sqlSession.update("member.updateInterest", memberNo);
	}

}
