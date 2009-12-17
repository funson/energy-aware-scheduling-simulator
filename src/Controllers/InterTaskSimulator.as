package Controllers {
	
	import flash.display.*;
	import flash.events.*;

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
		
		/**
		 * Initializes the Simulator
		 */
		public function InterTaskSimulator() {
			addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		/**
		 * Resynchronizes the display with the data stored in InterTaskService
		 * @param	e [Optional] Event.ADDED_TO_STAGE
		 */
		public function update(e:Event = null):void {
			while (this.numChildren > 0)
				this.removeChildAt(0);
				
			
		}
	}
}