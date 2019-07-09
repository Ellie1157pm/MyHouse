package com.kh.myhouse.agent.model.service;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.agent.model.vo.Agent;

public interface AgentService {

	int insertAgent(Agent agent);

	int checkMember(String memberEmail);

	int insertEstateAgent(Map<String, String> map);

	int checkCompanyCount(String companyRegNo);

	List<Map<String, String>> estateList(Map<String, String> map);

	List<Map<String, String>> estateListEnd(int memberNo);

	Agent selectOneAgent(String memberEmail);

	int updateEstate(Map<String, Object> map);

}
