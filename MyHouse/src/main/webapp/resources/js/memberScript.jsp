<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<script>
$(function() {
	/* 일반회원 */
	/*기존modal 닫기*/
	$("button#member-enroll-btn").on("click", function() {
		$("#exampleModal_").modal("hide");
	});

	$("button#id-find-btn, button#pwd-find-btn").on("click",
			function() {
				$("#exampleModal").modal("hide");
			});

	/*회원가입submit*/
	$("button#member-enroll-end-btn").on("click", function() {
		$("#member-enrollFrm").submit();
	});

	/*아이디 유효성검사,중복확인*/
	$("input#member-enroll-email").blur(function() {
		var param = {
			memberEmail : $("input#member-enroll-email").val()
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/member/checkMemberEmail.do",
			data : param,
			type : "post",
			success : function(data) {
				console.log(data);
				if (data == "true") {
					$("span#s-email").text("이미 사용중인 이메일입니다.");
					$("span#s-email").css("color", "red");
					$("button#member-enroll-end-btn").attr("disabled",true);
				} else {
					$("span#s-email").text("사용가능한 이메일입니다.");
					$("span#s-email").css("color", "blue");
					$("button#member-enroll-end-btn").attr("disabled",false);
				}
			},
			error : function(jqxhr, textStatus,	errorThrown) {
				console.log("ajax처리실패: " + jqxhr.status);
				console.log(errorThrown);
			}
		});
	});

	/*비밀번호 유효성검사*/
	$("input#member-enroll-password").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var bool = regExp.test(pwd);

		if (bool != true) {
			alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
			$("input#member-enroll-password").css("color", "red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-password").css("color", "blue");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});

	$("input#member-enroll-password_").blur(function() {
		var pwd = $("input#member-enroll-password").val();
		var pwd_ = $(this).val();
		var bool = (pwd == pwd_);

		if (bool != true) {
			$("input#member-enroll-password_").css("color", "red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-password_").css("color", "blue");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});

	/*전화번호 유효성검사*/
	$("input#member-enroll-phone").blur(function() {
		var regExp = /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/;
		var phone = $(this).val();
		var bool = regExp.test(phone);

		if (bool != true) {
			$("input#member-enroll-phone").css("color","red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-phone").css("color","black");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});

	/* 아이디 찾기 */
	$("id-find-end-btn").on("click",function() {
		var param = {
			memberEmail : $("input#find-id-name").val(),
			phone : $("input#find-id-phone").val()
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/member/findId.do",
			type : "POST",
			data : param,
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			dataType : "json",

			success : function(data) {
				var emailLists = data.memberEmail;
				var emailLength = emailLists.length;
				var emailfind = emailLists
						.substring(1,
								emailLength - 1);
				/* $("span#emailList").append("<h1>"+"회원님의 정보로 등록된 이메일은 : "+emailfind+" 입니다.</h1>"); */
				alert("찾으시는 아이디(이메일은)"
						+ emailfind + "입니다.")
				/* $("span#s-email").text("이미 사용중인 이메일입니다.");
				$("span#s-email").css("color", "red"); */

			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log("ajax처리실패: "
						+ jqxhr.status);
				console.log(errorThrown);
				alert('정보를 다시 입력해주시길 바랍니다.');
			}
		});

	});
});
</script>
</script>