package com.kh.myhouse.estate.model.service;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

public interface EstateService {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);
	
	Estate selectDetailEstate(Map<String, String> param);

	EstateAttach selectEstateAttach(int estateNo);

	int estateoptionlist(Option option);

	int EstateInsert(Estate estate);

	int insertattach(List<EstateAttach> attachList);

	List<String> selectApartListForAll(Map<String, Object> map);

	List<String> selectApartListForAllSelectOption(Map<String, Object> map);

	List<String> selectApartListSelectStructureNotOption(Map<String, Object> map);

	List<String> selectApartListSelectStructureSelectOption(Map<String, Object> map);

	List<Map<String, String>> selectShowEstate(int cPage, int numPerPage, String roadAddressName);
}
