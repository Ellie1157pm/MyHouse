package com.kh.myhouse.admin.model.dao;

import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.admin.model.vo.Item;
import com.kh.myhouse.admin.model.vo.Rss;

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
	public void newsAllData(String title) {
		List<Item> list = new ArrayList<>();
		
		try {
			URL url = new URL("http://newssearch.naver.com/search.naver?where=rss&query="
							+URLEncoder.encode(title, "UTF-8"));
			
			JAXBContext jc = JAXBContext.newInstance(Rss.class);
			Unmarshaller um = jc.createUnmarshaller();
			Rss rss = (Rss)um.unmarshal(url);
			list = rss.getChannel().getItem();
			for(Item item : list) {
				Map<String, String> news = new HashMap<>();
				news.put("newsTitle", item.getTitle());
				String desc = item.getDescription();
				desc = desc.replace(".", "");
				desc = desc.replaceAll("[A-Za-z", "");
				desc = desc.replace("'", "");
//				news.put("msg", item.getDescription());
				news.put("newsContent", desc);
				news.put("newsDate", item.getPubDate());
				newsInsert(news);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void newsInsert(Map<String, String> news) {
		try {
			int result = sqlSession.insert("admin.newsInsert", news);
			
			if(result>0)
				logger.info("뉴스 저장 성공");
			else
				logger.info("뉴스 저장 실패");
				
		} catch (Exception e) {
			logger.info("newsInsert@dao={}", e.getMessage());
		}
	}

	@Override
	public List<Map<String, String>> selectAllNews(RowBounds rb) {
		return sqlSession.selectList("admin.selectAllNews", null, rb);
	}
}
