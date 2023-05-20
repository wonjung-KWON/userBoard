<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%	
	
	//1.요청분석(컨크롤러 계층)-----------------------------------------------------------------//
	//2) request /response JSP내장(기본)객체----------------------------------------------------------------//
	
	if(request.getParameter("boardNo") == null 
	|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	System.out.println(boardNo+"<-- pars BoarNo");
	//세션정보 변수에저장
	String memberId = (String)session.getAttribute("loginMemberId");
	// page 변수
	int currentPage = 1;
		if(request.getParameter("currentPage")!= null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
	int rowPerPage = 5;
	int startRow = (currentPage -1)*rowPerPage;
	int totalRow = 0;
	//DB에서 모델값 받기 ----------------------------------------------------------------//
			String driver="org.mariadb.jdbc.Driver";
			String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
			String dbId = "root"; 
			String dbPw = "java1234";
			Class.forName(driver);
			Connection conn = null;
			
			// 1)서브메뉴 결과셋(모델)
			// stmt, rs 변수선언
			PreparedStatement boardStmt = null;
			PreparedStatement commentListStmt = null;
			PreparedStatement totalStmt = null;
			ResultSet boardRs = null;
			ResultSet commentListRs = null;
			ResultSet totalRs = null;
			
			conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
			//디비연결 디버깅
			System.out.println("디비연결확인");
			/*
			 SELECT * FROM board WHERE board_no = 1; 
			*/
			String sql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate  FROM board WHERE board_no = ?";
			System.out.println(sql+ "<-- boardOne sql");
			
			boardStmt = conn.prepareStatement(sql);
			
			boardStmt.setInt(1,boardNo);
			System.out.println(boardStmt+ "<-- boardOne boardStmt");
			
			boardRs = boardStmt.executeQuery(); // row -> 1 ->Board타입
			
			Board board = null;
			if(boardRs.next()){
				board = new Board();
			
				board.setBoardNo(boardRs.getInt("boardNo"));
				board.setLocalName(boardRs.getString("localName"));
				board.setBoardTitle(boardRs.getString("boardTitle"));
				board.setBoardContent(boardRs.getString("boardContent"));
				board.setMemberId(boardRs.getString("memberId"));
				board.setCreatedate(boardRs.getString("createdate"));
				board.setUpdatedate(boardRs.getString("updatedate"));
				
			}
			System.out.println(boardRs + "<-- boardOne boardRs");
		
			
			// comment List 결과셋 *******************************************************************************/
			
			/*
			SELECT comment_no, board_no, comment_content
				FROM COMMENT
				WHERE board_no = 1000
				LIMIT 0, 10;
			*/
		
			
			String commentSql = null;
			commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM COMMENT WHERE board_no = ? order by createdate DESC LIMIT ?, ?";
			commentListStmt = conn.prepareStatement(commentSql);
			commentListStmt.setInt(1, boardNo);
			commentListStmt.setInt(2, startRow);
			commentListStmt.setInt(3, rowPerPage);
			commentListRs = commentListStmt.executeQuery();// row - > 최대 10 -> ArrayList<Comment>
			
			// 페이지의 전체 행구하는 쿼리
			String totalRowSql =null;
			totalRowSql= "select count(*) from comment where board_no=?";
			totalStmt = conn.prepareStatement(totalRowSql);
			totalStmt.setInt(1, boardNo);
			totalRs = totalStmt.executeQuery();
			//디버깅체크
			System.out.println(totalStmt+"<-- totalStmt");
			System.out.println(totalRs+"<-- totalRs");
			
			//전체 페이지 수 구하기
			if(totalRs.next()){
				totalRow=totalRs.getInt("count(*)");
			}
			int lastPage = totalRow/rowPerPage;
			//마지막 페이지가 나머지가 0이 아니면 페이지수 1더하기
			if(totalRow%rowPerPage != 0){
				lastPage++;
			}
			
			//댓글내용 배열 저장하기 위한 배열
			ArrayList<Comment> commentList = new ArrayList<Comment>();
			while(commentListRs.next()){
				Comment c = new Comment();
				c.setCommentNo(commentListRs.getInt("commentNo"));
				c.setBoardNo(commentListRs.getInt("boardNo"));
				c.setMemberId(commentListRs.getString("memberId"));
				c.setCommentContent(commentListRs.getString("commentContent"));
				c.setCreatedate(commentListRs.getString("createdate"));
				c.setUpdatedate(commentListRs.getString("updatedate"));
				
				commentList.add(c);
			}
			
			// 페이지 넘기는 벼눗
			String pageAdd = "";
			if(boardNo>0){
				pageAdd += "&boardNo=" + boardNo;
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
        <title>Dashboard - SB Admin</title>
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
                        <div>
							<!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->
							<!-- 로그인 폼 -->
							<%
								if(session.getAttribute("loginMemberId") == null){// 로그인전이라면 로그인폼출력
							%>
								<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
									<table class="table table-bordered">
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
											<td>ID 로그인</td>
										</tr>
										<tr>
											<td>아이디</td>
											<td><input type="text" name="memberId"></td>
										</tr>
										<tr>
											<td>비민번호</td>
											<td><input type="password" name="memberPw"></td>
										</tr>
									</table>
									<button type="submit" class="btn btn-dark">로그인</button>
								</form>
							<% 		
								}
							%>
						<br>
						</div>
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
                                지역정보
                            </div>
                            <div class="card-body">
                                
								<!--  board one 결과셋 **********************************************************************-->
							<div>
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
										<td>게시글넘버</td>
										<td><%=board.getBoardNo() %></td>
									</tr>
									<tr>
										<td>카테고리</td>
										<td><%=board.getLocalName() %></td>
									</tr>
									<tr>
										<td>타이틀</td>
										<td><%=board.getBoardTitle() %></td>
									</tr>
									<tr>
										<td>내용</td>
										<td><%=board.getBoardContent() %></td>
									</tr>
									<tr>
										<td>아이디</td>
										<td><%=board.getMemberId() %></td>
									</tr>
									<tr>
										<td>작성일</td>
										<td><%=board.getCreatedate() %></td>
									</tr>
									<tr>
										<td>수정일</td>
										<td><%=board.getUpdatedate() %></td>
									</tr>
								
								</table>
								<div>
								<%
								if(session.getAttribute("loginMemberId").equals( board.getMemberId())){
								%>
									<a class="glanlink" href="<%=request.getContextPath()%>/board/modifyBoard.jsp?boardNo=<%=board.getBoardNo()%>">수정</a>
									<a class="glanlink" href="<%=request.getContextPath()%>/board/removeBoardAction.jsp?boardNo=<%=board.getBoardNo()%>">삭제</a>
								<%
								}
								%>
								</div>
							</div>
							<!-- comment 입력 : 세션유무에따른 분기 ********************************************************-->
							<%	
								// 로그인사용자만 댓글 허용****************************************************************
								if(session.getAttribute("loginMemberId") != null){
									// 현재로그인 사용자의 아이디 변수에저장
										String loginMemberId = (String)session.getAttribute("loginMemberId");
							%>
									<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
										<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
										<input type="hidden" name="memberId" value="<%=loginMemberId%>">
										
										<table>
											<tr>
												
												<th>댓글내용</th>
												<td>
													<textarea rows="2" cols="80" name="commentContent"></textarea>
												</td>
											</tr>
										</table>
										<button type="submit" class="btn btn-dark">댓글생성</button>
									</form>
							<% 
								}else{
							%>
									<textarea rows="2" cols="80"  readonly="readonly">댓글을 사용하려면 로그인해주세요</textarea>
							<% 		
								}
									
									
							%>
							<!-- comment list 결과셋  *****************************************************************-->
							<table class="table">
								<tr>
									<th>아이디</th>
									<th>댓글내용</th>
									<th>작성일</th>
									<th>수정일</th>
	
								</tr>
									<%
										for(Comment c: commentList){
									%>
											<tr>
												<td><%=c.getMemberId() %></td>
												<td><%=c.getCommentContent() %></td>
												<td><%=c.getCreatedate() %></td>
												<td><%=c.getUpdatedate() %></td>
												<%
													if(session.getAttribute("loginMemberId").equals( c.getMemberId())){
												%>
												<td>
													<a class="btn btn-dark" href="<%=request.getContextPath()%>/comment/modifyComment.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">
													수정
													</a>
												</td>
												<td>
													<a class="btn btn-dark" href="<%=request.getContextPath()%>/comment/removeCommentAction.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">
													삭제
													</a>
												</td>
												<%
													}
												%>
											</tr>
									<%
										}
									%>
							</table>
							<div>
							<%
								if(currentPage>1){
							%>
									<a class="glanlink" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>&pageAdd=<%=pageAdd%>">이전</a>
							<%		
								}
							%>
									<a class="glanlink" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&pageAdd=<%=pageAdd%>"><%=currentPage%></a> 
							<%
								if(currentPage<lastPage){
							%>
									 <a class="glanlink" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>&pageAdd=<%=pageAdd%>">다음</a> 
								
							<% 
								}
							%>
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