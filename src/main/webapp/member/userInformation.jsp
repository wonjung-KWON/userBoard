<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	//1. 요청분석(컨트롤러 계층)*************************************
	//1-1) request /respnse JSP(기본)객체 *****************************
	//세션 확인 로그인 안되어있으면 못들어오게	
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 가져오는 값 유효성 확인
	String memberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(memberId);
	//디비에서 모델가져오기 
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
	String sql = "select member_id memberId, member_pw memberPw, createdate, updatedate from member where member_id = ?";
	 stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	rs = stmt.executeQuery();
	System.out.println(stmt +"<-- updateForm stmt");
	System.out.println(rs+"<--rs");
	ArrayList<Member> memberList = new ArrayList<Member>();
	while(rs.next()){
		Member m = new Member();
		m.setMemberId(rs.getString("memberId"));
		m.setMemberPw(rs.getString("memberPw"));
		m.setCreatedate(rs.getString("createdate"));
		m.setUpdatedate(rs.getString("updatedate"));
		memberList.add(m);
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
        <title>userInformation.jsp</title>
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
                        
                       
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                직원 리스트
                            </div>
                            <div class="card-body">
                                
								<!--  board one 결과셋 **********************************************************************-->
							<div>
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
							        <%
							         for(Member m : memberList){
							        %>
							        <tr>
								        <td>아이디 : <%=m.getMemberId()%></td>
							        </tr>
							        <tr>
							        	<td>만든 날짜 : <%=m.getCreatedate()%></td>
							        </tr>
							        <tr>
							        	<td>수정 날짜 : <%=m.getUpdatedate()%></td>
							        </tr>
							        <%
							         }
							        %>
							     	<tr>
								     	<td>
								        	<a href="updatePasswordForm.jsp" class="btn btn-dark">비밀번호 수정하기</a>
								        </td>
							        </tr>
							        <tr>
							        	<td>
							        		<a href="deleteUserForm.jsp" class="btn btn-dark">탈퇴</a>
							        	</td>
							        </tr>
						        </table>
							</div>
                            </div>
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
