package com.kh.myhouse.estate.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

@Controller
@RequestMapping("/estate")
public class EstateController {
	
	Logger logger=LoggerFactory.getLogger(getClass());
	
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

		String loc=request.getParameter("coords");
		System.out.println("좌표 : "+loc);
		if(loc==null||loc.trim().length()==0) {
			loc="(37.566826, 126.9786567)";
		}
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
		
		Map<String, String> map=new HashMap<>();
		map.put("estateType",estateType);
		map.put("localCode",localCode);
/*
		List<Estate> list =estateService.selectApartmentname(map);
		System.out.println("list@@@@===="+list);*/

		//searchkeyword를 view단으로 보내 지도 api의 중심지를 searchKeyword로 잡도록 한다.
		//List관련 코드는 넣기 쉽게 정리해놓을테니 확인 요망
		

		//아파트의 경우에는 매매/전월세 외에 신축분양,인구흐름,우리집내놓기 등 탭이 있으므로 
		//다른 jsp파일로 보낸다.		
		if(searchKeyword!=null) {
			mav.addObject("searchKeyword",searchKeyword);
		}
		mav.addObject("estateType",estateType);
		mav.addObject("range1","0");
		mav.addObject("range2","0");
		mav.addObject("range3","0");
		mav.addObject("range4","0");
	/*	mav.addObject("list", list);*/
		
		
		if(estateType.equals("A")) {
			mav.addObject("dealType","M");
			mav.addObject("structure","all");
			mav.addObject("localName",localName);
			mav.addObject("loc",loc);
			
			//null처리를 위한 문자배열
			String[] arr= {"0"};
			mav.addObject("option",arr);
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
			System.out.println("나머지 매물인데");
			mav.addObject("estateType",estateType);
			//default값(매매 등등등) 지정
			if(estateType.equals("B")) {
				mav.addObject("dealType","M");
			}else {
				mav.addObject("dealType","all");
			}
			String[] arr= {"0"};
			mav.addObject("option",arr);
			mav.addObject("structure","all");
			mav.addObject("localName",localName);
			mav.addObject("loc",loc);
			mav.setViewName("/search/otherResult");
		}

