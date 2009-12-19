package Services {
	import fl.controls.LabelButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * A task in the TaskSet.  Used by InterTaskService.
	 * @author Chad Nelson
	 */
	public class Task extends Sprite {
		
		public var t : uint;	//taskID
		public var c : Number;	//computation time left
		public var p : Number;	//period
		public var comp : Number; //computation time
		
		public var arrival : uint;	//arrival time of this task instance
		public var deadline : uint;	//deadline time of this task instance
		
		public var startTimes : Array = new Array();	//times this task started while scheduling
		public var endTimes : Array = new Array();		//times this task stopped while scheduling
		
		public var frequency : Number = 100.0;
		
		
		//Graph properties (to draw the task on a graph)
		private const graph_height : Number = 85;
		private const graph_width : Number = 300;
		private const graph_x : Number = 258;
		private const graph_y : Number = 153;
		
		//Services
		private var data : InterTaskService = SystemController.getInstance().interTaskService;
		
		public function Task(Ti : uint, Ci : Number, Pi : Number) {
			t = Ti;
			c = Ci;
			p = Pi;
			comp = Ci;
			
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
			addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
			alpha = 0.4;
		}
		
		public function redrawGraphic():void {
			graphics.clear();
			
			graphics.lineStyle(3, 0xFFFFFF, 1);
			graphics.beginFill(getColor(t), 0.7);
			
			// Draw scheduled computation times
			var i : uint;
			for (i = 0; i < endTimes.length; i++) {
				var start : uint = uint(startTimes[i]);
				var end : uint = uint(endTimes[i]);
				graphics.drawRoundRectComplex(graph_x + start * graph_width / data.getMajorPeriod(), 		//x
											  graph_y + (100 - frequency) * graph_height / 100.0, 			//y
											  (end - start) * graph_width / data.getMajorPeriod(), 			//width
											  graph_height * frequency / 100.0,								//height
											  3, 3, 3, 3);
			}
		}
		
		private function getColor(t : uint):uint {
			switch(t) {
				case 0: 
					return 0x104BA9;
				case 1:
					return 0xFF7BD4;
				case 2: 
					return 0xFFC600;
				default:
					return 0x6A93D4;
			}
		}
		
		private function highlight(e:MouseEvent):void {
			alpha = 1.0;
			graphics.lineStyle(3, 0x444444, 1);
			// Draw arrival and deadline
			graphics.moveTo(graph_x + arrival * graph_width / data.getMajorPeriod(), graph_y + graph_height + 10);
			graphics.lineTo(graph_x + arrival * graph_width / data.getMajorPeriod(), graph_y + graph_height - 10);
			
			graphics.moveTo(graph_x + deadline * graph_width / data.getMajorPeriod(), graph_y + graph_height + 10);
			graphics.lineTo(graph_x + deadline * graph_width / data.getMajorPeriod(), graph_y + graph_height - 10);
		}
		
		private function unhighlight(e:MouseEvent):void {
			alpha = 0.4;
			redrawGraphic();
		}
	}
}