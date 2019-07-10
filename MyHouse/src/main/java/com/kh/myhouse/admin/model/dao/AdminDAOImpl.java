package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAOImpl implements AdminDAO {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, String>> selectMemberList() {
		return sqlSession.selectList("admin.selectMemberList");
	}

	@Override
	public List<Map<String, String>> selectRealtorList() {
		return sqlSession.selectList("admin.selectRealtorList");
	}

	@Override
	public List<Map<String, String>> selectReportList() {
		return sqlSession.selectList("admin.selectReportList");
	}

	@Override
	public String selectMemberEmail(String recipient) {
		return sqlSession.selectOne("admin.selectMemberEmail", recipient);
	}
	
	@Override
	public int insertNews(Map<String, String> news) {
		int result = 0;
		try {
			result = sqlSession.insert("admin.newsInsert", news);
			
			if(result>0)
				logger.info("뉴스 저장 성공");
			else
				logger.info("뉴스 저장 실패");
				
		} catch (Exception e) {
			logger.info("newsInsert@dao={}", e.getMessage());
		}
		
		return result;
	}

	@Override
	public List<Map<String, String>> selectAllNews(RowBounds rb) {
		return sqlSession.selectList("admin.selectAllNews", null, rb);
	}
}