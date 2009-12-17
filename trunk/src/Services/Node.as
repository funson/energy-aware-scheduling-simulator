package Services {
	/**
	 * A node in the TaskTree.  Used by IntraTaskService.
	 * @author Chad Nelson
	 */
	public class Node {
		
		public var parent : Node;		//parent node
		public var t : uint;			//nodeID
		public var c : Number;			//computation time
		public var children : Array;	//Array of children nodes
		
		/**
		 * Initializes the Task
		 */
		public function Node(parentNode : Node, Ti : uint, Ci : Number) {
			parent = parentNode;
			children = new Array();
			t = Ti;
			c = Ci;
		}	
	}
}