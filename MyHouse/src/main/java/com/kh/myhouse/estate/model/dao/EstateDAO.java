package com.kh.myhouse.estate.model.dao;

import java.util.List;

import com.kh.myhouse.estate.model.vo.Estate; 

public interface EstateDAO {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);

}
