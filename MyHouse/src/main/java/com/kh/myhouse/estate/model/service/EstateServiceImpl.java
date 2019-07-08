package com.kh.myhouse.estate.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.estate.model.dao.EstateDAO;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstatePhoto;

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
	
	
	@Override
	public Estate selectDetailEstate(Map<String, String> param) {
		return estateDAO.selectDetailEstate(param);
	}


	@Override
	public EstatePhoto selectEstatePhoto(int estateNo) {
		return estateDAO.selectEstatePhoto(estateNo);
	}
}
