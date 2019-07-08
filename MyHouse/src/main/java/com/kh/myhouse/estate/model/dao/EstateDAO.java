package com.kh.myhouse.estate.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.EstatePhoto;
import com.kh.myhouse.estate.model.vo.Option; 

public interface EstateDAO {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);
	
	Estate selectDetailEstate(Map<String, String> param);

	EstatePhoto selectEstatePhoto(int estateNo);

	int estateoptionlist(Option option);

	int EstateInsert(Estate estate);

	int insertAttachment(EstateAttach a);

}