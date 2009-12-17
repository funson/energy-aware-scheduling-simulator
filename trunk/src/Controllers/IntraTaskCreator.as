package Controllers {
	
	import flash.display.*;
	import flash.events.*;
	
	public class IntraTaskCreator extends Sprite {
		
		private var widget : wIntraTaskSimulator = new wIntraTaskSimulator();
		
		public function IntraTaskCreator() {
			addChild(widget);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			widget.x = stage.stageWidth / 2;
			widget.y = stage.stageHeight / 2;
		}
	}
}