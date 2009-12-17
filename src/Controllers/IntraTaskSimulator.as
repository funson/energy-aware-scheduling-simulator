package Controllers {
	
	import flash.display.*;
	import flash.events.*;
	
	public class IntraTaskSimulator extends Sprite {
		
		public function IntraTaskSimulator() {	
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}	
	}
}