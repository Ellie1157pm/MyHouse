package com.kh.myhouse.estate.model.vo;

import java.util.Arrays;

public class Option {
	private int estateNo;
	private String[] optionDetail;

	public Option() {
		super();
		
	}

	public Option(int estateNo, String[] optionDetail) {
		super();
		this.estateNo = estateNo;
		this.optionDetail = optionDetail;
	}

	public int getEstateNo() {
		return estateNo;
	}

	public void setEstateNo(int estateNo) {
		this.estateNo = estateNo;
	}

	public String[] getOptionDetail() {
		return optionDetail;
	}

	public void setOptionDetail(String[] optionDetail) {
		this.optionDetail = optionDetail;
	}

	@Override
	public String toString() {
		return "Option [estateNo=" + estateNo + ", optionDetail=" + Arrays.toString(optionDetail) + "]";
	}

}
