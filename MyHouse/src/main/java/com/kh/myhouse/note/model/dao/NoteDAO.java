package com.kh.myhouse.note.model.dao;

import java.util.List;
import java.util.Map;

public interface NoteDAO {

	List<Map<String, String>> selectNoteList(int cPage, int numPerPage);

	int selectNoteTotalContents();

	List<Object> selectNote(int noteno);

	void deleteNote(int noteNo);


}
