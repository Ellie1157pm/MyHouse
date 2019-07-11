<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet"
	  href="${pageContext.request.contextPath }/resources/css/admin/adminIndexBoard.css" />
<div class="main-intro">
    <div class="wrap-840">
        <div class="m-tv">
		<a href="/home/RegisterInfo" style="display:block" ><img style="display:block" src="//s.zigbang.com/v1/web/main/banner_agent_register.jpg" width="260" height="200" alt="중개사무소 가입 및 광고 방법 자세히 알아보기" /></a>
        </div>
        <div class="m-news" id="m-news">
            <h4>뉴스</h4>
            <div class="item_box">
            	<c:forEach items="${newsList}" var="news">
					<div>
					  <a class="none-underline" href="#"
			    		   data-toggle="modal" data-target="#exampleModalCenter"
			    		   data-title="${news.NEWS_TITLE}"
			    		   data-content="${news.NEWS_CONTENT}&#60;/br&#62;&#60;/br&#62;&#60;div style='text-align:center;'&#62;&#60;a class='none-underline' href='${news.NEWS_LINK}' target='_blank'&#62;[원본 링크]&#60;/a&#62;&#60;/div&#62;">
		    		   	${fn:substring(news.NEWS_TITLE, 0, 30)}...</a>
					</div>
            	</c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/admin/board" class="item_more" title="뉴스 더보기">더보기</a>
        </div>

        <div class="m-notice" id="m-notice">
            <h4>공지사항</h4>
            <div class="item_box">
            	<c:forEach items="${noticeList}" var="notice">
					<div>
					  <a class="none-underline" href="#"
			    		   data-toggle="modal" data-target="#exampleModalCenter"
			    		   data-title="${notice.NOTICE_TITLE}"
			    		   data-content="${notice.NOTICE_CONTENT}">${notice.NOTICE_TITLE}</a>
					</div>
            	</c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/admin/board?item=notice" class="item_more" title="공지사항 더보기">더보기</a>
        </div>
    </div>
</div>

<!-- Modal Section -->
<script>
$(function() {
	$('#exampleModalCenter').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var title = button.data('title') // Extract info from data-* attributes
	  var content = button.data('content')
	  console.log("title="+title);
	  console.log("content="+content);
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  modal.find('.modal-title').text(title)
	  modal.find('.modal-body p').html(content)
	});
});
</script>
<div class="modal fade" id="exampleModalCenter" tabindex="-1"
	role="dialog" aria-labelledby="exampleModalCenterTitle"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalCenterTitle">Modal
					title</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p></p>
			</div>
			<div class="modal-footer">
				<c:if test="${item eq 'notice'}">
					<button type="button" class="btn btn-secondary">수정</button>
					<button type="button" class="btn btn-secondary">삭제</button>
				</c:if>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
