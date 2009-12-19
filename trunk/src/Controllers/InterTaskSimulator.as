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
		private const graph_spacingY : Number = 134.8;
		
		//Services
		private var data : InterTaskService = SystemController.getInstance().interTaskService;

		/**
		 * Initializes the Simulator
		 */
		public function InterTaskSimulator(w : wInterTaskSimulator) {
			widget = w;
			this.filters = [new DropShadowFilter()];
		}
		
		/**
		 * Simulates the scheduler(s) and displays graphs of the simulation
		 */
		public function update():void {
			while (this.numChildren > 0)
				this.removeChildAt(0);
				
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
			for (time = 0; time < data.getMajorPeriod(); time++) {
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
						previous_task.endTimes.push(Math.round(time*1000.0)/1000.0);
					}
					if (next_task != null) {
						next_task.startTimes.push(Math.round(time*1000.0)/1000.0);
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
		}
		
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
		}
		
		private function highlight(e:MouseEvent):void {
			var task : Task = Task(e.target);
			//display information
			widget.tcp_txt.text = "Ti: " + task.t + "\nCi: " + task.comp + "\nPi: " + task.p;
			widget.arrival_txt.text = "Arrival Time: " + task.arrival + "\n" + 
			                          "Deadline: " + task.deadline + "\n" + 
									  "Frequency: " + Math.round(task.frequency*10.0)/10.0 + "%";
			widget.start_txt.text = "Start Time(s): " + task.startTimes;
			widget.stop_txt.text = "Stop Time(s): " + task.endTimes;
		}
		
		private function unhighlight(e:MouseEvent):void {
			widget.tcp_txt.text = "";
			widget.arrival_txt.text = "";
			widget.start_txt.text = "";
			widget.stop_txt.text = "";
		}
	}
}