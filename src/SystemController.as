package {
		
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import Services.*;
	import Controllers.*;

	/** 
	 * SystemController is responsible for the following:
	 *  - bootstrapping once the preloader has finished
	 *  - initializing services
	 *  - initializing screens
	 *  - being the singleton reference that holds on to screens/services
	 *  - managing screen transitions
	 * @author Chad Nelson
	 */
	public class SystemController extends Sprite {
		private static var controller:SystemController;
		
		//Services
		public var interTaskService : InterTaskService;
		public var intraTaskService : IntraTaskService;
		
		//Screens
		public var screens:Array = new Array();
		
		//Private Vars
		private var currentScreen:DisplayObject = null;
		
		/** 
		 * Constructor - Initializes one instance of the SystemController.
		 * 
		 * Multiple calls like the following:
		 * var controller:SystemController = new SystemController();
		 * will return the same instance.
		 */
		public function SystemController() {
			if (controller == null) { 
				controller = this; 
				addEventListener(Event.ADDED_TO_STAGE, bootstrap);
			}
		}
		
		/**
		 * Static method to get instance of the SystemController.
		 * 
		 * Call like this:
		 * SystemController.getInstance();
		 * @return (SystemController) Returns the singleton instance of the SystemController.
		 */
		public static function getInstance():SystemController {
			return controller;
		}
		
		/**
		 * Bootstraps the project by starting services
		 * @param	e - Event.ADDED_TO_STAGE
		 */ 
		private function bootstrap(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, bootstrap);
			
			interTaskService = new InterTaskService();
			intraTaskService = new IntraTaskService();
			
			screens[ScreenIndex.MAIN]         = new MainScreen();
			screens[ScreenIndex.INTER_CREATE] = new InterTaskCreator();
			screens[ScreenIndex.INTER_RESULT] = new InterTaskSimulator();
			screens[ScreenIndex.INTRA_CREATE] = new IntraTaskCreator();
			screens[ScreenIndex.INTRA_RESULT] = new IntraTaskSimulator();
			animateChangeScreen(null, ScreenIndex.MAIN);
		}
		
		//Slide Animation transition
		private var animating : Boolean = false;
		private var frame_counter : int = 0;
		private var reverseAnimate : Boolean = false;
		public function animateChangeScreen(previous : DisplayObject, index : int, reverse : Boolean = false):void {
			if (stage.quality == "LOW") {
				removeChild(previous);
				addChild(screens[index]);
			} else if (!animating) {
				animating = true;
				var next : DisplayObject = DisplayObject(screens[index]);
				reverseAnimate = reverse;
				next.x = 1.2*stage.stageWidth;
				addChild(next);
				currentScreen = next;
				frame_counter = 0;
				if (previous != null) 
					previous.addEventListener(Event.ENTER_FRAME, animateTransition);
				else {
					var fake : MovieClip = new MovieClip();
					addChild(fake);
					fake.addEventListener(Event.ENTER_FRAME, animateTransition);
				}
			}
		}
		//Event.ENTER_FRAME Handler
		private function animateTransition(e:Event):void {
			var previous : DisplayObject = DisplayObject(e.currentTarget);
			var offset : Number, noffset : Number, foffset : Number, fnoffset : Number;
			frame_counter++;
			
			if (frame_counter < 85) {
				// Calculate offsets
				offset = Math.min(1, Math.max(0, Math.pow(frame_counter, 2.5) / Math.pow(50, 2.5)));
				noffset = Math.min(1, Math.pow(Math.min(50, 85 - frame_counter), 2.5) / Math.pow(50, 2.5));
				foffset = Math.min(1, Math.max(0, Math.pow(frame_counter, 3) / Math.pow(50, 3)));
				fnoffset = Math.min(1, Math.pow(Math.min(50, 85 - frame_counter), 3) / Math.pow(50, 3));
				
				previous.filters = [new BlurFilter(foffset*800, 0, 2)];
				currentScreen.filters = [new BlurFilter(fnoffset*800, 0, 2)];
				if (reverseAnimate) {
					previous.x = offset * 1.2 * stage.stageWidth;
					currentScreen.x = - noffset * 1.2 * stage.stageWidth;
				} else {
					previous.x = - offset * 1.2 * stage.stageWidth;
					currentScreen.x = noffset * 1.2 * stage.stageWidth;
				}
			} else {
				// Remove previous and erase filters
				currentScreen.filters = [];
				previous.removeEventListener(Event.ENTER_FRAME, animateTransition);
				removeChild(previous);
				currentScreen.x = 0;
				animating = false;
			}
		}
	}

}
