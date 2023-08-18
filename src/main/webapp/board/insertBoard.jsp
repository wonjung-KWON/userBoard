<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <style type="text/css">
		.glanlink {color: #000000;}
	</style>
	<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>insertBoard.jsp</title>
        <link href="./Resources/dist/style.min.css" rel="stylesheet" />
        <link href="./Resources/css/styles.css" rel="stylesheet" />
        <script src="./Resources/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="<%=request.getContextPath()%>/home.jsp">	USERBOARD HOME</a>
            <!-- Sidebar Toggle-->
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#!">Settings</a></li>
                        <li><a class="dropdown-item" href="#!">Activity Log</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="#!">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
					<!-- 메인메뉴 (가로) -->
					<div>
						<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
						 
					</div>
                        </div>
                    </div>
                    <div class="sb-sidenav-footer">
                        <div class="small">Logged in as: 
                        <%
                        	if(memberId != null){
                        %>
                       		 <%=memberId%>
                        <%
                        	}else{
                        %>
                        	&nbsp;
                        <%
                        	}
                        %>
                        </div>
                        User Board Home
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-4">
                       <br>
                       <div class="row">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">MemberShip Card</div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                     <%
									 	if(session.getAttribute("loginMemberId") != null){
									 %>
                                       <a href="<%=request.getContextPath()%>/member/userInformation.jsp"  class="small text-white stretched-link">회원정보</a>
                                     <% 		
									 	}
									 %>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-warning text-white mb-4">
                                    <div class="card-body">Log-out Card</div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
	                                     <%
										 	if(session.getAttribute("loginMemberId") != null){
										 %>
	                                      <a href="<%=request.getContextPath()%>/member/logoutAction.jsp"  class="small text-white stretched-link">로그아웃</a>
	                                     <% 						
										 	}
										 %>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">Regional List Card</div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                         <%
										 	if(session.getAttribute("loginMemberId") != null){
										 %>
	                                     <a href="<%=request.getContextPath()%>/local/localList.jsp" class="small text-white stretched-link">지역 리스트</a>
	                                     <% 						
										 	}
										 %>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-danger text-white mb-4">
                                    <div class="card-body">Add Posts Card</div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                         <%
										 	if(session.getAttribute("loginMemberId") != null){
										 %>
	                                    <a href="<%=request.getContextPath()%>/board/insertBoard.jsp" class="small text-white stretched-link">게시글 추가</a>
	                                     <% 						
										 	}
										 %>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </div>
                       
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                추가할 지역정보
                            </div>
                            <div class="card-body">
                     <form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="get" >
						<table class="table">
							<%
					        	if(request.getParameter("msg") != null){
					        %>
								<tr>
							       	 <td>
							        	<div><%=request.getParameter("msg") %></div>
							        </td>
					       		</tr>
			       			<% 
					        	}
					        %>
				       		<tr>
							<tr>
								<td>카테고리</td>
								<td>
									<input type="text" name="localName">
								</td>
							</tr>
							<tr>
								<td>타이틀</td>
								<td>
									<input type="text" name="boardTitle">
								</td>
							</tr>
							<tr>
								<td>내용</td>
								<td>
									<textarea rows="2" cols="80" name="boardContent"></textarea>
								</td>
							</tr>
							<tr>
								<td>아이디</td>
								<td>
									<input type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
								</td>
							</tr>
						</table>
						<button type="submit" class="btn btn-dark">추가하기</button>
					</form>
                        </div>
                    </div>
                </main>
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                           <div>
								<!--  intclude 페이지 Copyright &copy; 구디아카데미 -->
								<jsp:include page="/inc/copyright.jsp"></jsp:include>
							</div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="./Resources/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="./Resources/js/scripts.js"></script>
        <script src="./Resources/Chart.min.js" crossorigin="anonymous"></script>
        <script src="./Resources/assets/demo/chart-area-demo.js"></script>
        <script src="./Resources/assets/demo/chart-bar-demo.js"></script>
        <script src="./Resources/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="./Resources/js/datatables-simple-demo.js"></script>
    </body>
</html>