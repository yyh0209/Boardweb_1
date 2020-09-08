<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.koreait.web.*" %>
<%!
    //@:세팅 
    //page import:다른 패키지를 사용하고싶으면
    //!:없으면 어떤 메소드에 속한다.
    //!:메소드에 속하지 않는 전역변수로 들어간다.
    //!:메소드를 만들고싶을때 써라.
    //jsp의 목적은 클라이언트에게 보여주기 위할목적으로 설계되었다.
    
    //connection 
    Connection getCon() throws Exception {
    	String url="jdbc:oracle:thin:@localhost:1521:orcl";
    	String username="hr";
    	String password="koreait2020";
    		
    	//이 메소드도 try catch로 넘겨진 상태라서 빨간줄뜸.
    	Connection con = DriverManager.getConnection(url, username, password);
    	Class.forName("oracle.jdbc.driver.OracleDriver");
    	//현재 throw된 상태에서 빨간줄이 뜬다. 해결하려면 try catch를 해야된다.
    	System.out.println("접속 성공");
    	return con; 
   	}
    %>
    
    <% 
    	//void가 아닌경우 return이라는 키워드가 무조건 있어야 한다.
    	//대문자로 시작한다=null을 줘야한다.
 
    //선언문을 따로 try 밖에서 선언하는 이유:예외처리때문이다 try에서도 사용하고 finally에도 사용하기 위해서.
    //중괄호에서 사용하는 순간 끝남. 선언 후부터는 계속 살아있다고 보면 된다.
    List<BoardVO> boardList = new ArrayList<BoardVO>();

	Connection con = null; //연결담당    		
	PreparedStatement ps=null; //쿼리문 실행담당,문장완성기능,
	//주로 상세페이지 완성,수정,기능 ex(printf();
	ResultSet rs=null; //select 문 일때만 쓴다. 잘됐는가 안됐는가. 결과담당.
    String sql=" SELECT i_board,title FROM t_board order by i_board DESC ";
    			//타이틀+ 프롬 가독성을 위해서 또는 퍼포먼스를 중요시한다.
    try{
    	//void형 getCon();만 있다.
    	con=getCon();//메소드 호출에 =이 있으면 100% 보이드가 아니다.
    	ps=con.prepareStatement(sql);//쿼리문 실행 sql문과 관련된건 
    	//con은 prepareStatement(sql)를 띄우기 위한 용도로 활용
    	rs=ps.executeQuery();//무조건 셀렉트문은 executeQuery()를 써야된다 리턴타입이 ResultSet
    	//거의 공용으로 사용함.
    	//sql exception으로 가는 문구
    	//쿼리문을 실행
    	// boolean 결과값이 boolean이야만 된다.
    	
		//rs와 같이 써야된다.
		//실행하자마자 false.
		//한줄만 가져오고 싶을때 if문을 써도 된다.
    	while(rs.next()){
    		//쿼리문이 출력될때 while문을 쓰면 여러줄인데 if문은 한줄을 출력한다.
    		int i_board=rs.getInt("i_board");
    		String title=rs.getString("title");
    		//컬럼명이 타이틀일 경우 같이 title에 저장된다.
    		//컬럼명.
    		//while문이 끝까지 오면 rs.next(); false를 리턴
    		//boardVo를 객체화를 하고 객채에다가 받아온값을 담다오고 리스트에다 add 해준다.
    		BoardVO vo=new BoardVO();
    		vo.setI_board(i_board);
    		vo.setTitle(title);
    		
    		boardList.add(vo);
    		
    		//이런 작업을 파싱이라고 한다.
    	}
    	
    	//닫을때는 반대로 실행
    }catch(Exception e){
    	e.printStackTrace();
    	//무엇때문에 에러가 터졌는지 알수가 없기 때문에 콘솔에다가 찍어주는 역할을 한다.
    	//왜 터졌는지 업데이트를 하고 개선을 시켜주기 위해서 이유를 보여주는게 중요하다.
    }finally{//열었으면 꼭 닫아줘야한다.
    	
    	//boardvo객체를 여러개 담을 수 있다.
    	//나올때도 boardvo 타입으로 나온다.
	    if(rs!=null){try{rs.close();}catch(Exception e){} }
    //안닫아주면 서버가 메모리릭으로 인해서터지게 된다 그래서 리소스를 많이 잡아먹음.
	    if(ps!=null){try{ps.close();}catch(Exception e){} }
    //커넥션툴은 콘을 여러개 만들고 안닫은 상태로 갖고있는데 요청이 오면 빌려주고 반납받는다.
    //커넥션이 연결될때 시간이 많이 걸린다. 그래서 서버기동할때 여러개 만들어 놓는다
    //그러면 속도가 빨라진다.
	    if(con!=null){try{con.close();}catch(Exception e){} }
    }
     %>
     
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>
 	<div>게시판 리스트
 		<a href="/jsp/boardWrite.jsp">글쓰기</a>
 	</div>
 	<table>
 		<tr>
 		<th>NO</th>
 		<th>제목</th>
 		</tr>
 		<% for(BoardVO vo: boardList){ %>
 		<tr>
 		<td><%= vo.getI_board() %></td>
 		<td>
 			<a href="/jsp/boardDetail.jsp?i_board=<%= vo.getI_board() %>">
 			<!-- a태그는 클릭하면 다른 웹으로 넘어가게 만든다. -->
 			<%= vo.getTitle() %> 
 			<!--
 			//타이틀값은 가져올수 있지만 비효율적이라 안가져왔을뿐.
    			//쿼리스트링에 붙여줬으면 된다.
    			왠만하면 다른 태그들은 get방식인데 
    			post방식은 form태그만들어 썻을때 사용
    			키값만 알면 getparameter로 받을수 있다. 
    			get방식에서 없으면 포스트에 물어본다.
 			-->
 			</a>
 		</td>
 		</tr>
 		<% } %>
 		
 		
 	</table>
</body>
</html>