		return mav;
	}

	//지도에서의 필터링
	@RequestMapping("/findOtherTerms")
	public ModelAndView fineOtherTerms(ModelAndView mav, HttpServletRequest req) {
		Map<String, Object> map=new HashMap<>();
		List<String>list=new ArrayList<>();

		String estateType=req.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=req.getParameter("dealType");//거래유형
		String range1=req.getParameter("range_1");	//가격범위
		String range2=req.getParameter("range_2"); //가격범위
		String range3=req.getParameter("range_3");	//가격범위(보증-월세로 나눠질때)
		String range4=req.getParameter("range_4"); //가격범위(보증-월세로 나눠질때)
		String structure=req.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=req.getParameterValues("optionResult");
		String topOption=req.getParameter("topOption");
		//지도위치를 그쪽으로 고정하기 위한 localName =>좌표
		String coords=req.getParameter("coords");
		//지역코드를 얻기위한 address
		String address=req.getParameter("address");

		map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		map.put("topOption", topOption);
		mav=returnResult(map);
		
		return mav;
	
	}
	
	//아파트 필터링
	@RequestMapping("/findApartTerms")
	public ModelAndView findApartTerms(HttpServletRequest req,ModelAndView mav) {
		Map<String, Object> map=new HashMap<>();
		List<String> list=new ArrayList<>();
		
		String estateType=req.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=req.getParameter("dealType");//거래유형
		String range1=req.getParameter("range_1");	//가격범위
		String range2=req.getParameter("range_2"); //가격범위
		String range3=req.getParameter("range_3");	//가격범위(보증-월세로 나눠질때)
		String range4=req.getParameter("range_4"); //가격범위(보증-월세로 나눠질때)
		String structure=req.getParameter("structure");	//all인 경우와 아닌 경우로 나눠서 list에 넣어야할듯.
		String[] option=req.getParameterValues("optionResult");
		String address=req.getParameter("address");	
		//좌표
		String coords=req.getParameter("coords");	
		
		map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		mav=returnResult(map);
		return mav;
	}
	
	@RequestMapping("/filterReset")
	public ModelAndView resetFilter(ModelAndView mav,@RequestParam String address,@RequestParam String coords,@RequestParam String estateType) {
		String loc=coords;
		System.out.println("로컬네임?"+coords);
		mav.addObject("estateType",estateType);
		if(estateType.equals("A")||estateType.equals("B")) {
			mav.addObject("dealType","M");			
		}else {
			mav.addObject("dealType","all");	
		}
		mav.addObject("structure","all");
		mav.addObject("msg","viewFilter();");
		mav.addObject("loc",loc);
		mav.addObject("localName",address);
		mav.addObject("range1","0");
		mav.addObject("range2","400");
		mav.addObject("range3","0");
		mav.addObject("range4","300");
		
		
		if(estateType.equals("A")) {
		mav.setViewName("search/apartResult");
		}else {
		mav.setViewName("search/otherResult");
		}
		return mav;
	}
	
	
	
	


	//매물 클릭시 사이드바에 상세정보를 가져오기위해서
	@RequestMapping("/detailEstate")
	public void detailResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		int estateNo=Integer.parseInt(request.getParameter("estateNo"));
		System.out.println("매물번호 : "+estateNo);


		List<Map<String,String>> detailEstate = estateService.selectDetailEstate(estateNo);
		
		System.out.println(detailEstate);

		response.setContentType("application/json; charset=utf-8");
		new Gson().toJson(detailEstate,response.getWriter());
	}

	
	//마크 클릭후 해당하는 추천매물들 가져오는 컨트롤러
    @RequestMapping("/getRecommendEstate")
    public void getRecommendEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        
        int numPerPage = 10;
        int cPage = Integer.parseInt(request.getParameter("cPage"));
        
        System.out.println("클릭페이지="+cPage);
        
        String roadAddressName=request.getParameter("roadAddressName");
        String addressName=request.getParameter("addressName");
        System.out.println("도로명 : "+roadAddressName);
        System.out.println("번지명 : "+addressName);
        
        Map<String, String> param=new HashMap<>();
        param.put("roadAddressName", roadAddressName);
        param.put("addressName", addressName);
        
        
        List<Map<String,String>> showRecommendEstate = estateService.showRecommendEstate(cPage,numPerPage,param);
        
        response.setContentType("application/json; charset=utf-8");
        new Gson().toJson(showRecommendEstate,response.getWriter());
    }
    
    //마크 클릭후 해당하는 일반매물들 가져오는 컨트롤러
    @RequestMapping("/getNotRecommendEstate")
    public void getNotRecommendEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	
    	int numPerPage = 10;
    	int cPage2 = Integer.parseInt(request.getParameter("cPage2"));
    	
    	System.out.println("클릭페이지="+cPage2);
    	
    	 String roadAddressName=request.getParameter("roadAddressName");
         String addressName=request.getParameter("addressName");
         System.out.println("도로명 : "+roadAddressName);
         System.out.println("번지명 : "+addressName);
         
         Map<String, String> param=new HashMap<>();
         param.put("roadAddressName", roadAddressName);
         param.put("addressName", addressName);
    	
    	List<Map<String,String>> showNotRecommendEstate = estateService.showNotRecommendEstate(cPage2,numPerPage,param);
    	
    	System.out.println("제발 나와라="+showNotRecommendEstate.size());
    	
    	response.setContentType("application/json; charset=utf-8");
    	new Gson().toJson(showNotRecommendEstate,response.getWriter());
    }



	@RequestMapping("/EnrollTest.do")
	public String EnrollTest() {

		return "enroll/EnrollTest";
	}

	@PostMapping("/EnrollTestEnd.do")
	public String EnrollTestEnd(@RequestParam String address1,
			@RequestParam String address2,
			@RequestParam String phone1,
			@RequestParam String phone2,
			@RequestParam String phone3,
			@RequestParam char estateType,
			@RequestParam char transactiontype,
			@RequestParam int deposit,
			@RequestParam int[] mon,
			@RequestParam int ManageMenetFee,
			@RequestParam int estateArea,
			@RequestParam String estatecontent,
			@RequestParam String[] etcoption,
			@RequestParam int MemberNo,
			@RequestParam int BusinessMemberNo,
			@RequestParam String agentphone,
			@RequestParam String SubwayStation,
			@RequestParam String[] construction,
            @RequestParam String[] flooropt,
			MultipartFile[] upFile,
			HttpServletRequest request,
			Model model

			) {


		System.out.println("address1 주소명=="+address1);
		System.out.println("address2 주소상세=="+address2);
		String phone = phone1+phone2+phone3;
		System.out.println("phone 폰번호=="+phone);
		System.out.println("estateType 빌라,아파트,오피스텔=="+estateType);
		System.out.println("transactiontype 전세,매매,월세 라디오버튼값=="+transactiontype);
		System.out.println("deposit 보증금=="+deposit);
		System.out.println("mon 전세,매매,월세 가격입력값=="+Arrays.toString(mon));//mon[0]:월세 /mon[1]:전세 /mon[2]:매물가 
		System.out.println("ManageMenetFee 관리비=="+ManageMenetFee);
		System.out.println("estateArea 평수=="+estateArea);
		System.out.println("estatecontent 주변환경=="+estatecontent);
		System.out.println("etcoption 엘레베이터,애완동물 등=="+Arrays.toString(etcoption));
		System.out.println("SubwayStation 전철역=="+SubwayStation);
		System.out.println("upFile 파일명=="+Arrays.toString(upFile));

		//지역코드 얻어오기
		String address= (address1.substring(0,6));	
		String localCode=estateService.selectLocalCodeFromRegion(address); 
		System.out.println("localCode 지역코드의 값 =="+localCode);

		//전세 매매 월세 코드에 맞는 ,전세 ,월세 ,매매값 넣기
		int estateprice= 0;
		if(transactiontype=='J') {
			estateprice = mon[1];
		}
		else if(transactiontype=='M') {
			estateprice = mon[2];
		}
		else {
			estateprice = mon[0];
		}


		System.out.println("ss의 값은 ====="+estateprice);
		System.out.println("transactiontype의 값은 ====="+transactiontype);
     
		if(!agentphone.equals("0")) {
			phone = agentphone;
		}
		
		
		//매물 테이블에 insert 
	Estate estate =new Estate(0, localCode, MemberNo,
			BusinessMemberNo, phone, agentphone,
				address1, estateType, transactiontype, estateprice, 
				ManageMenetFee, estateArea, SubwayStation, 
				estatecontent, null, deposit,address2);

		String msg ="에러입니다.";
		System.out.println("ESTATE E의 값은@@@@@@@"+estate);
		int result =estateService.EstateInsert(estate);
		System.out.println("result@@@@=="+result);
		

		// tbl_option에 etcoption 엘레베이터,애완동물 등 insert
		Option option = new Option(0, etcoption, construction,flooropt);

		int result2 = estateService.estateoptionlist(option);
		System.out.println("result22222222@@@@=="+result2);


		// 사진 테이블에  이름 넣기
		int result3 =0;
		try {
			//1. 파일 업로드
			String saveDirectory = request.getSession()
					.getServletContext()
					.getRealPath("/resources/upload/estateenroll");


			List<EstateAttach> attachList = new ArrayList<>();
			for(MultipartFile f : upFile) {
				if(!f.isEmpty()) {

					String originalFileName = f.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
					SimpleDateFormat sdf =new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);

					String renamedFileName 
					= sdf.format(new Date())+"_"+rndNum+"."+ext;

					System.out.println("saveDirectory@@@@@@@@@==="+saveDirectory);
					System.out.println("renamedFileName@@@@@@@@@==="+renamedFileName);
					//서버 지정위치에 파일 보관
					try {
						f.transferTo(new File(saveDirectory+"/"+renamedFileName));

					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}	

					EstateAttach attach =new EstateAttach();
					attach.setOriginalFileName(originalFileName);
					attach.setRenamedFileName(renamedFileName);

					//list에 vo담기
					attachList.add(attach);
					System.out.println("attachList @@@@@"+attachList);
					//2.업무로직 : db에 게시물 등록

				}	
			}
			result3 = estateService.insertattach(attachList);
			System.out.println("result3 ===="+result3);
		}catch(Exception e) {
			e.printStackTrace();
		}


		if(result>0 && result2>0 && result3>0) {
			msg="수정성공!!!";
		}


		model.addAttribute("msg",msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/findApartTermsTest")
    public void findApartTermsTest( ModelAndView mav, HttpServletRequest request, HttpServletResponse response) throws JsonIOException, IOException {
        String coords=request.getParameter("coords");
        String estateType=request.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=request.getParameter("dealType");//거래유형
		String range1=request.getParameter("range1");	//가격범위
		String range2=request.getParameter("range2"); //가격범위
		String range3=request.getParameter("range3");	//가격범위(보증-월세로 나눠질때)
		String range4=request.getParameter("range4"); //가격범위(보증-월세로 나눠질때)
		String structure=request.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=request.getParameterValues("optionResult");
		String topOption=request.getParameter("topOption");
		String address=request.getParameter("address");
		

        
        List<Estate> list =new ArrayList<>();
        Map<String, Object> map=new HashMap<>();
        
        map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		if(topOption!=null) {
		map.put("topOption", topOption);}
        
        mav=returnResult(map);

         response.setContentType("application/json; charset=utf-8");
            new Gson().toJson(mav,response.getWriter());
    }
	

	
	
	public ModelAndView returnResult(Map<String,Object> map) {
		List<String>list=new ArrayList<>();
		ModelAndView mav = new ModelAndView();
		String estateType=(String) map.get("estateType");
		String range1=(String)map.get("range1");
		String range2=(String)map.get("range2");
		String range3=(String)map.get("range3");
		String range4=(String)map.get("range4");
		String dealType=(String)map.get("dealType");
		String structure=(String)map.get("structure");
		String[] option=(String[])map.get("option");
		String address=(String)map.get("address");
		String coords=(String)map.get("coords");
		String topOption=(String)map.get("topOption");
	
		

		if(structure==null) {
			structure="all";
			map.put("structure", structure);
			System.out.println("구조 : "+structure);
		}
		if(option==null) {
			String[] option2= {"a","a","a"};
			for(int i=0;i<option2.length;i++) {
				System.out.println(option2[i]);
			}
			mav.addObject("option",option2);
		}else{
			System.out.println("옵션 : "+option);
			mav.addObject("option",option);
			map.put("option", option);
		}
		if(topOption==null||topOption.trim().length()==0) {			
			topOption="all";
			map.put("topOption", topOption);
		}
		if(range1.equals("0")&&(range2.equals("300")||range2.equals("400")||range2.equals("200"))){
			range2="100000000";
		}
		map.put("range2", range2);
		
		
		String localCode=estateService.selectLocalCodeFromRegion(address);
		
		map.put("localCode", localCode);
		
		System.out.println("매물유형 : "+estateType);
		System.out.println("좌표 : "+coords);
		System.out.println("거래유 : "+dealType);
		System.out.println("주소 : " +address);
		System.out.println("로컬코드 : " +localCode);
		System.out.println("구조  : "+structure);
		
		//아파트가 아닌 경우
		if(!(estateType.equals("A"))) {
			System.out.println("아파트 아님 ");
			//빌라 매매/전세인 경우
			if(dealType.equals("M")||dealType.equals("J")) {
				//구조가 all이고 옵션이 없을때
				if(structure.equals("all")&&option==null) {
					list=estateService.selectEstateListForAllNotOption(map);
				}else if(structure.equals("all")&&option!=null) {
					list=estateService.selectEstateListForAllSelectOption(map);
				}else if(!structure.equals("all")&&option==null) {
					list=estateService.selectEstateListSelectStructureNotOption(map);
				}else {
					//구조가 전체가 아니고 옵션이 있을때
					list=estateService.selectEstateListSelectStructureNotOptoin(map);}
			}
			//월세 혹은 전체인 경우 =>range3,4 추가해야되므로 나눠줌
			else {
				//구조가 전체일 때-option의 null여부와 topOption이 all인지 아닌지로 비교
				if(structure.equals("all")&&option==null&&topOption.equals("all")) {
					list=estateService.selectEstateListForAllNotOptionForMontlyFee(map);
				}else if(structure.equals("all")&&option==null&&!topOption.equals("all")) {
					map.put("topOption", topOption);
					list=estateService.selectEstateListForAllNotOptionSelectFloorOptionForMontlyFee(map);
				}
				
				else if(structure.equals("all")&&option!=null&&topOption.equals("all")) {
					map.put("option", option);
					list=estateService.selectEstateListForAllSelectOptionNotFloorOpionForMontlyFee(map);
				}else if(structure.equals("all")&&option!=null&&!topOption.equals("all")) {
					map.put("option", option);
					map.put("topOption", topOption);
					list=estateService.selectEstateListForAllSelectOptionSelectFloorOptionMontlyFee(map);
				}
				
				//구조가 전체가 아닐 때-option의 null여부와 topOption이 all인지 아닌지로 비교
				else if(!structure.equals("all")&&option==null&&topOption.equals("all")) {
					map.put("structure", structure);
					list=estateService.selectEstateListSelectStructureNotOpionNotFloorOptionMontlyFee(map);
				}else if(!structure.equals("all")&&option==null&&!topOption.equals("all")) {
					map.put("structure", structure);
					map.put("topOption", topOption);
					list=estateService.selectEstateListSelectStructureNotOpionSelectFloorOptionMontlyFee(map);
				}
				
				
				else if(!structure.equals("all")&&option!=null&&topOption.equals("all")) {

					list=estateService.selectEstateListSelectStructureSelectOptionNotFloorOptionMontlyFee(map);
				}else{
					list=estateService.selectEstateListSelectStructureSelectOptionSelectFloorOptionMontlyFee(map);
				}
				
			}
		
		//원룸인 경우=>옵션 다수

		mav.addObject("dealType",dealType);
		mav.addObject("loc",coords);
		mav.addObject("estateType",estateType);
		mav.addObject("range1",range1);
		mav.addObject("range2",range2);
		mav.addObject("range3",range3);
		mav.addObject("range4",range4);
		mav.addObject("topOption",topOption);
		mav.addObject("structure",structure);
		mav.addObject("option",option);
		mav.addObject("list",list);
		mav.addObject("msg","viewFilter();");
		
		mav.setViewName("search/otherResult");
		}
		//아파트인 경우
		else {
			System.out.println("아파트임");
			if(dealType.equals("M")||dealType.equals("J")) {
				//all 이면 전체 검색
				//평형대가 전체이고 옵션이 있을때
				if(structure.equals("all")&&option!=null) {
					list=estateService.selectApartListForAllSelectOption(map);					
				}
				//평형대가 전체고 옵션 선택 안했을때
				else if(structure.equals("all")&&(option==null)) {
					System.out.println("평형대가 전체고 옵션 선택 안했을때");
					System.out.println(map);
					list=estateService.selectApartListForAll(map);
				}
				//평형대 선택을 했고 옵션이 없을떄
				else if(!structure.equals("all")&&option==null) {
					map.put("structure", structure);
					list=estateService.selectApartListSelectStructureNotOption(map);
				}
				//평형대 선택을 했고 옵션이 있을때.
				else if(!structure.equals("all")&&option!=null) {
					list=estateService.selectApartListSelectStructureSelectOption(map);
				}
			}
			//월세일 때
			else {
				//구조가 전체고 옵션이 있을때
				if(structure.equals("all")&&option!=null) {
					map.put("option", option);
					list=estateService.selectApartListForAllSelectOptionAndMontlyFee(map);
				}else if(!structure.equals("all")&&option!=null) {
					//구조가 전체가 아니고 옵션이 있을때
					map.put("option", option);
					list=estateService.selectApartListForSelectStructureSelectOptionAndMontlyFee(map);
				}else if(!structure.equals("all")&&option==null) {
					//구조가 전체가 아니고 옵션이 없을때
					list=estateService.selectApartListForSelectStructureNotOptionAndMontlyFee(map);
				}else if(structure.equals("all")&&option==null) {
					//구조가 전체고 옵션이 없을때
					list=estateService.selectApartListForAllNotOptionAndMontlyFee(map);
				}
			}
			System.out.println("리스트");
			System.out.println(list);
			 
			//view단 처리
			mav.addObject("dealType",dealType);
			mav.addObject("loc",coords);
			mav.addObject("estateType",estateType);
			mav.addObject("range1",range1);
			mav.addObject("range2",range2);
			mav.addObject("range3",range3);
			mav.addObject("range4",range4);
			mav.addObject("structure",structure);
			mav.addObject("list",list);
			mav.addObject("msg","viewFilter();");
			
			mav.setViewName("search/apartResult");
		}
		
		return mav;
	}
	
	@RequestMapping("/unitChange")
	@ResponseBody
	public Object unitChange(@RequestParam(value="unit", required=false, defaultValue="m<sup>2</sup>") String unit) {
		Map<String, String> map = new HashMap<>();
		
		logger.info("unit1@unitChange="+unit);
		
		if("m<sup>2</sup>".equals(unit))
			unit = "평";
		else
			unit = "m<sup>2</sup>";
		
		logger.info("unit2@unitChange="+unit);
		
		map.put("unit", unit);
		map.put("msg", "unit="+unit);

		return map;
	}
}