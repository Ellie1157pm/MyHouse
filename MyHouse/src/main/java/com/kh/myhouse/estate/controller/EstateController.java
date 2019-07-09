package com.kh.myhouse.estate.controller;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

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
			mav.addObject("dealType","M");
			mav.addObject("structure","all");
			mav.addObject("range1","0");
			mav.addObject("range2","0");
			mav.addObject("range3","0");
			mav.addObject("range4","0");
			mav.addObject("localName",localName);
			
			//null처리를 위한 문자배열
			String[] arr= {"0"};
			mav.addObject("option",arr);
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
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
			mav.setViewName("/search/otherResult");
		}




		return mav;
	}


	@RequestMapping("/findOtherTerms")
	public ModelAndView fineOtherTerms(ModelAndView mav, HttpServletRequest req) {
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
		if(option==null) {
			
		}else{
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
		mav.addObject("list",list);
		mav.addObject("msg","viewFilter();");
		
		mav.setViewName("search/otherResult");
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
		String address=req.getParameter("address");	//option길이만큼 for문 돌려서 list에 add 하는 방식으로.
		String localName=req.getParameter("address");
	
		System.out.println("=========정보=========시작");
		System.out.println("매물종류 : "+estateType);
		System.out.println("거래 유형 :"+dealType);
		System.out.println("시작금액1 : "+range1);
		System.out.println("시작금액2 : "+range2);
		System.out.println("시작금액3 : "+range3);
		System.out.println("시작금액4 : "+range4);
		System.out.println("구조 "+structure);
		System.out.println("주소"+address);
		if(option==null) {
			String[] option2=new String[3];
			for(int i=0;i<option.length;i++) {		
				//null포인트 exception방지용
				option2[i]="a";
			}
			mav.addObject("option",option2);
		}else{
				map.put("option", option);	
				mav.addObject("option",option);
		}
		System.out.println("=========정보==========끝");
		String localCode=estateService.selectLocalCodeFromRegion(localName);
		
		
		//=====================================매물 가져오기
		
		
		//매물 종류 아파트
		map.put("estateType", estateType);
		//거래 타입 M,J,O
		map.put("dealType",dealType);
		if(dealType.equals("M")||dealType.equals("J")) {
			//매매 or 전세일 경우
			map.put("range1", range1);//최소금액
			map.put("range2", range2);//최대금액
			map.put("localCode", localCode);//지역코드
			//all 이면 전체 검색
			//평형대가 전체이고 옵션이 있을때
			if(structure.equals("all")&&option!=null) {
				map.put("option", option);
				list=estateService.selectApartListForAllSelectOption(map);					
			}
			//평형대가 전체고 옵션 선택 안했을때
			else if(structure.equals("all")&&(option==null)) {
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
			map.put("range1", range1);//최소금액
			map.put("range2", range2);//최대금액
			map.put("localCode", localCode);//지역코드
			map.put("range3", range3);//월세 최소금액
			map.put("range4", range4);//월세 최대금액
			map.put("localCode", localCode);//지역코드
		}

		
		
		
		
		
		
		//view단 처리
		mav.addObject("dealType",dealType);
		mav.addObject("estateType",estateType);
		mav.addObject("range1",range1);
		mav.addObject("range2",range2);
		mav.addObject("range3",range3);
		mav.addObject("range4",range4);
		mav.addObject("structure",structure);
		mav.addObject("list",list);
		mav.addObject("localName",localName);
		mav.addObject("msg","viewFilter();");
		
		mav.setViewName("search/apartResult");
		return mav;
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
		EstateAttach estateAttach = estateService.selectEstateAttach(detailEstate.getEstateNo());

		Map<String,Object> map = new HashMap<>();
		map.put("detailEstate", detailEstate);
		map.put("EstateAttach", estateAttach);

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
	
	
	 //마크 클릭후 해당하는 매물들 가져오는 컨트롤러
    @RequestMapping("/getEstate")
    public void getEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        
        int numPerPage = 10;
        int cPage = Integer.parseInt(request.getParameter("cPage"));
        
        System.out.println("클릭페이지="+cPage);
        
        String roadAddressName=request.getParameter("roadAddressName");
        System.out.println("도로명 : "+roadAddressName);
        
        
        List<Map<String,String>> showEstate = estateService.selectShowEstate(cPage,numPerPage,roadAddressName);
        
        System.out.println("제발나와라"+showEstate);
        
        response.setContentType("application/json; charset=utf-8");
        new Gson().toJson(showEstate,response.getWriter());
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
			estateprice = mon[0];
		}
		else {
			estateprice = mon[2];
		}


		System.out.println("ss의 값은 ====="+estateprice);
		System.out.println("transactiontype의 값은 ====="+transactiontype);

		//매물 테이블에 insert 
		Estate estate =new Estate(0, localCode, 0,
				0, phone, "01012341234",
				address1, estateType, transactiontype, estateprice, 
				ManageMenetFee, estateArea, SubwayStation, 
				estatecontent, null, deposit);

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




}
