package com.kh.myhouse.agent.model.service;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.agent.model.vo.Agent;

public interface AgentService {

	int insertAgent(Agent agent);

	int checkMember(String memberEmail);

	int insertEstateAgent(Map<String, Object> map);

	int checkCompanyCount(String companyRegNo);

	List<Map<String, String>> estateList(Map<String, String> map);

	List<Map<String, String>> estateListEnd(int memberNo);

	Agent selectOneAgent(String memberEmail);

	int updateEstate(Map<String, Object> map);

	int updateAdvertised(Map<String, Integer> map);

	int checkCompany(int memberNo);

	int updateAgent(Map<String, Object> map);

	int updateAgentProfileImg(Map<String, Object> map);

	String selectProfileImg(int memberNo);

	int agentDeleteImg(int memberNo);

}