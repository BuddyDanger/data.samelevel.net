<script>
$(function () {
	
	var SLFFL_ID = [<%= SLFFLTeamTrailID %>]
	var FARM_ID = [<%= FARMTeamTrailID %>]
	
	

	function loopThroughArray(array, callback, interval) {
    var newLoopTimer = new LoopTimer(function (time) {
        var element = array.shift();
        callback(element, time - start);
        array.push(element);
    }, interval);

    var start = newLoopTimer.start();
};

// Timer 
function LoopTimer(render, interval) {
    var timeout;
    var lastTime;

    this.start = startLoop;
    this.stop = stopLoop;

    // Start Loop
    function startLoop() {
        timeout = setTimeout(createLoop, 0);
        lastTime = Date.now();
        return lastTime;
    }
    
    // Stop Loop
    function stopLoop() {
        clearTimeout(timeout);
        return lastTime;
    }
    
    // The actual loop
    function createLoop() {
        var thisTime = Date.now();
        var loopTime = thisTime - lastTime;
        var delay = Math.max(interval - loopTime, 0);
        timeout = setTimeout(createLoop, delay);
        lastTime = thisTime + delay;
        render(thisTime);
    }
}
	
	loopThroughArray(SLFFL_ID, function (arrayElement, loopTime) {
		var thisID = arrayElement;
				 
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
					
					var touchdownBox1 = document.getElementsByClassName('team-slffl-touchdowns-' + data["teamid"])[0]
					var touchdownBox2 = document.getElementsByClassName('team-slffl-touchdowns-' + data["teamid"])[1]
					
					var touchdownSound = '/build/sounds/touchdown/slffl/' + data["teamid"] + '.mp3'
					
					if (parseFloat(touchdownBox1.innerText) == parseFloat(data["teamtds"])) {
						
						var sound = new Howl({
							src: [touchdownSound],
							autoplay: true,
							loop: false,
							volume: 1,
							onend: function() { console.log('Touchdown ' + data["teamname"] + '!'); }
						});
							
					}
					
					touchdownBox1.innerText = data["teamtds"];
					touchdownBox2.innerText = data["teamtds"];
					
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
}, 5000);
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
					
					var touchdownBox1 = document.getElementsByClassName('team-slffl-touchdowns-' + data["teamid"])[0]
					var touchdownBox2 = document.getElementsByClassName('team-slffl-touchdowns-' + data["teamid"])[1]
					
					var touchdownSound = '/build/sounds/touchdown/slffl/' + data["teamid"] + '.mp3'
					
					if (parseFloat(touchdownBox1.innerText) < parseFloat(data["teamtds"])) {
						
						var sound = new Howl({
							src: [touchdownSound],
							autoplay: true,
							loop: false,
							volume: 1,
							onend: function() { console.log('Touchdown ' + data["teamname"] + '!'); }
						});
							
					}
					
					touchdownBox1.innerText = data["teamtds"];
					touchdownBox2.innerText = data["teamtds"];
					
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
					
					var touchdownBox1 = document.getElementsByClassName('team-farm-touchdowns-' + data["teamid"])[0]
					var touchdownBox2 = document.getElementsByClassName('team-farm-touchdowns-' + data["teamid"])[1]
					
					var touchdownSound = '/build/sounds/touchdown/farm/' + data["teamid"] + '.mp3'
					
					if (parseFloat(touchdownBox1.innerText) < parseFloat(data["teamtds"])) {
						
						var sound = new Howl({
							src: [touchdownSound],
							autoplay: true,
							loop: false,
							volume: 1,
							onend: function() { console.log('Touchdown ' + data["teamname"] + '!'); }
						});
							
					}
					
					touchdownBox1.innerText = data["teamtds"];
					touchdownBox2.innerText = data["teamtds"];
					
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
		
		//updateSLFFL();
		//updateFARM();
	
	}, 5000);
	
});
</script>