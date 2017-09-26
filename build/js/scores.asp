<script>
$(function () {
	
	var SLFFL_ID = [<%= SLFFLTeamTrailID %>]
	var FARM_ID = [<%= FARMTeamTrailID %>]

	function updateSLFFL() {
		
		for (i = 0; i < 12; i++) {
			
			var thisID = SLFFL_ID[i];
			
			var data = {
				"league":"slffl",
				"id":thisID
			};

			data = $.param(data);
			
			$.ajax({
				type: "GET",
				dataType: "json",
				url: "http://data.samelevel.net/scores/team/json/",
				data: data,
				success: function(data) {
					
					var scoreBox1 = document.getElementsByClassName('team-slffl-score-' + data["teamid"])[0]
					var scoreBox2 = document.getElementsByClassName('team-slffl-score-' + data["teamid"])[1]
					
					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}
					
					if (parseFloat(scoreBox2.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation2 = new CountUp(scoreBox2, scoreBox2.innerText, data["teamscore"], 2, 4);
						scoreAnimation2.start();
					}
					
				}
			});
			
		}
	
	}
	
	function updateFARM() {
		for (i = 0; i < 12; i++) {
			
			var thisID = FARM_ID[i];
			
			var data = {
				"league":"farm",
				"id":thisID
			};

			data = $.param(data);
			
			$.ajax({
				type: "GET",
				dataType: "json",
				url: "http://data.samelevel.net/scores/team/json/",
				data: data,
				success: function(data) {
					
					var scoreBox1 = document.getElementsByClassName('team-farm-score-' + data["teamid"])[0]
					var scoreBox2 = document.getElementsByClassName('team-farm-score-' + data["teamid"])[1]
					
					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}
					
					if (parseFloat(scoreBox2.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation2 = new CountUp(scoreBox2, scoreBox2.innerText, data["teamscore"], 2, 4);
						scoreAnimation2.start();
					}
					
				}
			});
			
		}
	}
	
	
	setInterval(function() {
		
		updateSLFFL();
		updateFARM();
	
	}, 5000);
	
});
</script>