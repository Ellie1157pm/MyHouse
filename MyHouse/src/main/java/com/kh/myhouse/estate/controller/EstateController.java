package com.kh.myhouse.estate.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstatePhoto;

import net.sf.json.JSONArray;

@Controller
@RequestMapping("/estate")
public class EstateController {
	@Autowired
	EstateService estateService;
	
	//인덱스 화면에서 검색했을때 오는 controller
	@RequestMapping("/searchKeyword")
	public ModelAndView searchResult(ModelAndView mav,HttpServletRequest request) {
		//매물 타입 (아파트 : A, 빌라 : B, 원룸 : O, 오피스텔 : P)
		String estateType=request.getParameter("estateType");
		System.out.println("매물 타입 : "+estateType);
		//검색어
		String searchKeyword=request.getParameter("searchKeyword");
		System.out.println("검색어 : "+searchKeyword);
		
		/*중요*/
		//법정동 명이 아닌 지하철 역이나 아파트 이름으로 검색했을 때를 대비한 주소.
		//이 주소로 region 테이블에서 법정동 코드를 받아 substring(0,5) 한 뒤, 해당 코드로  그 지역의 매물을 찾아오면 됨.
		
		//주소(지역코드를 가져오기 위한 주소)
		String localName=request.getParameter("locate");
		System.out.println("지역이름 : "+localName);
		
		String localCode=estateService.selectLocalCodeFromRegion(localName);
		
		System.out.println("로컬 코드 @controller = " +localCode);
		
		//매물 리스트 받아오기<빌라,원룸,오피스텔의 경우에는 default옵션이 있다. 이부분 확인할것.
		//매매/월세/전세/전체/ 구조/보증금/주차옵션,기타옵션 등 괴애애앵장히 많다.
		//List<>
		
		
		List<Estate> list =estateService.selectApartmentname(localCode);
		System.out.println("list@@@@===="+list);
		
		//searchkeyword를 view단으로 보내 지도 api의 중심지를 searchKeyword로 잡도록 한다.
		//List관련 코드는 넣기 쉽게 정리해놓을테니 확인 요망
		
		//아파트의 경우에는 매매/전월세 외에 신축분양,인구흐름,우리집내놓기 등 탭이 있으므로 
		//다른 jsp파일로 보낸다.		
		if(searchKeyword!=null) {
		mav.addObject("searchKeyword",searchKeyword);
		}
		if(estateType.equals("A")) {
			mav.addObject("list", list);
			mav.addObject("estateType",estateType);
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
			mav.addObject("estateType",estateType);
			//default값(매매 등등등) 지정
			if(estateType.equals("B")) {
				mav.addObject("dealType","M");
			}
			mav.setViewName("/search/otherResult");
		}
		
		
		
		
		return mav;
	}
	
	@ResponseBody
	@RequestMapping( value="/findEstateTerms",produces="text/plain;application/json; charset=UTF-8",headers = {"Accept=text/xml, application/json"})
	public JSONArray fineEstateTermsApart(ModelAndView mav,String dealType,
			String areaType,String localName,String estateType ) {
		System.out.println("ajax 테스트");
		//dealType : 거래 유형 (매매,전,월세)
		System.out.println("거래유형 : "+dealType);
		//지역명 
		System.out.println("지역명: "+localName);
		//areaType : 면적(평수)=>1,10,20,30,40,50,60    <=1은 10평 이하, 나머지는 적혀진 평수의 구간, 60은 60평대 이상!! 60~69아님!
		System.out.println("평수 : "+areaType);
		//거래 매물 타입(A,V,O,P)
		System.out.println("매물 타입 : "+estateType);
		
		//지역명으로 코드 가져오기
		String localCode=estateService.selectLocalCodeFromRegion(localName.substring(0, 8));
		System.out.println(localCode);
		
		//테스트용 코드임 이건 따로 넣어야됨
		List<Estate> list =estateService.selectApartmentname(localCode);
		System.out.println(list);
		
		return  JSONArray.fromObject(list);
	}
	
	
	//지도상에 아파트클릭시 사이드바에 상세정보를 가져오기위해서
	@RequestMapping("/detailEstate")
	public void detailResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String addressName=request.getParameter("addressName");
		System.out.println("주소명 : "+addressName);
		
		String roadAddressName=request.getParameter("roadAddressName");
		System.out.println("도로명 : "+roadAddressName);
		
		Map<String, String> param = new HashMap<>();
		param.put("addressName", addressName);
		param.put("roadAddressName", roadAddressName);
		
		Estate detailEstate = estateService.selectDetailEstate(param);
		EstatePhoto estatePhoto = estateService.selectEstatePhoto(detailEstate.getEstateNo());
		
		Map<String,Object> map = new HashMap<>();
		map.put("detailEstate", detailEstate);
		map.put("estatePhoto", estatePhoto);
		
		System.out.println(detailEstate+"상세정보");
		
		response.setContentType("application/json; charset=utf-8");
		new Gson().toJson(map,response.getWriter());
	}
	
	//마크 클릭후 매물보기 버튼누르면 해당하는 매물들 가져오는 컨트롤러
	@RequestMapping("/showEstate")
	public void showEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String estateNo=request.getParameter("estateNo");
		System.out.println("매물번호 : "+estateNo);
				
		String addressName=request.getParameter("addressName");
		System.out.println("주소명 : "+addressName);
		
		String roadAddressName=request.getParameter("roadAddressName");
		System.out.println("도로명 : "+roadAddressName);
		
		Map<String, String> param = new HashMap<>();
		param.put("estateNo", estateNo);
		param.put("addressName", addressName);
		param.put("roadAddressName", roadAddressName);
		
		
	}
}
