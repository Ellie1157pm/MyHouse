package com.kh.myhouse.estate.model.service;

import java.util.List;

import com.kh.myhouse.estate.model.vo.Estate;

public interface EstateService {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);

}
