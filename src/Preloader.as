package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="40")]
	
	/** 
	 * Entry point of application
	 * 
	 * Shows preloader while the project's .swf file is being downloaded.
	 * Once complete, it removes itself from the stage and starts the 
	 * SystemController
	 * @author Chad Nelson
	 */
	public class Preloader extends MovieClip {
		
		private var widget : wPreloader = new wPreloader();
		
		/**
		 * This is the entry point of our AS3 code
		 */
		public function Preloader() {
			addEventListener(Event.ENTER_FRAME, progress);
			addEventListener(Event.ADDED_TO_STAGE, center);
			widget.alpha = 0;
			
			addChild(new wBackground());
			addChild(widget);
		}
		
		/**
		 * Centers the widget to the stage (the display window)
		 * @param	e - Event.ADDED_TO_STAGE
		 */
		private function center(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, center);
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			widget.x = stage.stageWidth / 2;
			widget.y = stage.stageHeight / 2;
		}
		
		/**
		 * Updates the progress bar as the .swf file loads.  Starts by fading in 
		 * the progress bar.  When finished, sets up the event handler hide().
		 * @param	e - Event.ENTER_FRAME
		 */
		private function progress(e:Event):void {
			widget.bars.x = (widget.bars.x - 1) % 41;
			widget.load_txt.text = String(loaderInfo.bytesLoaded);
			widget.total_txt.text = String(loaderInfo.bytesTotal);
			var pct:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			widget.percent_txt.text = Math.round(100 * pct) + "%";
			widget.fill.scaleX = pct;
			widget.alpha = Math.min(1, widget.alpha + 0.05);
			if (pct == 1) {
				removeEventListener(Event.ENTER_FRAME, progress);
				addEventListener(Event.ENTER_FRAME, hide);
			}
		}
		
		/**
		 * Hides the progress bar by fading out, then bootstraps the project by
		 * initializing the SystemController
		 * @param	e - Event.ENTER_FRAME
		 */
		private function hide(e:Event):void {
			widget.alpha = Math.max(0, widget.alpha - 0.05);
			widget.bars.x = (widget.bars.x - 1) % 41;
			if (widget.alpha == 0) {
				removeEventListener(Event.ENTER_FRAME, hide);
				removeChild(widget);
				stop();
				var mainClass:Class = getDefinitionByName("SystemController") as Class;
				addChild(new mainClass() as DisplayObject);
			}
		}
				
	}
	
}