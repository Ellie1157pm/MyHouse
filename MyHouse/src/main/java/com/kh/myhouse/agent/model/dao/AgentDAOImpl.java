package com.kh.myhouse.agent.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.agent.model.vo.Agent;

@Repository
public class AgentDAOImpl implements AgentDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public int insertAgent(Agent agent) {
		return sqlSession.insert("agent.insertAgent", agent);
	}

	@Override
	public int checkMember(String memberEmail) {
		return sqlSession.selectOne("agent.checkMemberEmail", memberEmail);
	}

	@Override
	public int insertEstateAgent(Map map) {
		return sqlSession.insert("agent.insertEstateAgent", map);
	}

	@Override
	public int checkCompanyCount(String companyRegNo) {
		return sqlSession.selectOne("agent.checkCompanyCount", companyRegNo);
	}

	@Override
	public List<Map<String, String>> estateList(Map map) {
		return sqlSession.selectList("agent.estateList", map);
	}

	@Override
	public List<Map<String, String>> estateListEnd(int memberNo) {
		return sqlSession.selectList("agent.estateListEnd", memberNo);
	}

	@Override
	public Agent selectOneAgent(String memberEmail) {
		return sqlSession.selectOne("agent.selectOneAgent", memberEmail);
	}

	@Override
	public int updateEstate(Map<String, Object> map) {
		return sqlSession.update("updateEstate", map);
	}

}
