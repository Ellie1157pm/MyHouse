package com.kh.myhouse.interest.model.vo;

import java.util.Arrays;

public class Interest {
	private int memberNo;
	private String region;
	private String[] estateType;
	private char pet;
	private char elevator;
	private char parking;
	private char subway;
	public Interest() {
		super();
	}
	public Interest(int memberNo, String region, String[] estateType, char pet, char elevator, char parking,
			char subway) {
		super();
		this.memberNo = memberNo;
		this.region = region;
		this.estateType = estateType;
		this.pet = pet;
		this.elevator = elevator;
		this.parking = parking;
		this.subway = subway;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String[] getEstateType() {
		return estateType;
	}
	public void setEstateType(String[] estateType) {
		this.estateType = estateType;
	}
	public char getPet() {
		return pet;
	}
	public void setPet(char pet) {
		this.pet = pet;
	}
	public char getElevator() {
		return elevator;
	}
	public void setElevator(char elevator) {
		this.elevator = elevator;
	}
	public char getParking() {
		return parking;
	}
	public void setParking(char parking) {
		this.parking = parking;
	}
	public char getSubway() {
		return subway;
	}
	public void setSubway(char subway) {
		this.subway = subway;
	}
	@Override
	public String toString() {
		return "Interest [memberNo=" + memberNo + ", region=" + region + ", estateType=" + Arrays.toString(estateType)
				+ ", pet=" + pet + ", elevator=" + elevator + ", parking=" + parking + ", subway=" + subway + "]";
	}

	
}
