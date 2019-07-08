package com.kh.myhouse.admin.model.service;

import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.admin.model.dao.AdminDAO;
import com.kh.myhouse.admin.model.vo.Item;

@Service
public class AdminServiceImpl implements AdminService {
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
		adminDAO.newsAllData(title);
	}

	@Override
	public List<Map<String, String>> newsAllData(int cPage) {
		List<Map<String, String>> list = new ArrayList<>();
		
		try {
			int numPerPage = 10;
			int offset = (cPage*numPerPage)-numPerPage;
			RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
			
			list = adminDAO.selectAllNews(rb);
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return list;
	}
}
