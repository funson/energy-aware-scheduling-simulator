package Controllers {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import Services.InterTaskService;
	import Services.Task;

	/**
	 * Takes data from InterTaskService and displays it to the this sprite.
	 * 
	 * Should display:
	 *  1) Utilization of processor
	 *  2) Three schedules of the task set
	 *    a) EDF Schedule of the tasks
	 *    b) EDF Schedule with DVS (any voltage level)
	 *    c) EDF Schedule with DVS set at certain intervals (quantized voltage levels)
	 *  3) Power consumption of all three schedules
	 */
	public class InterTaskSimulator extends Sprite {
		
		private var widget : wInterTaskSimulator;
		private var scheduled_tasks : Array;
		private var zoomLevel : Number = 100.0;
		
		//Graph properties (to draw the task on a graph)
		private const graph_height : Number = 85.0;
		private const graph_width : Number = 300.0;
		private const graph_x : Number = 258.0;
		private const graph_y : Number = 150.0;
		
		private const graph_spacingY : Number = 134.8;
		
		//Services
		private var data : InterTaskService = SystemController.getInstance().interTaskService;

		/**
		 * Initializes the Simulator
		 */
		public function InterTaskSimulator(w : wInterTaskSimulator) {
			widget = w;
			this.filters = [new DropShadowFilter(3, 45, 0x222222, 0.7, 4, 4, 1, 3)];
			addEventListener(MouseEvent.MOUSE_WHEEL, zoom);
		}
		
		/**
		 * Zooms in/out on the graph
		 * @param	e
		 */
		private function zoom(e:MouseEvent):void {
			zoomLevel -= e.delta;
			zoomLevel = Math.min(100, zoomLevel);
			zoomLevel = Math.max(1, zoomLevel);
			
			data.setSimulationEndTime();
			var mp : Number = data.getMajorPeriod();
			data.setSimulationEndTime(mp * zoomLevel / 100.0);
			
			update();
		}
		
		public function resetZoom():void {
			zoomLevel = 100.0;
		}
		
		/**
		 * Simulates the scheduler(s) and displays graphs of the simulation
		 */
		public function update():void {
			while (this.numChildren > 0)
				this.removeChildAt(0);
			graphics.clear();
				
			// Create EDF Schedule
			createSchedule(1);
			printGraph(0);
			
			// Create Static Voltage Scaling EDF
			var U : Number = data.getUtilization();
			createSchedule(U);
			printGraph(graph_spacingY);
		}
			
		/**
		 * Creates schedule for EDF and static voltage scaling EDF
		 * @param	utilization - utilization of the processor by the task set; from 0 to 1.0
		 */
		private function createSchedule(utilization : Number):void {
			scheduled_tasks = new Array();
			var i : uint, j : uint;
			
			// Add arrival times
			for (i = 0; i < data.tasks.length; i++) {
				var current_task : Task = Task(data.tasks[i]);
				j = 0;
				while (j < data.getMajorPeriod()) {
					var task : Task = new Task(current_task.t, current_task.c, current_task.p);
					task.arrival = j;
					task.deadline = task.arrival + task.p;
					task.frequency = 100 * utilization;
					task.c = task.c / utilization;
					scheduled_tasks.push(task);
					j += current_task.p;
				}
			}
			
			// Run scheduler
			var previous_task : Task = null;
			var time : Number;
			for (time = 0; time <= data.getMajorPeriod(); time++) {
				//Find task with the earliest deadline (out of those that have arrived)
				var next_task : Task = null;
				for (j = 0; j < scheduled_tasks.length; j++) {
					var temp : Task = Task(scheduled_tasks[j]);
					if (temp.arrival <= time) {
						if (next_task == null && temp.c > 0)
							next_task = temp;
						else if (temp.c > 0 && temp.deadline < next_task.deadline)
							next_task = temp;						
					}
				}
				
				//If we changed tasks
				if (previous_task != next_task) {
					if (previous_task != null) {
						previous_task.endTimes.push(Math.round(time*100.0)/100.0);
					}
					if (next_task != null) {
						next_task.startTimes.push(Math.round(time*100.0)/100.0);
					}
					previous_task = next_task;
				}
				
				if (next_task != null) {
					//Run task to the next second
					next_task.c -= Math.floor(time + 1) - time;
					
					//Check for early completion
					if (next_task.c < 0) {
						time += next_task.c;
					} else {
						time = Math.floor(time);
					}
				}
			}
			if (next_task != null)
				if (next_task.startTimes.length != next_task.endTimes.length)
					next_task.endTimes.push(data.getMajorPeriod());
		}
		
		/**
		 * Prints a schedule showing task execution (graph of task frequencies v. time)
		 * @param	offset - y offset
		 */
		private function printGraph(offset : Number):void {
			var i : uint;
			var task : Task;
			for (i = 0; i < scheduled_tasks.length; i++) {
				task = Task(scheduled_tasks[i]);
				task.redrawGraphic();
				task.y += offset;
				addChild(task);
				task.addEventListener(MouseEvent.MOUSE_OVER, highlight);
				task.addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
			}
			
			// Create Graph Outlines
			var go : graphOutline = new graphOutline();
			go.x = graph_x;
			go.y = graph_y + offset;
			addChildAt(go, 0);
			
			// Create notches every 1 and 5 and 10
			var notch : uint = 0;
			var majorPeriod : Number = data.getMajorPeriod();
			for (notch = 0; notch <= majorPeriod; notch+=5 ) {
				graphics.moveTo(graph_x + notch * graph_width / majorPeriod, graph_y + offset + graph_height);
				if (notch % 10 == 0) {
					graphics.lineStyle(3, 0xFFFFFF, 1);
					graphics.lineTo(graph_x +notch * graph_width / majorPeriod, graph_y + offset + graph_height + 3);
				} else {
					graphics.lineStyle(2, 0xFFFFFF, 1);
					graphics.lineTo(graph_x +notch * graph_width / majorPeriod, graph_y + offset + graph_height + 2);
				} 
			}
			
		}
		
		private function highlight(e:MouseEvent):void {
			var task : Task = Task(e.target);
			//bring to front
			setChildIndex(task, numChildren - 1);
			//display information
			widget.tcp_txt.text = "Ti: " + task.t + "\nCi: " + task.comp + "\nPi: " + task.p;
			widget.arrival_txt.text = "Arrival Time: " + task.arrival + "\n" + 
			                          "Deadline: " + task.deadline;
			widget.start_txt.text = "Start Time(s):\n" + task.startTimes;
			widget.stop_txt.text = "Stop Time(s):\n" + task.endTimes;
			widget.taskenergy_txt.text = "Frequency: " + Math.round(task.frequency * 10.0) / 10.0 + "%\n" + 
										 "Time Taken: " + Math.round(10000.0 * task.comp / task.frequency) / 100.0 + "\n" + 
										 "Energy Used: " + Math.round(10000.0 * task.comp / task.frequency * Math.pow(task.frequency/100.0, 3)) / 100.0;
		}
		
		private function unhighlight(e:MouseEvent):void {
			widget.tcp_txt.text = "";
			widget.arrival_txt.text = "";
			widget.start_txt.text = "";
			widget.stop_txt.text = "";
			widget.taskenergy_txt.text = "";
		}
	}
}