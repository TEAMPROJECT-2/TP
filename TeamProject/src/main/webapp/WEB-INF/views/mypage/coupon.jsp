<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en" class="light-style layout-menu-relative" dir="ltr" data-theme="theme-default" data-assets-path="../assets/" data-template="vertical-menu-template-free">
<head>
<script src="http://code.jquery.com/jquery-3.6.0.js"></script>
<%-- <script src="${pageContext.request.contextPath }/resources/jsPro/mycoupon.js"></script> --%>
<%
 String strReferer = request.getHeader("referer"); //이전 URL 가져오기

 if(strReferer == null){
%>
<script language="javascript">
  alert("정상적인 경로를 통해 다시 접근해 주세요.");
  document.location.href="${pageContext.request.contextPath }/main/main";
 </script>
<%
  return;
 }
%>
<script type="text/javascript">
$(document).ready(function() {

	$("#couNum").on('focus keyup', checkCouNum);

}); // documnet

var checkCouNumResult = false;			// 쿠폰 코드 중복검사

function checkCouNum() {

	var numRegex = /^[0-9]{18}$/;
	var couNum = $('#couNum').val();
	var spanElem = document.getElementById("checkCouNumResult");

	if (!numRegex.exec(couNum) || couNum.length == 0 || couNum.length == "") {

		spanElem.innerHTML = "18자리의 숫자를 입력해주세요";
		spanElem.style.color = "RED";
		checkCouNumResult = false;
	} else {	debugger; // 18자리가 숫자가 맞으면 들어옴

		$.ajax({
			url: '${pageContext.request.contextPath }/admin/couNumDupCheck',
			data: { 'couNum': couNum },
			type: 'POST',
			success: function(rdata) {debugger;
				if (rdata == '1') {	// 관리자 쿠폰 테이블에 쿠폰이 있는경우
					// 유저 테이블에 쿠폰이 있는지 검사
					$.ajax({
						url: '${pageContext.request.contextPath }/admin/myCouNumDupCheck',
						data: { 'couNum': couNum },
						type: 'POST',
						success: function(rdata) {
							if (rdata == '0') {	// 유저테이블에 쿠폰이 없으면
								spanElem.innerHTML = "사용가능한 쿠폰입니다.";
								spanElem.style.color = "GREEN";
								checkCouNumResult = true;
							} else { //유저 테이블에 쿠폰이 있으면
								spanElem.innerHTML = "이미 등록된 쿠폰입니다.";
								checkCouNumResult = false;
								spanElem.style.color = "RED";
							}
						}
					}); //ajax myCouNumDupCheck

				} else { // 관리자 쿠폰 테이블에 쿠폰이 없는경우
					checkCouNumResult = false;
					spanElem.innerHTML = "없는 쿠폰입니다.";
					spanElem.style.color = "RED";
				}
			}
		}); //couNumDupCheck ajax







	}

} // checkCouNum 마지막 괄호

function myCouponChk() {

	var couNm = $('#couNum').val();

	if (!checkCouNumResult) {
		alert("쿠폰 코드 체크 필수");
		$('#couNum').focus();
		return false;
	} else {
		return true;
	}


}

</script>
</head>

