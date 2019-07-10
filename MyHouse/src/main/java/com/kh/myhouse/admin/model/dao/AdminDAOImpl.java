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
	public List<Map<String, String>> selectMemberList(RowBounds rb) {
		return sqlSession.selectList("admin.selectMemberList", null, rb);
	}

	@Override
	public List<Map<String, String>> selectRealtorList(RowBounds rb) {
		return sqlSession.selectList("admin.selectRealtorList", null, rb);
	}

	@Override
	public List<Map<String, String>> selectReportList(RowBounds rb) {
		return sqlSession.selectList("admin.selectReportList", null, rb);
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

	@Override
	public int insertNotice(Map<String, String> param) {
		return sqlSession.insert("admin.insertNotice", param);
	}
	
	@Override
	public int newsTotalPage() {
		return sqlSession.selectOne("admin.newsTotalPage");
	}
	
	@Override
	public int noticeTotalPage() {
		return sqlSession.selectOne("admin.noticeTotalPage");
	}
	
	@Override
	public List<Map<String, String>> selectAllNotice(RowBounds rb) {
		return sqlSession.selectList("admin.selectAllNotice", null, rb);
	}

	@Override
	public int memberTotalPage() {
		return sqlSession.selectOne("admin.memberTotalPage");
	}

	@Override
	public int realtorTotalPage() {
		return sqlSession.selectOne("admin.realtorTotalPage");
	}

	@Override
	public int reportTotalPage() {
		return sqlSession.selectOne("admin.reportTotalPage");
	}
}