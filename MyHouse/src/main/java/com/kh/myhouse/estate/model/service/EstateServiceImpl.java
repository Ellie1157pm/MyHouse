package com.kh.myhouse.estate.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.estate.model.dao.EstateDAO;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;



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
	public int estateoptionlist(Option option) {
		
		return estateDAO.estateoptionlist(option);
	}


	@Override
	public int EstateInsert(Estate estate) {
		
		return estateDAO.EstateInsert(estate);
	}


	@Override
	public int insertattach(List<EstateAttach> attachList) {
		int result =0;
		
		if(attachList.size()>0) {
			for(EstateAttach a : attachList) {
				System.out.println("EstateAttach ==="+a);
			
				result =estateDAO.insertAttachment(a);
				
				
		}
		}
			System.out.println("Service의result@@=="+result);
		return result;
	}

}
