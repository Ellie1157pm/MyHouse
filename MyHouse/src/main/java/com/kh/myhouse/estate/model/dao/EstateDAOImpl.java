package com.kh.myhouse.estate.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

@Repository
public class EstateDAOImpl implements EstateDAO{
	@Autowired
	SqlSessionTemplate sqlSession;


	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return sqlSession.selectOne("estate.selectLocalCodeFromRegion",localName);
	}


	@Override
	public List<Estate> selectApartmentname(Map<String, String> map) {

		return sqlSession.selectList("estate.selectApartmentname", map);
	}

	@Override
	public List<Map<String,String>> selectDetailEstate(int estateNo) {
		return sqlSession.selectList("estate.selectDetailEstate",estateNo);
	}


	@Override
	public EstateAttach selectEstateAttach(int estateNo) {
		return sqlSession.selectOne("estate.selectEstateAttach", estateNo);
	}


	@Override
	public int estateoptionlist(Option option) {

		return sqlSession.insert("estate.estateoptionlist",option);
	}


	@Override
	public int EstateInsert(Estate estate) {

		return sqlSession.insert("estate.EstateInsert",estate);
	}


	@Override
	public int insertAttachment(EstateAttach a) {
		System.out.println("DAO의 ATTACH@@@@"+a);
		return sqlSession.insert("estate.insertattach",a);
	}


	@Override
	public List<String> selectApartListForAll(Map<String, Object> map) {
		//주소 리턴
		return sqlSession.selectList("estate.selectApartListForAllNotOption",map);
	}


	@Override
	public List<String> selectApartListForAllSelectOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForAllNotOption",map);
	}
	
	@Override
	public List<Map<String, String>> showRecommendEstate(int cPage, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("estate.showRecommendEstate",param,rowBounds);
	}
	
	@Override
	public List<Map<String, String>> showNotRecommendEstate(int cPage2, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage2-1)*numPerPage, numPerPage);
		return sqlSession.selectList("estate.showNotRecommendEstate",param,rowBounds);
	}

	@Override
	public List<String> selectApartListSelectStructureNotOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListSelectStructureNotOption",map);
	}


	@Override
	public List<String> selectApartListSelectStructureSelectOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListSelectStructureSelectOption",map);
	}


	@Override
	public List<String> selectApartListForAllSelectOptionAndMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForAllSelectOptionAndMontlyFee",map);
	}


	@Override
	public List<String> selectApartListForSelectStructureSelectOptionAndMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForSelectStructureSelectOptionAndMontlyFee",map);
	}


	@Override
	public List<String> selectApartListForSelectStructureNotOptionAndMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForSelectStructureNotOptionAndMontlyFee",map);
	}


	@Override
	public List<String> selectApartListForAllNotOptionAndMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForAllNotOptionAndMontlyFee",map);
	}


	@Override
	public String selectLocalName(String address) {
		return sqlSession.selectOne("estate.selectLocalName",address);
	}


	@Override
	public List<String> selectEstateListForAllNotOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllNotOption",map);
	}


	@Override
	public List<String> selectEstateListForAllSelectOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllSelectOption",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureNotOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureNotOption",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureNotOptoin(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureNotOptoin",map);
	}


	@Override
	public List<String> selectEstateListForAllNotOptionForMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllNotOptionForMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListForAllNotOptionSelectFloorOptionForMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllNotOptionSelectFloorOptionForMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListForAllSelectOptionNotFloorOpionForMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllSelectOptionNotFloorOpionForMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListForAllSelectOptionSelectFloorOptionMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAllSelectOptionSelectFloorOptionMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureNotOpionNotFloorOptionMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureNotOpionNotFloorOptionMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureNotOpionSelectFloorOptionMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureNotOpionSelectFloorOptionMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureSelectOptionNotFloorOptionMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureSelectOptionNotFloorOptionMontlyFee",map);
	}


	@Override
	public List<String> selectEstateListSelectStructureSelectOptionSelectFloorOptionMontlyFee(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListSelectStructureSelectOptionSelectFloorOptionMontlyFee",map);
	}


	@Override
    public List<Estate> selectlocalList(String localCode) {
        return sqlSession.selectList("estate.selectlocalList",localCode);
    }
	
	@Override
	public Map<String, String> selectCompany(Estate e) {
		return sqlSession.selectOne("estate.selectCompany",e);
	}


	@Override
	public int insertWarningMemberByUser(Map<String, Object> map) {
		return sqlSession.insert("estate.insertWarningMemberByUser",map);
	}


	@Override
	public Map<String, String> selectBusinessMemberInfo(int bMemberNo) {
		return sqlSession.selectOne("estate.selectBusinessMemberInfo",bMemberNo);
	}


	@Override
	public int insertEstimation(Map<String, Object> map) {
		return sqlSession.insert("estate.estimation",map);
	}
}