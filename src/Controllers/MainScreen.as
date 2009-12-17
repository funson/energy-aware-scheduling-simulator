package Controllers {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class MainScreen extends Sprite {
		
		private var widget : wMain = new wMain();
		
		public function MainScreen() {
			addChild(widget);
			
			//Add Button Connections
			widget.intertaskDVS_btn.addEventListener(MouseEvent.CLICK, gotoInterCreate);
			widget.intrataskDVS_btn.addEventListener(MouseEvent.CLICK, gotoIntraCreate);
			widget.intertaskDVS_btn.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			widget.intrataskDVS_btn.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			widget.intertaskDVS_btn.addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
			widget.intrataskDVS_btn.addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
			widget.intertaskDVS_btn.alpha = 0.8;
			widget.intrataskDVS_btn.alpha = 0.8;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, adjustEffects);
			adjustEffects(null);
		}
		
		private function gotoInterCreate(e:Event):void {
			SystemController.getInstance().animateChangeScreen(this, ScreenIndex.INTER_CREATE);
		}
		private function gotoIntraCreate(e:Event):void {
			SystemController.getInstance().animateChangeScreen(this, ScreenIndex.INTRA_CREATE);
		}
		
		private function highlight(e:MouseEvent):void {
			DisplayObject(e.currentTarget).alpha = 1;
		}
		private function unhighlight(e:MouseEvent):void {
			DisplayObject(e.currentTarget).alpha = 0.8;
		}
		private function adjustEffects(e:MouseEvent):void {
			var half : Number = (widget.intertaskDVS_btn.y + widget.intrataskDVS_btn.y) / 2;
			var alpha : Number;
			var distance : Number;
			var width : Number;
			var x_dist : Number;
			
			//Inter
			width = widget.intertaskDVS_btn.width / widget.intertaskDVS_btn.scaleX;
			if (mouseX > widget.intertaskDVS_btn.x)
				x_dist = Math.max(widget.intertaskDVS_btn.x, mouseX - width / 2);
			else 
				x_dist = Math.max(widget.intertaskDVS_btn.x, mouseX - width / 2);
				
			distance = Point.distance(new Point(x_dist, mouseY), 
									  new Point(widget.intertaskDVS_btn.x, widget.intertaskDVS_btn.y));
			alpha = Math.min(1, Math.max((70 - distance)/30.0, 0));
			
			widget.intertaskDVS_btn.scaleX = 1 + alpha * 0.03;
			widget.intertaskDVS_btn.scaleY = 1 + alpha * 0.03;
			widget.interTaskDVS_graphic.alpha = alpha;

			//Intra
			width = widget.intrataskDVS_btn.width / widget.intrataskDVS_btn.scaleX;
			if (mouseX > widget.intrataskDVS_btn.x)
				x_dist = Math.max(widget.intrataskDVS_btn.x, mouseX - width / 2);
			else 
				x_dist = Math.max(widget.intrataskDVS_btn.x, mouseX - width / 2);
				
			distance = Point.distance(new Point(x_dist, mouseY), 
									  new Point(widget.intrataskDVS_btn.x, widget.intrataskDVS_btn.y));
			alpha = Math.min(1, Math.max((70 - distance)/30.0, 0));
			
			widget.intrataskDVS_btn.scaleX = 1 + alpha * 0.03;
			widget.intrataskDVS_btn.scaleY = 1 + alpha * 0.03;
			widget.intraTaskDVS_graphic.alpha = alpha;
		}
	}
}