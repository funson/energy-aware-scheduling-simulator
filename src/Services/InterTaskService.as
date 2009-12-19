package Services {
	
	/**
	 * InterTaskService holds and organizes data to be simulated in the InterTaskSimulator.  
	 * Most importantly, it holds on to the set of tasks.
	 * @author Chad Nelson
	 */
	public class InterTaskService {
	
		public var tasks : Array;			// Array of tasks in this TaskSet
		private var endTime : Number;		// -1 = major period, otherwise specifies stop time for calculate()
		
		/**
		 * Initializes the InterTaskService
		 */
		public function InterTaskService() {
			clear();
		}	
		
		/**
		 * Clears the task set and resets the simulation end time to 'major period'
		 */
		public function clear():void {
			tasks = new Array();
			endTime = -1;
		}
		
		/**
		 * Sets an end time to the simulation.  The default value will run the simulation
		 * over the major period.
		 * @param	endTime [Optional] (Number) The time to end the simulation
		 */
		public function setSimulationEndTime(end_time : Number = -1):void {
			endTime = end_time;
		}
		
		/**
		 * Adds a task to this TaskSet
		 * @param	Ci - Computation Time
		 * @param	Pi - Period of Task
		 * @return  Ti - Task Index
		 */
		public function addTask(Ci : Number, Pi : Number):uint {
			var Ti : uint = tasks.length;
			var new_task : Task = new Task(Ti, Ci, Pi);
			tasks.push(new_task);
			return Ti;
		}
		
		/**
		 * Removes a task from this TaskSet
		 * @param	Ti - Task ID
		 */
		public function removeTask(Ti : uint):void {
			tasks.splice(Ti, 1);
			var i : uint;
			for (i = Ti; i < tasks.length; i++) {
				var current_task : Task = Task(tasks[i]);
				current_task.t = i;
			}
		}
		
		/**
		 * Runs a utilization test on this set of task.  If the total utilization is
		 * less than one, the this task set is scheduable.
		 * 
		 * @return (Boolean) Returns 'true' if this set of tasks is scheduable, 'false' otherwise.
		 */
		public function scheduabilityTest():Boolean {
			if (getUtilization() <= 1)
				return true;
			else
				return false;
		}
		
		/**
		 * Returns the utilization of the processor given the task set.  Numbers
		 * between 0 and 1 indicated possible utilization of the processor.
		 * @return (Number) utilization
		 */
		public function getUtilization():Number {
			var i : int;
			var utilization : Number = 0;
			
			for (i = 0; i < tasks.length; i++) {
				var current_task : Task = Task(tasks[i]);
				utilization += current_task.c / current_task.p;
			}
			
			return utilization;
		}
		
		/**
		 * Returns the length of the major period (the least common multiple of all task periods)
		 * @return (Number) length of major period
		 */
		public function getMajorPeriod():Number {
			if (endTime == -1) {
				//Find major period and return
				//TODO implement
				return 30;
			} else {
				return endTime;	
			}
		}
	}
}