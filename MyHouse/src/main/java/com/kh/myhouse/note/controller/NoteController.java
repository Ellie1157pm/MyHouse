package com.kh.myhouse.note.controller;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.kh.myhouse.note.model.service.NoteService;

@Controller
public class NoteController {
	
	@Autowired
	NoteService noteService;
	
//	@RequestMapping("/note/noteMain.do")
	@RequestMapping("/agent/warningMemo.do")
	public ModelAndView MainNote(
			@RequestParam(value="cPage",required=false, defaultValue="1") int cPage,
			@RequestParam int memberNo
			) {
		int memberNO = memberNo;
		
		ModelAndView mav = new ModelAndView();
		
		int numPerPage = 10;
		//1. 현재페이지 컨텐츠 구하기
		List<Map<String,String>> list = noteService.selectNoteList(cPage,numPerPage,memberNo);
		
		//2. 전체컨텐츠 수 구하기
		int totalContents = noteService.selectNoteTotalContents(memberNo);
		
		//3. 안읽은 컨텐츠 수 구하기
		int noReadContents = noteService.selectNoContents(memberNo);
		
		mav.addObject("list",list);
		mav.addObject("memberNO",memberNO);
		mav.addObject("totalContents",totalContents);
		mav.addObject("noReadContents",noReadContents);
		mav.addObject("numPerPage",numPerPage);
		mav.addObject("cPage", cPage);
	
		
		
		return mav;
		

	}

	@RequestMapping("/note/noteCon.do")
	@ResponseBody
	public String noteContents(@RequestParam int noteNo,
								@RequestParam int memberNo,
							HttpServletRequest request, HttpServletResponse response)
							throws ServletException, IOException {
		
		System.out.println(noteNo);
		//3. note-modal contents
		List<Object> noteContents = noteService.selectNote(noteNo);
		
		//업데이트 yn
		noteService.updateNoteYN(noteNo);
		
		response.setContentType("application/json; charset=utf-8");
		new Gson().toJson(noteContents,response.getWriter());
		
		return "/agent/warningMemo.do?memberNo="+memberNo;
		
	}
	
	@RequestMapping("/note/noteDelete.do")
	public String noteDelete(@RequestParam List<Integer> list ,
							@RequestParam int memberNo
							) {
		System.out.println("list@controller="+list);
		noteService.deleteNote(list);
		
		return "redirect:/agent/warningMemo.do?memberNo="+memberNo;
	}

}
