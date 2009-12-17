package Services {
	/**
	 * A task in the TaskSet.  Used by InterTaskService.
	 * @author Chad Nelson
	 */
	public class Task {
		
		public var t : uint;	//taskID
		public var c : Number;	//computation time
		public var p : Number;	//period (and deadline)
		
		/**
		 * Initializes the Task
		 */
		public function Task(Ti : uint, Ci : Number, Pi : Number) {
			t = Ti;
			c = Ci;
			p = Pi;
		}	
	}
}