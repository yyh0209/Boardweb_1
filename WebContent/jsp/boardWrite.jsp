<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    	String msg="";//err값이 안넘어왔다면 그냥 빈값
    	String err=request.getParameter("err");
    	if(err!=null){
    		switch(err){
    		case "10":
    			msg="";
    			break;
    		case "20":
    			msg="DB 에러발생";
    			break;
    		}
    	}
    //err은 null이 담겨져있다. 
    //뒤에 쿼리스트링이 없을땐 없는것 =가져올게 없기 때문에 null이 넘어온다.
    //
    //boardWrite.jsp에 받아오면 된다.
    //있을땐 글쓰기로 에러가 터졌을땐 err이 터진다.
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#msg{
	color:red;
}
	.jj{
	background-color: red;
	}
	.bb{
		
	}
</style>
</head>
<body>
<div id="msg"><%=msg %></div>
<div>
	<form id="frm" action="/jsp/boardWriteProc.jsp"method="post" onsubmit="return chk()">
	<!-- on으로 시작하는건 전부다 이벤트다 (함수형임)
	동작하는 것들이 이벤트다.리턴값이 false면  서버쪽으로 날아가지 않는다.
	onclick은 아무해더나 쓸수 있는데  
	문제가 생겻을때만 return false를 적용하는데 콜백함수를 알수있다.
	자바스크립트는 기본이 콜백함수다,
	return이 없으면 값이 서버쪽으로날아간다. -->
		<div> <label>제목:<input type="text" name="title" id="" class=""></label></div>
		<div> <label>내용:<textarea name="ctnt"></textarea></label></div>
		<div> <label>작성자:<input type="text" name="i_student" class="jj"></label></div>
		<div> <input type="submit" value="글등록"></div>
	</form>
</div>
<script>
	function eleVaild(ele,ctnt){
		if(ele.value.length==0){
			alert(ctnt)
			ele.focus()
			return true
		}
	}
	//ele,ctnt의 인자값을 받고 
	function chk(){
	console.log(`title:\${frm.title,value}`);//변수값을 넣으면 값이 삽입된다.
	if(eleVaild(frm.title,'제목')){
		return false;
		}
		else if(eleVaild(frm.ctnt,'내용')){
			return false;
		}else if(eleVaild(frm.i_student,'작성자')){
			return false;
		}
		/*}else if(frm.ctnt.value.length==0){
			alert('내용을 입력해주세요')
			frm.ctnt.focus()
			return false
		}else if(frm.i_student.value.length===0){
			alert('작성자를 입력해주세요');
			frm.i_student.focus()
			return false*/
		}//문제됐을 경우.
	//자바스크립트는 엘리먼트가 있어야 됨. body안에 적어두는게 좋은데 위쪽에 적을경우
	//import를 임포트할땐 해드안에 해야된다.
	//css가 늦게 다운될때는 번쩍이는 현상이 나타난다.
	//css는 밑에 적으면 안되고 위에 적어야 된다.
</script>
</body>
</html>