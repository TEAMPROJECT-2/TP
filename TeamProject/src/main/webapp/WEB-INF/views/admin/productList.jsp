<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html
  lang="en"
  class="light-style layout-menu-relative"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="../assets/"
  data-template="vertical-menu-template-free"
>
  <head>
  <script src="http://code.jquery.com/jquery-3.6.0.js"></script>
   <script type="text/javascript">
//전체체크시작

  $(function(){
  	var chkObj = document.getElementsByName("CheckRow");
  	var rowCnt = chkObj.length;

  	$("input[name='allCheck']").click(function(){
  		var chk_listArr = $("input[name='CheckRow']");
  		for (var i=0; i<chk_listArr.length;i++){
  			chk_listArr[i].checked = this.checked;
  		}
  	});
  	$("input[name='CheckRow']").click(function(){

  			if($("input[name='RowCheck']:checked").length == rowCnt){
  				$("input[name='allCheck']")[0].checked =true;
  			}
  			else {
  				$("input[name='allCheck']")[0].checked = false;
  			}
  	});
  });

  // 전체 체크 끝

  // 삭제 코드 시작
  function deleteValue(){
  	var sendUrl = "delete";       // Controller로 보내는 URL Controller에 /delete로 전송되고 매핑함
  	var valueArr = new Array();   // valueArr에 체크된 데이터가 배열로 저장
  	var list = $("input[name='CheckRow']"); // list는 CheckRow(그페이지에 있는 행수)가 저장됨
  	for(var i =0; i <list.length; i++){ // 그페이지에 있는 행수 만큼 for문을 돌리되
  		if(list[i].checked){            // 선택되어 있으면 배열값에 저장
  			valueArr.push(list[i].value);
  			console.log(list[i].value);
  		}
  	}



  	if (valueArr.length == 0){ //valueArr길이가 0이면 경고창
  		alert("항목을 선택하세요");
  	}
  	else{
  		var chk = confirm("정말 삭제하시겠습니까?"); //chk가 boolean타입으로 선택가능
  		if(chk){ //chk가 true면 if문으로 들어옴
  		$.ajax({
  			type : 'POST',       // Post방식
  			url : sendUrl,          // 전송 URL
  			traditional : true,		// ajax 배열 넘기기 옵션
  			data : {
  				valueArr : valueArr   // 보내고자 하는 data 변수 설정
  			},
  			success: function (rdata) {
  				if(rdata == 1) {
  				 console.log(rdata);
  				 location.href="user";
  				}else {
  					alert("삭제 실패");
  				}

  			},
  			error:function(){

  				alert("에러");
  			}
  		});
  		} else {
  			location.href="user";
  		}

  	}
  }


  // 삭제 코드 끝



  </script>
  </head>
<!--   <script src="http://code.jquery.com/jquery-3.6.0.js"></script> -->
<%--   <script src="${pageContext.request.contextPath }/resources/jsPro/deleteUser.js"></script> --%>
  <body>
  <!-- 메뉴단 -->