<body>
	<!-- 메뉴단 -->
	<jsp:include page="../inc/menu.jsp" />
	<!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
		<div class="layout-container">
			<jsp:include page="../inc/mypage-menu.jsp" />

			<!-- Content wrapper -->
			<div class="content-wrapper">
				<!-- Content -->

				<div class="container-xxl flex-grow-1 container-p-y">
					<h4 class="fw-bold py-3 mb-4">
						<span class="text-muted fw-light">포인트 · 쿠폰 /</span> 쿠폰
					</h4>

					<div class="row">
						<div class="col-md-12">
							<ul class="nav nav-pills flex-column flex-md-row mb-3">
								<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/mypage/point">
										<i class="bx bx-buildings me-1"></i> 포인트
									</a></li>
								<li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath }/mypage/coupon">
										<i class="bx bx-buildings me-1"></i> 쿠폰
									</a></li>
							</ul>

							<div class="card mb-4">
								<h5 class="card-header">쿠폰 등록</h5>

								<hr class="my-0" />
								<div class="card-body">
									<form id="formAccountSettings" action="${pageContext.request.contextPath}/mypage/couponInsert" onsubmit="return myCouponChk()" method="POST">
										<div class="row  mt-3 mb-3">
											<div class="mb-3 col-md-8" style="padding-left: 15%">
												<label for="userNm" class="form-label">쿠폰 코드</label>
												<input class="form-control form-control-lg" type="text" name="couNum" id="couNum" placeholder="18자리 숫자를 적어주세요" />
												<span id="checkCouNumResult">
													<!-- 쿠폰코드 결과 표시 영역 -->
												</span>
											</div>
											<div class="mb-3 col-md-4">
												<button type="submit" class="btn btn-primary me-2" style="margin-top: 1.8rem; height: 60%">+ 추가</button>
												<button type="reset" class="btn btn-outline-secondary" style="margin-top: 1.8rem; height: 60%">취소</button>
											</div>
									</form>
								</div>
							</div>
						</div>

						<!-- Examples -->

						<h5 class="pb-1 mt-5 mb-3">쿠폰 리스트</h5>
						<div class="row mb-5">
							<c:forEach var="couponDTO" items="${couponList }">
								<div class="col-md-6 col-lg-4 mb-3">
									<div class="card">
										<div class="card-header">
											<h2 style="color: #6c757d; font-weight: 990 !important">
												<strong>${couponDTO.couNum }</strong>
											</h2>
										</div>
										<div class="card-body">
											<h5 class="card-title">
												<strong>${couponDTO.couNm } <span class="badge bg-primary"> <fmt:formatNumber type="number" maxFractionDigits="0" value="${couponDTO.couDc }" />%
												</span></strong>
											</h5>
											<p class="card-text">
											<hr>
											${couponDTO.couDet }
										</div>
										<input type="hidden" name="sbCount" value="${couponDTO.couNum}" id="delCouNum">
									</div>
								</div>
							</c:forEach>
						</div>

						<div class="bd-example-snippet bd-code-snippet mt-5 mb-3">
							<div class="bd-example ">
								<nav aria-label="Standard pagination example">
									<ul class="pagination" style="margin-left: 45%; margin-right: 55%;">
										<li class="page-item"><c:if test="${couponDTO.startPage > couponDTO.pageBlock }">
												<a class="page-link" href="${pageContext.request.contextPath }
							/mypage/coupon?pageNum=${couponDTO.startPage - couponDTO.pageBlock}" aria-label="Previous">
													<span aria-hidden="true">&laquo;</span>
												</a>
											</c:if></li>

										<c:forEach var="i" begin="${couponDTO.startPage }" end="${couponDTO.endPage }" step="1">
											<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath }/mypage/coupon?pageNum=${i}">${i}</a></li>
										</c:forEach>

										<li class="page-item"><c:if test="${couponDTO.endPage < couponDTO.pageCount }">
												<a class="page-link" href="${pageContext.request.contextPath }
						 /mypage/coupon?pageNum=${couponDTO.startPage + couponDTO.pageBlock}" aria-label="Next">
													<span aria-hidden="true">&raquo;</span>
												</a>
											</c:if></li>
									</ul>
								</nav>
							</div>
						</div>


					</div>
				</div>
				<!--/ Content types -->
			</div>

			<!-- Footer -->
			<footer class="content-footer footer bg-footer-theme">
				<div class="container-xxl d-flex flex-wrap justify-content-between py-2 flex-md-row flex-column">
					<div class="mb-2 mb-md-0"></div>
					<div></div>
				</div>
			</footer>
			<!-- / Footer -->

			<div class="content-backdrop fade"></div>
		</div>
		<!-- Content wrapper -->
	</div>
	<!-- / Layout page -->
	</div>

	<!-- Overlay -->
	<div class="layout-overlay layout-menu-toggle"></div>
	</div>

	<!-- Core JS -->
	<!-- build:js assets/vendor/js/core.js -->
	<script src="${pageContext.request.contextPath }/resources/assets/vendor/libs/jquery/jquery.js"></script>
	<script src="${pageContext.request.contextPath }/resources/assets/vendor/libs/popper/popper.js"></script>
	<script src="${pageContext.request.contextPath }/resources/assets/vendor/js/bootstrap.js"></script>
	<script src="${pageContext.request.contextPath }/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

	<script src="${pageContext.request.contextPath }/resources/assets/vendor/js/menu.js"></script>
	<!-- endbuild -->

	<!-- Vendors JS -->
	<script src="${pageContext.request.contextPath }/resources/assets/vendor/libs/masonry/masonry.js"></script>

	<!-- Main JS -->
	<script src="${pageContext.request.contextPath }/resources/assets/js/main.js"></script>

	<!-- Page JS -->

	<!-- Place this tag in your head or just before your close body tag. -->
	<script async defer src="https://buttons.github.io/buttons.js"></script>

	<!-- Footer Section Begin -->
	<jsp:include page="../inc/footer.jsp" />
</body>

</html>






