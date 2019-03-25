<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Bible book</title>
	<%@ include file="../include/header.jsp" %>
	<style>
		.select {
			padding: 4px 32px;
			margin: 4px 2px;
			cursor: pointer;
		}

		input {
			width: 220px;
			padding: 4px 32px;
			margin: 4px 2px;
		}
	</style>
	<script>
		$(function () {
			// console.log("function start>>");
			// Go project
			$("#btnProject").click(function () {
				location.href = "${path}/first/project.do";
			});
			// checkSelected();
			var tot_book = loadBibHeader(checkSelected());
			loadBibBody(checkSelected());
			$("#select_bib").change(function () {
				loadBibBody(checkSelected());
				loadBibHeader(checkSelected());
			});
			$("input[type='button']").click(function (e) {
				// Set form
				var book_id = (e.target.id < 10) ? "0" + e.target.id : e.target.id;
				var bib = checkSelected() + book_id;
				var book = $("#" + e.target.id + "").val();
				var tot_jang = $("#jang" + e.target.id + "").val();
				$("#bib").val(bib);
				$("#book").val(book);
				$("#tot_jang").val(tot_jang);

				var bpage = "${path}/bib_serv/read_bib.do";
				document.form1.action = bpage;
				document.form1.submit();
			});
			$(document).tooltip();
			// console.log("function end>>");
		});
		function checkSelected() {
			var ck = $("select option:selected").val();
			return ck;
		}
		function loadBibHeader(lang) {
			$.getJSON("../json/bib_header.json", function (data) {
				var items = [];
				var tot = [];
				// var items;
				$.each(data, function (idx, val) {
					//items.push(val);
					items[0] = val.testament;
					items[1] = val.testament_kr;
					//items[2] = val.total;
					var title = lang.substr(0, 1) == "e" ? items[0] : items[1];
					if (idx == 0) {
						tot[0] = val.total;
						$("#ipt_old").val(title);
					}
					else if (idx == 1) {
						tot[1] = val.total;
						$("#ipt_new").val(title);
					}
				});
				return tot;
			});
		}
		function loadBibBody(lang) {
			$.getJSON("../json/bib_body.json", function (data) {
				var items = [];
				// var ck = $("#ipt_old").val();
				var ck = "Old Testament";
				$.each(data, function (idx, val) {
					//items.push(val);
					// if (idx == 0) {
					items[0] = val.testament;
					items[1] = val.book;
					items[2] = val.book_kr;
					items[3] = val.tot_jang;
					// console.log("loadBibBody>> items:" + items[0] + "," + items[1] + "," + items[2]);
					var book = (lang.substr(0, 1) == 'e') ? items[1] : items[2];
					var tmpid = "jang" + (idx + 1);
					// console.log("tmpid=" + tmpid);
					if (items[0] == "Old Testament") {
						$("input[id='" + (idx + 1) + "']").val(book);
						$("input[id='" + tmpid + "']").val(items[3]);
						$("input[id='" + (idx + 1) + "']").attr("title", "장의 갯수:" + items[3]);
					}
					else if (items[0] == "New Testament") {
						$("input[id='" + (idx + 1) + "']").val(book);
						$("input[id='" + tmpid + "']").val(items[3]);
						$("input[id='" + (idx + 1) + "']").attr("title", "장의 갯수:" + items[3]);
					}
					// }
				});
				hiddenInput();
			});
		}
		// Set input[type='button'] from 67 to 78 to change type='hidden'
		function hiddenInput() {
			for (var i = 67; i < 79; i++) {
				$("input[id='" + i + "'").attr("type", "hidden");
			}
		}
	</script>
</head>

<body>
	<div class="container">
		<%@ include file="../include/session_check.jsp" %>
		<%@ include file="../include/project.jsp" %>
		<br>
		<select name="bib" id="select_bib">
			<option value="eNIV2011_bib" selected>NIV</option>
			<option value="kHRV_bib">개역한글판</option>
		</select>
		<br>
		<br>
		<table>
			<tr align="center">
				<th>
					<input type="button" id="ipt_old"
						style="font-weight:bold; font-size: 120%; background-color: #e7e7e7;" disabled>
				</th>
				<th>
					<input type="button" id="ipt_new"
						style="font-weight:bold; font-size: 120%; background-color: #e7e7e7;" disabled>
				</th>
			</tr>
			<c:forEach var="i" begin="1" end="39">
				<tr align="center">
					<td>
						<input type="button" id="${i}">
						<input type="hidden" id='jang${i}'>
					</td>
					<td>
						<input type="button" id="${i+39}">
						<input type="hidden" id='jang${i+39}'>
					</td>
				</tr>
			</c:forEach>
		</table>
		<form method="post" name="form1">
			<input type="hidden" name="bib" id="bib">
			<input type="hidden" name="book" id="book">
			<input type="hidden" name="tot_jang" id="tot_jang">
		</form>
		<br>
		<div value="rkskek"></div>
		<input type="hidden" id="total_book">
		<br>
		${tot_book}
		<!-- End of container -->
	</div>
</body>

</html>
