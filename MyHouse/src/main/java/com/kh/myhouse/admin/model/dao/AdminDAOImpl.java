package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAOImpl implements AdminDAO {
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, String>> selectMemberList() {
		return sqlSession.selectList("admin.selectMemberList");
	}
}
