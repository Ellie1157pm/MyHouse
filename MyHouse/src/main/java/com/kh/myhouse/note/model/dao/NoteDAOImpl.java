package com.kh.myhouse.note.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NoteDAOImpl implements NoteDAO{

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Map<String, String>> selectNoteList(int cPage, int numPerPage) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("note.selectNoteList",null,rowBounds);
	}

	@Override
	public int selectNoteTotalContents() {
		return sqlSession.selectOne("note.selectNoteTotalContents");
	}

	@Override
	public List<Object> selectNote(int noteno) {
		return sqlSession.selectList("note.selectNote",noteno);
	}

	@Override
	public int deleteNote(int noteNo) {
		return sqlSession.delete("note.deleteNote",noteNo);
	}

}
