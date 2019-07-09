package com.kh.myhouse.admin.model.service;

import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.admin.model.dao.AdminDAO;
import com.kh.myhouse.admin.model.vo.Item;
import com.kh.myhouse.admin.model.vo.Rss;

@Service
public class AdminServiceImpl implements AdminService {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired 
	private AdminDAO adminDAO;

	@Override
	public List<Map<String, String>> selectMemberList() {
		return adminDAO.selectMemberList();
	}

	@Override
	public List<Map<String, String>> selectRealtorList() {
		return adminDAO.selectRealtorList();
	}

	@Override
	public List<Map<String, String>> selectReportList() {
		return adminDAO.selectReportList();
	}

	@Override
	public String selectMemberEmail(String recipient) {
		return adminDAO.selectMemberEmail(recipient);
	}

	@Override
	public int insertWarn(String memberNo, String memoContent) {
		// 쪽지 대상자가 일반회원인지 중개회원인지 구분
//		String status = adminDAO.getMemberStatus(memberNo);
//		Map<String, String> param = new HashMap<>();
//		param.put("memberNo", memberNo);
//		param.put("memoContent", memoContent);
//		
//		// 중개회원일 경우 경고테이블에 있으면 insert, 없으면 update
//		String msg = "";
//		int result = 0;
//		if("U".equals(status)){
//			if(adminDAO.selectOneMember(memberNo) > 0)
//				result = adminDAO.insertWarn(memberNo);
//			else
//				result = adminDAO.updateWarn(memberNo);
//			
//			// 만약 경고가 입력이 안 된다면 여기서 반환시킨다.
//			if(result == 0) {
//				map.put("msg", "경고 처리 실패!");
//				return map;
//			}
//				
//		}
//		
//		// 회원 등급에 상관없이 쪽지를 보내는 기능은 동일하다.
//		result = adminDAO.insertReportMemo(param);
		
		return 0;
	}

	@Override
	public void newsAllData(String title) {
		List<Item> list = new ArrayList<>();
		SimpleDateFormat rssFmt = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z", Locale.US);
		SimpleDateFormat strFmt = new SimpleDateFormat("yyyy/MM/dd");
		
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
				news.put("newsLink", item.getLink());
				String desc = item.getDescription();
				desc = desc.replace(".", "")
						   .replaceAll("[A-Za-z]", "")
						   .replace("'", "");
				news.put("newsContent", desc);
				Date date = rssFmt.parse(item.getPubDate());
				String strDate = strFmt.format(date);
				news.put("newsDate", strDate);
				news.put("newsAuthor", item.getAuthor());
				news.put("newsCategory", item.getCategory());
				adminDAO.insertNews(news);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Map<String, String>> selectAllNews(int cPage) {
		List<Map<String, String>> list = new ArrayList<>();
		
		try {
			int numPerPage = 10;
			int offset = numPerPage*(cPage-1);
			RowBounds rb = new RowBounds(offset, numPerPage);
			
			list = adminDAO.selectAllNews(rb);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
