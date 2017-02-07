<%
if (session.getAttribute("authenticated") == null) {
	request.getRequestDispatcher("login.jsp").forward(request,response);
}
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
	    <link href="${pageContext.request.contextPath}/CSS/narrow-jumbotron.css" rel="stylesheet">
		<title>Fabflix</title>
	</head>
	<body>
		<div class="container">
			<%@ include file="../navbar.jsp" %>
		</div>
	
		${sessionScope }
	
		<input type="text" placeholder="Search for movie" class="form-control" name="movie_title" id="search_movie_title">
		<input type="text" placeholder="Search by year" class="form-control" name="year" id="search_movie_year">
		<input type="text" placeholder="Search by director" class="form-control" name="director" id="search_movie_director">
		<input type="text" placeholder="Search by star" class="form-control" name="star" id="search_movie_star">
		
		<div style="padding-top:1%;"></div>

		
		<div class="container-fluid">
		<div id="myvariables">
		</div>
										
								<p> Showing ${results.size()} number of results </p>
								<p> ${countResults} total results found! </p>
								
								
		<nav aria-label="Page navigation example">
			<ul class="pagination" id="pNumbers">
			</ul>
			
		</nav>			
		
				<div class="row">
					<div class="col-12">
					<div class="row pt-4">
						<div class="mx-auto" style="width: 1000px">
							<table class="table">
								<thead>
									<tr id="tableheaders">
										<th></th>
										<th>Movie ID</th>
										<th><a href="#" id="titlesort">Title</a></th>
										<th><a href="#" id="yearsort">Year</a></th>
										<th>Director</th>
										<th>Staring</th>
									</tr>
								</thead>
							
								<tbody id="content"></tbody>
							</table>
							<div class="container"> </div>
						</div>
					</div>
					</div>
				</div>
			</div>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		
		<script type="text/javascript">

			
			var lastPage = 1; 
			var lastSort = "title";
			var lastOrder = "asc";
			var p = 1;
			
			function searchMovie(pageId, sort, order){

				var html;
				var paginate_html = '';
				var tablehead_html = '';
				var numPage;
				
				
				$.ajax({
					type: "GET",
					datatype: "json",
					url: "./Search",
					data: {"title": $('input[name="movie_title"]').val(),
							"year": $('input[name="year"]').val(),
							"director": $('input[name="director"]').val(),
							"star": $('input[name="star"]').val(),
							"pageId": pageId,
							"sort": sort,
							"order": order},
					success: function(result){
			        	 			        	 
						 html += "<tbody id='content'>";
						 
						 jQuery.each(result.movies, function(index, item) {
	
							 html += 
								 "<tr>" +
								 "<th scope='row'>" + "<img src='" + item.banner +  "' height='36' width='44'>"
							 	+ "<td class='align-middle'>" + item.id + "</td>"
								+ "<td class='align-middle'>" + item.title + "</td>"
							 	+ "<td class='align-middle'>" + item.year + "</td>"
							 	+ "<td class='align-middle'>" + item.director +  "</td>"
							 	+ "<td class='align-middle'>";
							 	
		            		 	jQuery.each(item.stars, function(index, star) {
		            		 		html += "<a href='Star?starId=" + star.id + "'>" + star.firstName + " " + star.lastName + " </a><br>";
		            		 	});
		            		 	
							 + "</td></tr>";
							 numPage = item.numPages;
							 
						 })
						 html += "</tbody>";
						 $('#content').replaceWith(html);
						
						p = pageId;

				        //output a pagination
				        if (numPage){
				        	var prev = p-1;
				        	var next = p+1;
				        	
				        	if (prev > 0){
					            paginate_html += '<li class="page-item"><a class="page-link" href="#" onclick="getPage(' + 
					            		prev + " , '" + sort + "' , '" + order + "')" + '">Previous</a></li>';
				        	}
				        	else {
					            paginate_html += '<li class="page-item disabled"><a class="page-link" href="#" onclick="getPage(' + 
					            		1 + " , '" + sort + "' , '" + order + "')" + '">Previous</a></li>';
				        	}
				        	for(var x = 1;  x <= numPage; x++){
				       			if (x == p){
						            paginate_html += '<li class="page-item active"><a class="page-link" href="#" onclick="getPage(' + 
						            		x + " , '" + sort + "' , '" + order + "')" + '">' + x +'</a></li>';
				       			}
				       			else{
						            paginate_html += '<li class="page-item"><a class="page-link" href="#" onclick="getPage(' + 
						            		x + " , '" + sort + "' , '" + order + "')" + '">'  + x + '</a></li>';
				       			}
					        }
				        	if (next > numPage){
					            paginate_html += '<li class="page-item disabled"><a class="page-link" href="#" onclick="getPage(' + 
					            		numPage + " , '" + sort + "' , '" + order + "')" + '">Next</a></li>';
				        	}
				        	else {
					            paginate_html += '<li class="page-item"><a class="page-link" href="#" onclick="getPage(' + 
					            		next + " , '" + sort + "' , '" + order + "')" + '">Next</a></li>';
				        	}				        	
							 $('#pNumbers').html(paginate_html);					 
				        }
				        else{
							 $('#pNumbers').html("");					 
				        }
				        
						if (sort == lastSort) {
							order = (lastOrder === 'desc') ? 'asc' : 'desc';
						}
						
			        	 lastPage = p;
			        	 lastSort = sort;       	 
			        	 lastOrder = order;
			        	 

						
					}});
			}
			
		
		
		
			function getPage(page_num, sort, order){
		        searchMovie(page_num, sort, order);
			}		
			
			$(document).ready(function () {

				  $("#search_movie_title, #search_movie_year, #search_movie_director, #search_movie_star").on("keyup", function(e) {
					    if(e.which == 13) {
					        searchMovie(1, "title", 'asc');
					    }
					    

					});
				  $("#titlesort").on("click", function(e) {
						searchMovie(p, "title", lastOrder);
					});				  
				  $("#yearsort").on("click", function(e) {
						searchMovie(p, "year", lastOrder);
					});					  
				  
				});		

			

			    //Set up the page number links

			    //Load the first page
			    
		</script>

	</body>
</html>