<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Bible</title>
	<style>
		.button {
			width: 38px;
			margin: 4px 2px;
		}
	</style>
	<%@ include file="../include/header.jsp" %>
	<script>
		$(function () {
			var jang = "${jang}";
			var jeul = "${jang}"; // Init jeul from jang
			var bib_book = "${bib_book}";
			if (bib_book[0] == "k") {
				$("#transl").val("English translate");
			}
			load(bib_book, jang, jeul);
			// Set current button disable
			initJangButton(jang, true);
			jang = setBottomButton(jang, "${tot_jang}");
			$("#curr_jang").val(jang); // Set current jang
			$("#btnProject").click(function () {
				location.href = "${path}/first/project.do";
			});
			$("input[name='jang']").click(function (e) {
				// Init button of jang
				initJangButton(jang, false);

				jeul = view($("#viewJeul").val(), false);
				// Check the bottom button was clicked
				jang = setBottomButton(e.target.id, "${tot_jang}");
				//jang = e.target.id;
				$("#curr_jang").val(jang); // Set current jang
				// Set current button disable
				initJangButton(jang, true);
				// Set the value of bottom button
				sendjang(bib_book, jang, jeul);
			});
			$("#viewJeul").click(function () {
				jeul = view($("#viewJeul").val(), true);
				init();
				load(bib_book, jang, jeul);
			});
			$("#transl").click(function () {
				var trans_book = bib_book.substr(bib_book.length - 10, 10);
				$("#transl").attr("type", "hidden");
				// Check Korean and English
				if (bib_book[0] == "e") {
					loadTransl("kHRV_" + trans_book, jang, jeul); // Loading Korean bib(kHRV)
				}
				else {
					loadTransl("eNIV2011_" + trans_book, jang, jeul); // Loading English bib(eNIV2011)
				}
			});
			// Set the font size
			$("#btnAdjustFontPlus").on("click", function () {
				//console.log($("#div_bcon").css("font-size").substr(0,2));
				var size = parseInt($("#div_bcon").css("font-size").substr(0, 2));
				if (size * 1.2 < 99) size *= 1.2;
				$("#div_bcon").css("font-size", size);
			});
			$("#btnAdjustFontMinus").on("click", function () {
				//console.log($("#div_bcon").css("font-size").substr(0,2));
				var size = parseInt($("#div_bcon").css("font-size").substr(0, 2));
				if (size * 0.8 > 9) size *= 0.8;
				$("#div_bcon").css("font-size", size);
			});
		});
		function initJangButton(jang, b) {
			if (b) {
				// Set current button disable
				$("input[id='" + jang + "']").css("background-color", "#e7e7e7");
				$("input[id='" + jang + "']").prop("disabled", b);
			}
			else {
				// Init button of jang
				$("input[id='" + jang + "']").css("background-color", "");
				$("input[id='" + jang + "']").prop("disabled", b);
			}
		}
		function setBottomButton(id, tot) {
			var curr_j = parseInt($("#curr_jang").val());
			//console.log("curr_j="+curr_j);
			if (id == "btnLbottom") {
				if ($("#curr_jang").val() > 1) {
					jang = curr_j - 1;
				}
			}
			else if (id == "btnRbottom") {
				if ($("#curr_jang").val() < "${tot_jang}") {
					jang = curr_j + 1;
				}
			}
			else {
				jang = id;
			}
			// Disable the button of L, R
			if (jang == 1) {
				$("#btnLbottom").prop("disabled", true);
				if ($("#btnRbottom").attr("disabled") == "disabled") {
					$("#btnRbottom").attr("disabled", false);
				}
			}
			else if (jang == tot) {
				$("#btnRbottom").prop("disabled", true);
				if ($("#btnLbottom").attr("disabled") == "disabled") {
					$("#btnLbottom").prop("disabled", false);
				}
			}
			else {
				if ($("#btnLbottom").attr("disabled") == "disabled") {
					$("#btnLbottom").prop("disabled", false);
				}
				if ($("#btnRbottom").attr("disabled") == "disabled") {
					$("#btnRbottom").attr("disabled", false);
				}
			}
			return jang;
		}
		function view(jeul, ck_both) {
			if (jeul == "절 단위로 보기" && ck_both == true) {
				jeul = 0;
				$("#viewJeul").val("절 이어서 보기");
				$("#transl").attr("type", "button");
			}
			else {
				jeul = 1;
				$("#viewJeul").val("절 단위로 보기");
				$("#transl").attr("type", "hidden");
			}
			return jeul
		}
		function loadTransl(bib_book, jang, jeul) {
			//console.log(bib_book+","+jang+","+jeul);
			var bfolder = bib_book.substr(0, bib_book.length - 7);
			$.getJSON("../json/" + bfolder + "/" + bib_book, function (data) {
				var items;
				var cnt = 0;
				// 190322 Change the line 
				var end;
				if (jeul == 0)
					end = "<br>";
				else
					end = "&nbsp;&nbsp;&nbsp;";
				$.each(data, function (key, val) {
					cnt += 1;
					items = val.bib_chapter.split(":")
					items[2] = val.bib_content;
					if (items[1] == 1) { // if items[1](jeul) is 1, set red color in content
						if (items[0] == jang) { // Check the same jang
							if (jeul == 0) { // Append to div jeul for translate line
								$("#jeul" + items[1] + "").append("<span style='color:red;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
							}
							else {
								$("#div_bcon").append("<span style='color:red;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
							}
						}
					}
					else {
						if (items[0] == jang) { // Check the same jang
							if (jeul == 0) { // Append to div jeul for translate line
								$("#jeul" + items[1] + "").append("<span style='font-size:80%;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
							}
							else {
								$("#div_bcon").append("<span style='font-size:80%;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
							}
						}
					}
				});
			});
		}
		function load(bib_book, jang, jeul) {
			//console.log("load>>"+bib_book+","+jang);
			//var fname="eNIV2011_bib01.json";
			var bname;
			var bfolder = bib_book.substr(0, bib_book.length - 7);
			$.getJSON("../json/" + bfolder + "/" + bib_book, function (data) {
				var items;
				var cnt = 0;
				// 190322 Change the line 
				var end;
				if (jeul == 0)
					end = "<br>";
				else
					end = "&nbsp;&nbsp;&nbsp;";
				$.each(data, function (key, val) {
					cnt += 1;
					items = val.bib_chapter.split(":")
					items[2] = val.bib_content;

					// Check jang
					//if(items[0]!=1) return; // if 1 jang
					if (items[1] == 1) { // if 1 jeul, set red color in content
						if (items[0] == jang) {
							if (jeul == 0) {
								$("#div_bcon").append("<span style='color:red;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end
									+ "<div id='jeul" + items[1] + "'></div>");
								//+items[0]+":"+items[1]+"</span> "+items[2]+"&nbsp;&nbsp;&nbsp;");
								//+items[0]+":"+items[1]+"</span> "+items[2]+"<br>");
							}
							else {
								$("#div_bcon").append("<span style='color:red;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
							}
						}
					}
					else {
						if (items[0] == jang) {
							if (jeul == 0) {
								$("#div_bcon").append("<span style='font-size:80%;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end
									+ "<div id='jeul" + items[1] + "'></div>");
								//+items[0]+":"+items[1]+"</span> "+items[2]+"&nbsp;&nbsp;&nbsp;");
								//+items[0]+":"+items[1]+"</span> "+items[2]+"<br>");
							}
							else {
								$("#div_bcon").append("<span style='font-size:80%;'>"
									+ items[0] + ":" + items[1] + "</span> " + items[2] + end);
								//+items[0]+":"+items[1]+"</span> "+items[2]+"&nbsp;&nbsp;&nbsp;");
								//+items[0]+":"+items[1]+"</span> "+items[2]+"<br>");
							}
						}
					}
				});
			});
		}
		function sendjang(bib_book, jang, jeul) {
			var param = { "jang": jang };
			$.ajax({
				type: "post",
				url: "${path}/bib_serv/read_bib_jang.do",
				data: param,
				success: function (result) {
					//console.log("success>> jang="+jang)
					init();
					load(bib_book, jang, jeul);
					//location.reload();
				},
				error: function (e) {
					alert(e);
				}
			});
		}
		function init() {
			$("#div_bcon").empty();
		}
	</script>
</head>

<body>
	<%-- ${bib_book}<br>
${jang}<br> --%>
	<div class="container">
		<%@ include file="../include/project.jsp" %>
		<input type="button" id="viewJeul" value="절 단위로 보기">&nbsp;
		<input type="hidden" id="transl" value="번역 보기"><br>
		<br>
		<div style="text-align: right">
			글자 크기 조절
			<button id="btnAdjustFontMinus">-</button><button id="btnAdjustFontPlus">+</button>
		</div>
		<h3>${book}</h3>
		<!-- 모든 파일을 체크해서 헤더를 만들면 로딩 시간이 걸림 -->
		<!-- Index -->
		<form id="btnJangMove">
			<!-- <input type="submit" value="장 이동" /> -->
			<c:forEach var="i" begin="1" end="${tot_jang}">
				<%-- <input class="radio" type="radio" name="jang" value="${i}">${i}</input> --%>
				<input class="button" type="button" name="jang" id="${i}" value="${i}">
				<input type="hidden" name="jang" id="curr_jang" value="">
			</c:forEach>
		</form>
		<br>
		<!-- Content -->
		<div id="div_bcon"></div>
		<!-- End of Content -->
		<br>
		<div style="text-align: center">
			<input class="button" type="button" name="jang" id="btnLbottom" value="이전">
			<input class="button" type="button" name="jang" id="btnRbottom" value="다음">
		</div>
		<!-- End of container -->
	</div>
	<br>
	<br>
	<br>
</body>

</html>
