package com.kh.myhouse.agent.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.agent.model.dao.AgentDAO;
import com.kh.myhouse.agent.model.vo.Agent;

@Service
public class AgentServiceImpl implements AgentService {

	@Autowired
	private AgentDAO agentDAO;
	
	@Override
	public int insertAgent(Agent agent) {
		return agentDAO.insertAgent(agent);
	}

	@Override
	public int checkMember(String memberEmail) {
		return agentDAO.checkMember(memberEmail);
	}

	@Override
	public int insertEstateAgent(Map map) {
		return agentDAO.insertEstateAgent(map);
	}

	@Override
	public int checkCompanyCount(String companyRegNo) {
		return agentDAO.checkCompanyCount(companyRegNo);
	}

	@Override
	public List<Map<String, String>> estateList(Map map) {
		return agentDAO.estateList(map);
	}

	@Override
	public List<Map<String, String>> estateListEnd(int memberNo) {
		return agentDAO.estateListEnd(memberNo);
	}

	@Override
	public Agent selectOneAgent(String memberEmail) {
		return agentDAO.selectOneAgent(memberEmail);
	}

}