<jsp:include page="../inc/menu.jsp"/>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
		<jsp:include page="../inc/admin-menu.jsp"/>

          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->
            <div class="container-xxl flex-grow-1 container-p-y">
              <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">업체 /</span> 상품 관리</h4>

              <div class="row">
                <div class="col-md-12">
                  <ul class="nav nav-pills flex-column flex-md-row mb-3">
                    <li class="nav-item">
                      <a class="nav-link" href="${pageContext.request.contextPath }/admin/comp">
                      <i class="bx bx-buildings me-1"></i> 업체 관리</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link active" href="${pageContext.request.contextPath }/mypage/addr">
                      <i class="bx bx-buildings me-1"></i> 상품 관리</a>
                    </li>
                  </ul>

                 <div class="card">
                <h5 class="card-header">상품 관리</h5>
                <hr class="my-0" />
                <div class="card-body">
                <div class="table-responsive text-nowrap">
                  <table class="table table-striped">
                    <thead>
                      <tr>
                        <th>상품 번호</th>
                        <th>상품 코드</th>
                        <th>상품 이미지</th>
                        <th>상품명</th>
                        <th>가격</th>
                        <th>업체명</th>
                        <th>분류</th>
                        <th>등록일</th>
                      </tr>
                    </thead>
                    <tbody class="table-border-bottom-0">
                     <c:forEach var="prodDTO" items="${productList}" >
                      <tr>
                        <td style="vertical-align: middle">${prodDTO.prodLNum}</td>
                        <td style="vertical-align: middle">${prodDTO.prodLCode}</td>
                        <td><img src="${pageContext.request.contextPath }/resources/img/product/${prodDTO.prodLMainimg}" width="150"/></td>
                        <td style="vertical-align: middle">${prodDTO.prodLProdnm}</td>
                        <td style="vertical-align: middle">${prodDTO.prodLPrice}</td>
                        <td style="vertical-align: middle"><span class="badge bg-secondary">${prodDTO.compNm}</span></td>
                        <td style="vertical-align: middle">
                        <c:set var="op" value="${prodDTO.prodLOption1}" />
                         <c:choose>
                      		<c:when test="${op eq 'FOOD'}">
                               <span class="badge bg-label-warning">음식</span>
                      		</c:when>
                      		<c:when test="${op eq 'PROD'}">
                        		<span class="badge bg-label-info">용품</span>
                      		</c:when>
                         </c:choose>
                         </td>
                        <td style="vertical-align: middle"><fmt:formatDate pattern="yy-MM-dd" value="${prodDTO.prodLUploaddate}"/></td>
                      </tr>
					 </c:forEach>
                    </tbody>
                  </table>

				<!-- 페이지 -->
                  <div class="bd-example-snippet bd-code-snippet mt-5 mb-3"><div class="bd-example " >
			        <nav aria-label="Standard pagination example">
			          <ul class="pagination" style="margin-left: 45%; margin-rightt: 55%;">
			            <li class="page-item">
                            <c:if test="${pageDTO.startPage > pageDTO.pageBlock }">
								<a class="page-link" href="${pageContext.request.contextPath }/admin/product?pageNum=${pageDTO.startPage - pageDTO.pageBlock}" aria-label="Previous">
								<span aria-hidden="true">&laquo;</span>
							</a>
							</c:if>
						 </li>
							<c:forEach var="i" begin="${pageDTO.startPage }" end="${pageDTO.endPage }" step="1">
						 <li class="page-item">
						 		<a class="page-link" href="${pageContext.request.contextPath }/admin/product?pageNum=${i}">${i}</a>
						 </li>
							</c:forEach>

						 <li class="page-item">
							<c:if test="${pageDTO.endPage < pageDTO.pageCount }">
								<a class="page-link" href="${pageContext.request.contextPath }/admin/product?pageNum=${pageDTO.startPage + pageDTO.pageBlock}" aria-label="Next">
									<span aria-hidden="true">&raquo;</span>
								</a>
							</c:if>
			            </li>
			          </ul>
			        </nav>
			        </div></div>

                </div>
                </div>
              </div>
                </div>
              </div>
            </div>
            <!--/ Content -->

            <!-- Footer -->
            <footer class="content-footer footer bg-footer-theme">
              <div class="container-xxl d-flex flex-wrap justify-content-between py-2 flex-md-row flex-column">
                <div class="mb-2 mb-md-0">
                </div>
                <div>
                </div>
              </div>
            </footer>
            <!-- / Footer -->

            <div class="content-backdrop fade"></div>
          </div>
         <!-- 화면 줄였을때 Content wrapper -->
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

    <!-- Main JS -->
    <script src="${pageContext.request.contextPath }/resources/assets/js/main.js"></script>

    <!-- Page JS -->

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>

    <!-- Footer Section Begin -->
    <jsp:include page="../inc/footer.jsp"/>
</body>

</html>