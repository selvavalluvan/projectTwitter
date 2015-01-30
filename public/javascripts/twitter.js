
function getTweets() {
      var screenName = document.getElementById('screen_name').value
      var error =  document.getElementById("errors");
      var myTable = document.getElementById("tweetsTable");
      while (myTable.rows.length > 2) {
            myTable.deleteRow(myTable.rows.length-1);
      }
      error.innerHTML ="";

      var http = new XMLHttpRequest();
      http.open("GET","/tweets/"+screenName, true);
      http.send();
      http.onload = function() {
		var response = http.response;
		response = response.replace(/(\r\n|\n|\r)/gm,"");
            response = JSON.parse(response);
            if(http.status == 200) {
				  console.log(response);
                  drawTable(response);
            } else {
                  if (typeof response.errors === 'undefined') {
                        error.innerHTML = response.error;
                  } else {
                        error.innerHTML = response.errors[0].message;
                  }
            }
      }
}


function getcommonFollowings() {
      var tweety1 = document.getElementById('tweety1').value
      var tweety2 = document.getElementById('tweety2').value
      var error = document.getElementById('errors');
      var myTable = document.getElementById("commonFollowingsTable");
      while (myTable.rows.length > 2) {
            myTable.deleteRow(myTable.rows.length-1);
      }
      error.innerHTML ="";

      var http = new XMLHttpRequest();
      http.open("GET","/followings/"+tweety1+"/"+tweety2, true);
      http.send();
      http.onload = function() {
		var response = http.response;
		response = response.replace(/(\r\n|\n|\r)/gm,"");
            response = JSON.parse(response);
            if(http.status == 200) {
                 drawFollowingTable(response.result);
            } else {
                 if (typeof response.errors === 'undefined') {
                       error.innerHTML = response.error;
                 } else {
                       error.innerHTML = response.errors[0].message;
                 }
            }
      }
}

function drawTable(data) {
      for (var i = 0; i < data.length; i++) {
            drawRow(data[i]);
      }
}

function drawRow(rowData) {
      var row = $("<tr />")
      $("#tweetsTable").append(row);
      row.append($("<td>" + rowData.id + "</td>"));
      row.append($("<td>" + rowData.text + "</td>"));
      row.append($("<td>" + rowData.created_at + "</td>"));
}


function drawFollowingTable(data) {
      for (var i = 0; i < data.length; i++) {
            drawFollowingRow(data[i]);
      }
}

function drawFollowingRow(rowData) {
      var row = $("<tr />")
      $("#commonFollowingsTable").append(row);
      row.append($("<td><img src="+rowData.profile_image_url +"></img></td>"));
      row.append($("<td>" + rowData.name + "</td>"));
      row.append($("<td>" + rowData.screen_name + "</td>"));
      row.append($("<td>" + rowData.description + "</td>"));
      row.append($("<td>" + rowData.id + "</td>"));
}
