<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
String memberId = (String)session.getAttribute("loginMemberId");
//*****************************************************************************************************************************************************************
	//DB 연결
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	// 1)서브메뉴 결과셋(모델)
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	
	String sql = "select local_name localName, createdate, updatedate from local";
	stmt = conn.prepareStatement(sql);
//*****************************************************************************************************************************************************************
// ArrayList와 while 문을 활용하여 결과값을 반복적으로 메모리에 저장하다.	
	rs = stmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()){
		Local l = new Local();
		l.setLocalName(rs.getString("localName"));
		l.setCreatedate(rs.getString("createdate"));
		l.setUpdatedate(rs.getString("updatedate"));
		localList.add(l);
	}
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
        <title>localList.jsp</title>
        <link href="./Resources/dist/style.min.css" rel="stylesheet" />
        <link href="./Resources/css/styles.css" rel="stylesheet" />
        <script src="./Resources/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- 홈으로 가능 링크 -->
            <a class="navbar-brand ps-3" href="<%=request.getContextPath()%>/home.jsp">	USERBOARD HOME</a>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
						<%
						//	request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response); //이건자바코드 밑에꺼는 이거를 태그화 시킨거다.
						//이 코드를 액션을 번경하면 아래와 같다.
						%>
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
                        UserBoard Home
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
                                지역리스트
                            </div>
                            <div class="card-body">
                                
						<table class="table">
							<tr>
						        <td>
							        <%
							        	if(request.getParameter("msg") != null){
							        %>
							        	<div><%=request.getParameter("msg") %></div>
							        <% 
							        	}
							        %>
							     </td>
					    	</tr>
							<tr>
							<td>지역</td>
							<td>만든날짜</td>
							<td>업데이트 날짜</td>
						</tr>
						<%
							for(Local l : localList){
						%>
						<tr>
							<td><%=l.getLocalName()%></td>
							<td><%=l.getCreatedate()%></td>
							<td><%=l.getUpdatedate()%></td>
							<td><a class="btn btn-dark" href="<%=request.getContextPath()%>/local/updateLocalForm.jsp?localName=<%=l.getLocalName()%>">수정</a></td>
							<td><a class="btn btn-dark" href="<%=request.getContextPath()%>/local/deleteLocalForm.jsp?localName=<%=l.getLocalName()%>&createdate=<%=l.getCreatedate()%>&updatedate=<%=l.getUpdatedate()%>">삭제</a></td>
						</tr>
						<%
							}
						%>
					</table>
					<form action="insertLocalNameAction.jsp" method="get">
					<table class= "table">
						
						<tr>
							<td>지역 추가</td>
							<td>
							추가할 지역이름 :	<input type="text" name="localName">
							<button type="submit" class="btn btn-dark">추가하기</button>
							</td>
						</tr>
					</table>
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