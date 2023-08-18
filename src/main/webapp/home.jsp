<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%			//1.요청분석(컨크롤러 계층)
			//1) session JSP내장(기본)객체
			//2) request /response JSP내장(기본)객체
			int currentPage = 1;
				if(request.getParameter("currentPage")!= null){
					currentPage = Integer.parseInt(request.getParameter("currentPage"));
				}
			int rowPerPage = 10;
			int startRow = (currentPage -1)*rowPerPage;
			int totalRow = 0;
			//파라값 디버깅
			System.out.println(request.getParameter("localName")+"<-- home.jsp parm localName");
			String memberId = (String)session.getAttribute("loginMemberId");
			// 파라값 유효성 검사
			String localName = "전체";
			if(request.getParameter("localName") != null){
				localName = request.getParameter("localName");
			}
			// 디버깅
			System.out.println(localName+"<-- home.jsp localName");
//***************************************************************************************************************************************************************************			
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
			/*
				SELECT  '전체'localName, COUNT(local_name) cnt FROM board
				  UNION ALL 
				   SELECT local_name localName, COUNT(*) cnt FROM board
				 GROUP BY local_name;
			*/
			String subMenuSql = "SELECT  '전체' localName, COUNT(local_name) cnt FROM board  UNION ALL SELECT local_name localName, COUNT(*) cnt FROM board GROUP BY local_name";
			PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
			ResultSet subMenuRs = subMenuStmt.executeQuery();
			
			//subMenuList <-- 모델 데이터
			ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
			while(subMenuRs. next()){
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("localName", subMenuRs.getString("localName"));
				m.put("cnt", subMenuRs.getInt("cnt"));
				subMenuList.add(m);
			}
			/*
			 SELECT * FROM board WHERE local_name ='인천' order by local_name desc LIMIT 0, 10;
			*/
			// 2) 게시판 목록 결과셋(모델)
			ResultSet listRs = null;
			String listSql = "";
			PreparedStatement listStmt = null;
			if(request.getParameter("localName") == null
				|| request.getParameter("localName").equals("")
				|| request.getParameter("localName").equals("전체")){
				listSql = " SELECT local_name localName, board_title boardTitle, board_no boardNo, createdate FROM board order by createdate desc LIMIT ?, ?;";
				listStmt= conn.prepareStatement(listSql);
				listStmt.setInt(1,startRow);
				listStmt.setInt(2,rowPerPage);
				System.out.println(listStmt+"<-- home.jsp listStmt 확인 전체보여주기 쿼리");
		
			} else {
			listSql = "SELECT local_name localName, board_title boardTitle, board_no boardNo, createdate FROM board WHERE local_name =? order by createdate desc LIMIT ?, ?";
			listStmt= conn.prepareStatement(listSql); 
			
			listStmt.setString(1, localName);
			listStmt.setInt(2, startRow);
			listStmt.setInt(3, rowPerPage);
			System.out.println(listStmt+"<-- home.jsp listStmt 확인 localName에 맞춤보여주기 쿼리");
			}
		
			listRs = listStmt.executeQuery();
			System.out.println(listRs+"<-- home.jsp listRs");
			ArrayList<Board> boardList = new ArrayList<Board>();
			// listRs --> boardList
			while(listRs.next()){
				Board b = new Board();
				b.setLocalName(listRs.getString("localName"));
				b.setBoardTitle(listRs.getString("boardTitle"));
				b.setBoardNo(listRs.getInt("boardNo"));
				b.setCreatedate(listRs.getString("createdate"));
				boardList.add(b);
			}
			System.out.println(boardList + "<--home listRs");
//***************************************************************************************************************************************************************************			
			// 페이징 설정하기 
				// stmt, rs 변수선언
				PreparedStatement totalStmt = null;
				ResultSet totalRs = null;
				//페이지의 전체 행구하는 쿼리	
				String totalRowSql = null;
				if(localName.equals("전체")){
					totalRowSql = "select count(*) from board";
					totalStmt = conn.prepareStatement(totalRowSql);
				} else{
					totalRowSql = "select count(*) from board where local_name=?";
					totalStmt = conn.prepareStatement(totalRowSql);
					totalStmt.setString(1, localName);
					
				}
				totalRs = totalStmt.executeQuery();
				//디버깅체크
				System.out.println(totalStmt+"<-- totalStmt");
				System.out.println(totalRs+"<-- totalRs");
				
				// 전체 페이지 수 구하기
				if(totalRs.next()){
					totalRow=totalRs.getInt("count(*)");
				}
				int lastPage = totalRow/rowPerPage;
				//마지막 페이지가 나머지가 0이 아니면 페이지수 1더하기
				if(totalRow%rowPerPage != 0){
					lastPage++;
				}
				
				System.out.println(boardList + "<--home listRs");
				
				//페이지 넘기는 변수
				String pageAdd = "";
				if(!localName.equals("")){
					pageAdd += "&localName=" + localName;
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
        <title>home.jsp</title>
        <link href="./Resources/dist/style.min.css" rel="stylesheet" />
        <link href="./Resources/css/styles.css" rel="stylesheet" />
        <script src="./Resources/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
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
						<div>
							<ul>
							
							<%
								for(HashMap<String, Object> m : subMenuList){
							%>
							<li>
									<a  href= "<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>" class="btn btn-dark">
										<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a><br><br>
								</li>
								
							<%
								}
							%>
							
						</ul>
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
                        UserBoard HOME
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
											<td>ID 로그인</td>
										</tr>
										<tr>
											<td>아이디</td>
											<td><input type="text" name="memberId" placeholder="username" value="user1"></td>
										</tr>
										<tr>
											<td>비밀번호</td>
											<td><input type="password" name="memberPw" placeholder="PASSWORD" value="1234"></td>
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
                                리스트
                            </div>
                            <div class="card-body">
                                
								<!-- 모델값에 맞는 리스트 출력 -->
								<div>
									<table  class="table">
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
												<td>boardNo</td>
												<th>localName</th>
												<th>boardTitle</th>
											</tr>
											<%
												for(Board b : boardList){
											%>
												<tr>
													<td><%=b.getBoardNo() %></td>
													<td><%=b.getLocalName()%></td>
													<td>
														<a class="glanlink"  href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
															<%=b.getBoardTitle()%>
														</a>
													</td>
													<td><%=b.getCreatedate()%></td>
												</tr>
											<%
												}
											%>
									</table>
									<div class="textcenter" style="text-align: center;">
									<%
										// 
										int pageCount = 10;//페이지당 출력될 페이지 갯수
										// startPage가 currentPage가 1~10이면 1로 고정 11~20이면 2로 고정되게 소수점을 이용하여 고정값 만드는 알고리즘
										int startPage = ((currentPage -1)/pageCount)*pageCount+1;
										// startPage에서 9를 더한값이 마지막 출력될 Page이지만 lastPage보다 커지면 endPage는 lastpage로변환
										int endPage = startPage+9;
										if(endPage > lastPage){
											endPage = lastPage;
										}
										System.out.println(startPage+"<-- startPage");
										System.out.println(endPage+"<-- endPage");
										if(startPage > 10){
									%>
											<a class="btn btn-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-1%>&pageAdd=<%=pageAdd%>">이전</a>
									<% 
										}
										for(int i = startPage; i<=endPage; i++){
									%>
											<a class="btn btn-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&pageAdd=<%=pageAdd%>"><%=i%></a>
									<% 		
										}
										if(endPage<lastPage){
									%>
											<a class="btn btn-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1%>&pageAdd=<%=pageAdd%>">다음</a>
									<%
										}
									%>
										
	
									</div>
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
