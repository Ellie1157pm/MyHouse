package com.kh.myhouse.estate.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.estate.model.dao.EstateDAO;
import com.kh.myhouse.estate.model.vo.Estate;

@Service
public class EstateServiceImpl implements EstateService{
	@Autowired
	EstateDAO estateDAO;
	
	
	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return estateDAO.selectLocalCodeFromRegion(localName);
	}


	@Override
	public List<Estate> selectApartmentname(String localCode) {
		
		return estateDAO.selectApartmentname(localCode);
	}

}
