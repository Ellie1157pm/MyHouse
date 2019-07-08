package com.kh.myhouse.estate.model.service;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstatePhoto;

public interface EstateService {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);
	
	Estate selectDetailEstate(Map<String, String> param);

	EstatePhoto selectEstatePhoto(int estateNo);

}
