package com.kh.myhouse.estate.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

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


	@Override
	public int estateoptionlist(Option option) {
		
		return sqlSession.insert("estate.estateoptionlist",option);
	}


	@Override
	public int EstateInsert(Estate estate) {
		
		return sqlSession.insert("estate.EstateInsert",estate);
	}


	@Override
	public int insertAttachment(EstateAttach a) {
	    System.out.println("DAO의 ATTACH@@@@"+a);
		return sqlSession.insert("estate.insertattach",a);
	}


	

}
