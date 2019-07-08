package com.kh.myhouse.estate.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;

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
		String[] option=new String[1];
		option[0]="random";
		
		try {
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
			mav.addObject("list",list);
			mav.addObject("localName",localName);
			mav.setViewName("search/apartResult");
			
		}
		//빌라 일때 거래 유형 default값 지정
		else if(estateType.equals("B")) {
			mav.addObject("dealType","M");
		}
		else {
			mav.addObject("dealType","all");
		}
		
		mav.addObject("estateType",estateType);
		mav.addObject("localName",localName);
		mav.addObject("structure","all");
		mav.addObject("option",option);
		mav.setViewName("search/otherResult");
		
		}catch(Exception e) {
			
		}
		
		return mav;
	}
	
	/*@ResponseBody
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
		String localCode=estateService.selectLocalCodeFromRegion(localName);
		System.out.println(localCode);
		
		//테스트용 코드임 이건 따로 넣어야됨
		List<Estate> list =estateService.selectApartmentname(localCode);
		System.out.println(list);
		
		return  JSONArray.fromObject(list);
	}*/
	
	
	@RequestMapping("/findAllTerms")
	public ModelAndView fineAllTerms(ModelAndView mav, HttpServletRequest req) {
		Map<String, String> map=new HashMap<>();
		List<Estate>list=new ArrayList<>();
		
		
		String estateType=req.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=req.getParameter("dealType");//거래유형
		String range1=req.getParameter("range_1");	//가격범위
		String range2=req.getParameter("range_2"); //가격범위
		String range3=req.getParameter("range_3");	//가격범위(보증-월세로 나눠질때)
		String range4=req.getParameter("range_4"); //가격범위(보증-월세로 나눠질때)
		String structure=req.getParameter("structure");	//all인 경우와 아닌 경우로 나눠서 list에 넣어야할듯.
		String[] option=req.getParameterValues("optionResult");	//option길이만큼 for문 돌려서 list에 add 하는 방식으로.
		String topOption=req.getParameter("topOption");
		System.out.println("옵션 "+option);
		
		//파라미터 확인
		System.out.println("건물 유형 : "+estateType);
		System.out.println("매매 유형 : "+dealType);
		System.out.println("금액 최소 : "+range1);
		System.out.println("금액 최대 : "+range2);
		if(dealType.equals("O")) {
		System.out.println("월세 최소 : "+range3);
		System.out.println("월세 최대 : "+range4);
		}

		if(structure==null) {
			structure="all";
		}
		System.out.println(" 구조 유형 : "+structure);
		if(option!=null) {
			for(int i=0;i<option.length;i++) {
				System.out.println("옵션 유형 : "+option[i]);
			}
		}
		if(topOption==null) {			
			topOption="all";
		}
		System.out.println("topOption : "+ topOption);
		
		map.put("estateType", estateType);
		map.put("dealType", dealType);
		//전세 혹은 매매금 범위 between #{range1} and #{range2}
		map.put("range1", range1);
		map.put("range2", range2);
		//빌라 인 경우
		if(estateType.equals("B")) {
			//빌라 매매/전세인 경우
			if(dealType.equals("M")||dealType.equals("J")) {
				//structure =>all, 2,3,4 <-방 개수
				//매매가/구조/주차옵션 || //전세금/구조/주차옵션
			}
			//월세인 경우
			else {
				map.put("range3", range3);
				map.put("range4", range4);
				//보증금,집 구조,월세,주차옵션
			}
		}
		//원룸인 경우=>옵션 다수
		else if(estateType.equals("O") ||estateType.equals("P")) {
			//전체 혹은 월세인 경우
			if(dealType.equals("all")||dealType.equals("O")) {
				map.put("range3", range3);
				map.put("range4", range4);
				map.put("topOption", topOption);
				
			}else {
				//전세인경우
				map.put("topOption", topOption);
				
			}
		}
		
		
		
		mav.addObject("dealType",dealType);
		mav.addObject("estateType",estateType);
		mav.addObject("range1",range1);
		mav.addObject("range2",range2);
		mav.addObject("range3",range3);
		mav.addObject("range4",range4);
		mav.addObject("topOption",topOption);
		mav.addObject("structure",structure);
		mav.addObject("option",option);
		
		mav.addObject("msg","viewFilter();");

		mav.setViewName("search/otherResult");
		return mav;
	}
	}
