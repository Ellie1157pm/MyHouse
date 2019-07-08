package com.kh.myhouse.estate.model.service;

import java.util.List;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

public interface EstateService {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(String localCode);

	int estateoptionlist(Option option);

	int EstateInsert(Estate estate);

	int insertattach(List<EstateAttach> attachList);

}
