package com.kh.myhouse.note.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.note.model.dao.NoteDAO;

@Service
public class NoteServiceImpl implements NoteService{
	
	@Autowired
	private NoteDAO noteDAO;
	
	@Override
	public List<Map<String, String>> selectNoteList(int cPage, int numPerPage) {
		return noteDAO.selectNoteList(cPage, numPerPage);
	}

	@Override
	public int selectNoteTotalContents() {
		return noteDAO.selectNoteTotalContents();
	}

	@Override
	public List<Object> selectNote(int noteno) {
		return noteDAO.selectNote(noteno);
	}

	@Override
	public int deleteNote(int noteNo) {
		return noteDAO.deleteNote(noteNo);
		
	}

}
