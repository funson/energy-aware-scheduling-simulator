package Services {
	
	/**
	 * IntraTaskService holds and organizes data to be simulated in the IntraTaskSimulator.  
	 * Most importantly, it holds on to the tree of intra-task nodes.
	 * @author Chad Nelson
	 */
	public class IntraTaskService {
	
		private var nodes : Array;		// Array of tasks in this TaskSet
		private var deadline : Number;	// Deadline
		
		/**
		 * Initializes the IntraTaskService
		 */
		public function IntraTaskService() {
			clear();
		}	
		
		/**
		 * Clears the node tree
		 */
		public function clear():void {
			nodes = new Array();
		}
		
		/**
		 * Sets an end time to the simulation.  The default value will run the simulation
		 * over the major period.
		 * @param	endTime [Optional] (Number) The time to end the simulation
		 */
		public function setDeadline(end_time : Number):void {
			deadline = end_time;
		}
		
		/**
		 * Adds a node to the tree
		 * @param	parent - parent Node
		 * @param	Ci - computation time
		 */
		public function addTask(parent : Node, Ci : Number):void {
			var Ti : uint = nodes.length;
			var new_node : Node = new Node(parent, Ti, Ci);
			nodes.push(new_node);
		}
		
		/**
		 * Removes a node from the tree
		 * @param	Ti - Task ID
		 */
		public function removeTask(Ti : uint):void {
			nodes.splice(Ti, 1);
			var i : uint;
			for (i = Ti; i < nodes.length; i++) {
				var current_node : Node = Node(nodes[i]);
				current_node.t--;
			}
		}
		
		/**
		 * Calculates the EDF schedule for this TaskSet over the major period.
		 */
		public function calculate():void {
			//TODO
		}
	}
}