package com.kh.myhouse.estate.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option; 

public interface EstateDAO {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);
	
	List<Map<String, String>> selectDetailEstate(int estateNo);

	EstateAttach selectEstateAttach(int estateNo);

	int estateoptionlist(Option option);

	int EstateInsert(Estate estate);

	int insertAttachment(EstateAttach a);

	List<String> selectApartListForAll(Map<String, Object> map);

	List<String> selectApartListForAllSelectOption(Map<String, Object> map);
	
	List<Map<String, String>> showRecommendEstate(int cPage, int numPerPage,Map<String, String> param);
	
	List<Map<String, String>> showNotRecommendEstate(int cPage2, int numPerPage, Map<String, String> param);
	

	List<String> selectApartListSelectStructureNotOption(Map<String, Object> map);

	List<String> selectApartListSelectStructureSelectOption(Map<String, Object> map);

	List<String> selectApartListForAllSelectOptionAndMontlyFee(Map<String, Object> map);

	List<String> selectApartListForSelectStructureSelectOptionAndMontlyFee(Map<String, Object> map);

	List<String> selectApartListForSelectStructureNotOptionAndMontlyFee(Map<String, Object> map);

	List<String> selectApartListForAllNotOptionAndMontlyFee(Map<String, Object> map);

	String selectLocalName(String address);

	List<String> selectEstateListForAllNotOption(Map<String, Object> map);

	List<String> selectEstateListForAllSelectOption(Map<String, Object> map);

	List<String> selectEstateListSelectStructureNotOption(Map<String, Object> map);

	List<String> selectEstateListSelectStructureNotOptoin(Map<String, Object> map);

	List<String> selectEstateListForAllNotOptionForMontlyFee(Map<String, Object> map);

	List<String> selectEstateListForAllNotOptionSelectFloorOptionForMontlyFee(Map<String, Object> map);

	List<String> selectEstateListForAllSelectOptionNotFloorOpionForMontlyFee(Map<String, Object> map);

	List<String> selectEstateListForAllSelectOptionSelectFloorOptionMontlyFee(Map<String, Object> map);

	List<String> selectEstateListSelectStructureNotOpionNotFloorOptionMontlyFee(Map<String, Object> map);

	List<String> selectEstateListSelectStructureNotOpionSelectFloorOptionMontlyFee(Map<String, Object> map);

	List<String> selectEstateListSelectStructureSelectOptionNotFloorOptionMontlyFee(Map<String, Object> map);

	List<String> selectEstateListSelectStructureSelectOptionSelectFloorOptionMontlyFee(Map<String, Object> map);

	List<Estate> selectlocalList(String localCode);

}