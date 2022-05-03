<%@page import="java.text.DecimalFormat"%>
<%@page import="common.Grades"%>
<%@page import="data.dto.member.TradingInfoDto"%>
<%@page import="data.dto.member.MemberProfileDto"%>
<%@page import="data.dao.member.TradingInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="data.dto.service.ServiceDto"%>
<%@page import="data.dto.service.ServiceImageDto"%>
<%@page import="data.dao.service.ServiceImageDao"%>
<%@page import="data.dao.member.MemberDao"%>
<%@page import="data.dto.service.ServiceInqueryDto"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.service.ServiceDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- google Material Icons -->
<link rel="stylesheet"
	href="https://fonts.sandbox.google.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />

<link rel="stylesheet" type="text/css" href="css/styles.css" />
<link rel="stylesheet" type="text/css"
	href="css/screens/transaction.css" />
<%
Long serviceId = Long.parseLong(request.getParameter("serviceId"));

ServiceDao serviceDao = new ServiceDao();

//서비스 이미지
ServiceImageDao serviceImgDao = new ServiceImageDao();

ServiceInqueryDto service = serviceDao.findByServiceId(serviceId);
List<ServiceImageDto> images = serviceImgDao.findAllByServiceId(serviceId);

//페이징처리에 필요한 변수
int totalCount; //총글수
int totalPage; //총 페이지수
int startPage; //각블럭의 시작페이지
int endPage; //각블럭의 끝페이지
int start; //각페이지의 시작번호
int perPage = 3; //한페이지에 보여질 글 갯수
int perBlock = 5; //한블럭당 보여지는 페이지 개수
int currentPage; //현재페이지 번호

//총갯수
totalCount = serviceDao.getTotalCount();

//현재 페이지번호 읽기(단 null일경우는 1페이지로 설정)
if (request.getParameter("currentPage") == null)
	currentPage = 1;
else
	currentPage = Integer.parseInt(request.getParameter("currentPage"));

//총페이지 개수구하기
totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);

//각블럭의 시작페이지
//예:현재페이지가 3인경우 startpage=1,endpage= 5
//현재페이지가 6인경우 startpage=6,endpage= 10
startPage = (currentPage - 1) / perBlock * perBlock + 1;
endPage = startPage + perBlock - 1;

//만약 총페이지가 8 -2번째블럭: 6-10 ..이럴경우는 endpage가 8로 수정되어야함
if (endPage > totalPage)
	endPage = totalPage;

//각페이지에서 불러올 시작번호
start = (currentPage - 1) * perPage;

