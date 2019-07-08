package com.kh.myhouse.estate.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.estate.model.vo.Estate;

@Repository
public class EstateDAOImpl implements EstateDAO{
	@Autowired
	SqlSessionTemplate sqlSession;
	
	
	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return sqlSession.selectOne("estate.selectLocalCodeFromRegion",localName);
	}


	@Override
	public List<Estate> selectApartmentname(String localCode) {
		
		return sqlSession.selectList("estate.selectApartmentname", localCode);
	}

}
