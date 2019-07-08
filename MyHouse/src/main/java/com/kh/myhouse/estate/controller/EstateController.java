package com.kh.myhouse.estate.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;




@Controller
@RequestMapping("/search")
public class EstateController<Attachment> {
	 Logger logger = LoggerFactory.getLogger(getClass());
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
		
		//매물 리스트 받아오기
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
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
			mav.setViewName("/search/otherResult");
		}
		
		
		
		
		return mav;
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
		Option option = new Option(0, etcoption);
		
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