//각페이지에서 필요한 게시글 가져오기
List<ServiceInqueryDto> services = serviceDao.findALL(start, perPage);

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
DecimalFormat decimalFormat = new DecimalFormat("###,###");
%>
</head>
<body>
	<header id="header-bar" class="header-bar-box">


		<div class="header-bar-box__wrap">
			<div class="header-logo-box">
				<a href="#" class="header-logo-box__link">
					<div class="logo-box">
						<img src="img/logo.svg" alt="타임마켓" class="header-logo">
						<p class="logo">짭투리</p>
					</div>
				</a>
			</div>


			<section class="header-search">
				<div class="search">
					<input type="text" id="header-search-input" class="search__input"
						placeholder="서비스명, 지역명 입력">
					<button class="search__button">
						<a href="#"> <img src="img/icon-search.svg" alt="search"
							class="search__icon" width="20">
						</a>
					</button>
				</div>
			</section>


			<div class="menu-bar-info-box">
				<div class="menu-bar">
					<a href="#menu" id="toggle"> <span>
							<div class="test"></div>
					</span></a>
					<div id="menu">
						<ul>
							<li><a href="#">청소</a></li>
							<li><a href="#">심부름</a></li>
							<li><a href="#">산책</a></li>
							<li><a href="#">설치</a></li>
							<li><a href="#">과외</a></li>
						</ul>
					</div>
				</div>


				<div class="info-box">
					<a href="#" class="info-box__link"> <img
						src="img/icon-mypage.svg" alt="" class="info-box__img">
					</a>
				</div>
			</div>
		</div>
	</header>


	<section id="transaction-list">
		<div class="transaction-list__wrap">

			<h2 class="transaction-list__title">거래내역</h2>


			<div class="transaction__wrap">
				<div class="transaction-item__wrap">
					<%for (ServiceInqueryDto serviceIn : services) %>
					<div class="transaction-item">
						<a href="#" class="transaction-item__inner">

							<div class="transaction-text__img">
								<div class="transaction-item__img">
									<span class="medal--status"> <img
										src="img/medal-gold.svg" alt="메달이미지" class="medal__img">
									</span>
									<%
									for (ServiceImageDto image : images) {
									%>
									<img class="transaction-list__img"
										src="img/<%=image.getStoreImageName()%>" alt="이미지" />
									<%
									}
									%>
								</div>
								<div class="transaction-item-text__wrap">
									<div class="transaction-item__title">
										<%=service.getTitle()%></div>
									<div class="transaction-item__place"><%=service.getPlace()%></div>
									<div class="transaction-item-date__wrap">
										<div class="transaction-item-date__icon">
											<span class="material-symbols-rounded"> calendar_today
											</span>
										</div>
										<div class="date__wrap">
											<span><%=sdf.format(service.getStartDate())%> ~ <%=sdf.format(service.getEndDate())%></span>
										</div>
									</div>
									<div class="transaction-item__price"><%=decimalFormat.format(service.getPrice())%></div>
									<div class="transaction-item__description">
										<span class="description__text"> <%=service.getDescription()%>
										</span>
									</div>

									<div class="box__item-btn">
										<button type="submit" class="btn__update">수정</button>
										<button type="submit" class="btn__delete">삭제</button>
									</div>
								</div>

							</div>

							<div class="box__information-reservation">
								<button type="submit" class="btn__sale">판매중</button>
								<button type="submit" class="btn__reserved">예약중</button>
								<button type="submit" class="btn__completed">거래완료</button>
								<button type="submit" class="btn__star">리뷰</button>

							</div>
						</a>
					</div>

					<div class="transaction-item">
						<a href="#" class="transaction-item__inner">

							<div class="transaction-text__img">
								<div class="transaction-item__img">
									<span class="medal--status"> <img
										src="img/medal_silver.png" alt="메달이미지" class="medal__img">
									</span>
									<%
									for (ServiceImageDto image : images) {
									%>
									<img class="transaction-list__img"
										src="img/<%=image.getStoreImageName()%>" alt="이미지">
									<%
									}
									%>
								</div>
								<div class="transaction-item-text__wrap">
									<div class="transaction-item__title">
										<%=service.getTitle()%></div>
									<div class="transaction-item__place"><%=service.getPlace()%></div>
									<div class="transaction-item-date__wrap">
										<div class="transaction-item-date__icon">
											<span class="material-symbols-rounded"> calendar_today
											</span>
										</div>
										<div class="date__wrap">
											<span><%=sdf.format(service.getStartDate())%> ~ <%=sdf.format(service.getEndDate())%></span>
										</div>
									</div>
									<div class="transaction-item__price"><%=decimalFormat.format(service.getPrice())%></div>
									<div class="transaction-item__description">
										<span class="description__text"> <%=service.getDescription()%>
										</span>
									</div>


								</div>

							</div>

							<div class="box__information-reservation">
								<button type="submit" class="btn__cancle">예약취소</button>
							</div>
						</a>
					</div>

					<div class="transaction-item">
						<a href="#" class="transaction-item__inner">

							<div class="transaction-text__img">
								<div class="transaction-item__img">
									<span class="medal--status"> <img
										src="img/medal-gold.svg" alt="메달이미지" class="medal__img">
									</span>
									<%
									for (ServiceImageDto image : images) {
									%>
									<img class="transaction-list__img"
										src="img/<%=image.getStoreImageName()%>" alt="이미지">
									<%
									}
									%>
								</div>
								<div class="transaction-item-text__wrap">
									<div class="transaction-item__title">
										<%=service.getTitle()%></div>
									<div class="transaction-item__place"><%=service.getPlace()%></div>
									<div class="transaction-item-date__wrap">
										<div class="transaction-item-date__icon">
											<span class="material-symbols-rounded"> calendar_today
											</span>
										</div>
										<div class="date__wrap">
											<span><%=sdf.format(service.getStartDate())%> ~ <%=sdf.format(service.getEndDate())%></span>
										</div>
									</div>
									<div class="transaction-item__price"><%=decimalFormat.format(service.getPrice())%></div>
									<div class="transaction-item__description">
										<span class="description__text"> <%=service.getDescription()%>
										</span>
									</div>

									<div class="box__item-btn">
										<button type="submit" class="btn__update">수정</button>
										<button type="submit" class="btn__delete">삭제</button>
									</div>
								</div>

							</div>

							<div class="box__information-reservation">
								<button type="submit" class="btn__sale">판매중</button>
								<button type="submit" class="btn__reserved">예약중</button>
								<button type="submit" class="btn__completed">거래완료</button>
								<button type="submit" class="btn__star">리뷰</button>

							</div>
						</a>
					</div>

					<div class="transaction-item">
						<a href="#" class="transaction-item__inner">

							<div class="transaction-text__img">
								<div class="transaction-item__img">
									<span class="medal--status"> <img
										src="img/medal-platinum.svg" alt="메달이미지" class="medal__img">
									</span>
									<%
									for (ServiceImageDto image : images) {
									%>
									<img class="transaction-list__img"
										src="img/<%=image.getStoreImageName()%>" alt="이미지">

									<%
									}
									%>
								</div>
								<div class="transaction-item-text__wrap">
									<div class="transaction-item__title">
										<%=service.getTitle()%></div>
									<div class="transaction-item__place"><%=service.getPlace()%></div>
									<div class="transaction-item-date__wrap">
										<div class="transaction-item-date__icon">
											<span class="material-symbols-rounded"> calendar_today
											</span>
										</div>
										<div class="date__wrap">
											<span><%=sdf.format(service.getStartDate())%> ~ <%=sdf.format(service.getEndDate())%></span>
										</div>
									</div>
									<div class="transaction-item__price"><%=decimalFormat.format(service.getPrice())%></div>
									<div class="transaction-item__description">
										<span class="description__text"> <%=service.getDescription()%>
										</span>
									</div>


								</div>

							</div>

							<div class="box__information-reservation">
								<button type="submit" class="btn__completed">거래완료</button>
								<button type="submit" class="btn__star">리뷰</button>

							</div>
						</a>
					</div>






				</div>
			</div>

			<!-- pagenation -->
			<div class="pagenation__wrap">
				<div class="pagenation__inner">
					<a href="#" class="pagenation__item pagenation--previous"> <span
						class="material-symbols-rounded"> arrow_back_ios_new </span>
					</a> <a href="#" class="pagenation__item pagenation-number">1</a> <a
						href="#" class="pagenation__item pagenation-number">2</a> <a
						href="#" class="pagenation__item pagenation-number current">3</a>
					<a href="#" class="pagenation__item pagenation-number">4</a> <a
						href="#" class="pagenation__item pagenation-number">5</a> <a
						href="#" class="pagenation__item pagenation--next"> <span
						class="material-symbols-rounded"> arrow_forward_ios </span>
					</a>
					<%
					//이전 
					if (startPage > 1) {
					%>
					<li><a
						href="index.jsp?main=tempusproject/transaction.jsp?currentPage=<%=startPage + 1%>">이전</a>
					</li>
					<%
					}

					for (int pp = startPage; pp <= endPage; pp++) {
					if (pp == currentPage) {
					%>
					<li class="active"><a
						href="index.jsp?main=tempusproject/transaction.jsp?currentPage=<%=pp%>"><%=pp%></a>
					</li>
					<%
					} else {
					%>
					<li><a
						href="index.jsp?main=tempusproject/transaction.jsp?currentPage=<%=pp%>"><%=pp%></a>
					</li>
					<%
					}
					}

					//다음
					if (endPage < totalPage) {
					%>
					<li><a
						href="index.jsp?main=tempusproject/transaction.jsp?currentPage=<%=endPage + 1%>">다음</a>
					</li>
					<%
					}
					%>
				</div>

			</div>
		</div>

		<!-- service-navigation -->
		<div class="service--navigation">
			<div class="menu-bar">
				<a href="#item-menu" id="navigation"> <span>
						<div class="menu-area"></div>
				</span>
				</a>
				<div id="menu_wrap">
					<ul>
						<li><a href="#">서비스 등록</a></li>
						<li><a href="#">마이페이지</a></li>
						<li><a href="#">거래내역</a></li>

					</ul>
				</div>
			</div>
		</div>
	</section>







	<footer class="p-footer p-footer--dark">
		<div class="p-footer__inner">
			<div class="p-footer__site-group-list">
				<ul class="p-footer__site-group">
					<li><div class="p-footer__site-group-title">4조 세미프로젝트</div></li>
					<li class="p-footer__site-group-item"><a href="#">홍길동:aaa@gmail.com</a></li>

					<li class="p-footer__site-group-item"><a href="#">홍길동:aaa@gmail.com</a></li>

					<li class="p-footer__site-group-item"><a href="#">홍길동:aaa@gmail.com</a></li>

					<li class="p-footer__site-group-item"><a href="#">홍길동:aaa@gmail.com</a></li>

					<br>
					<li class="p-footer__site-group-item"><b>@2022 Article 4
							Semi-Project.All rights reserved.</b></li>

				</ul>

				<ul class="p-footer__site-group">
					<li><div class="p-footer__site-group-title">SKILLS</div></li>
					<li class="p-footer__site-group-item"><a href="#">JAVA,HTML,CSS,Javascript,Git,Bla</a></li>
				</ul>

				<ul class="p-footer__site-group">
					<li><div class="p-footer__site-group-title">GITHUB</div></li>
					<li class="p-footer__site-group-item"><a href="#">깃허브 어쩌구
							저쩌구 샬라샬라</a></li>

				</ul>
				<ul class="p-footer__site-group">
					<li><div class="p-footer__site-group-title">고객센터</div></li>
					<li class="p-footer__site-group-item"><a href="#">시간마켓
							고객센터</a></li>

				</ul>
			</div>
		</div>
	</footer>


	<script src="js/default.js"></script>
	<script src="js/serviceNavigation.js"></script>
</body>
</html>