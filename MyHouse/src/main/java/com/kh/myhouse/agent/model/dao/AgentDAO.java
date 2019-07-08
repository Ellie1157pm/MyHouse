package com.kh.myhouse.agent.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.agent.model.vo.Agent;

public interface AgentDAO {

	int insertAgent(Agent agent);

	int checkMember(String memberEmail);

	int insertEstateAgent(Map map);

	int checkCompanyCount(String companyRegNo);

	List<Map<String, String>> estateList(Map map);

	List<Map<String, String>> estateListEnd(int memberNo);

}
