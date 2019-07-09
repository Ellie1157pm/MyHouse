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
	public List<Estate> selectApartmentname(String localCode) {

		return sqlSession.selectList("estate.selectApartmentname", localCode);
	}

	@Override
	public Estate selectDetailEstate(Map<String, String> param) {
		return sqlSession.selectOne("estate.selectDetailEstate", param);
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
		return sqlSession.selectList("estate.selectApartListForAll",map);
	}


	@Override
	public List<String> selectApartListForAllSelectOption(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectApartListForAllNotOption",map);
	}


	@Override
	public List<Map<String, String>> selectShowEstate(int cPage, int numPerPage, String roadAddressName) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("estate.selectShowEstate",roadAddressName,rowBounds);
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
}
