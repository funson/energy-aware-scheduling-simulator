package Controllers {
	
	import flash.display.*;
	import fl.events.*;
	import flash.events.*;
	import Services.InterTaskService;
	import Services.Task;
	
	/**
	 * Controller for Inter-Task Creation.  Handles user interactions to build their 
	 * own set of tasks and store in data service.
	 */
	public class InterTaskCreator extends Sprite {
		
		public var widget : wInterTaskSimulator = new wInterTaskSimulator();
		private var simulation : InterTaskSimulator = new InterTaskSimulator(widget);
		private var items : Array = new Array();
		
		//Services
		private var data : InterTaskService = SystemController.getInstance().interTaskService;
		
		/**
		 * Initialize the Controller
		 */
		public function InterTaskCreator() {
			addChild(widget);
			addChild(simulation);
			
			//Button Connections
			widget.back_btn.addEventListener(MouseEvent.CLICK, gotoMainMenu);
			widget.add_btn.addEventListener(MouseEvent.CLICK, addItemClicked);
			
			//Initialize with default data
			addItem(1, 3);
			addItem(1, 4);
			addItem(1, 12);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		/**
		 * Runs code when the view is added to the stage.
		 * @param	e - Event.ADDED_TO_STAGE
		 */
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Event handler for when the user clicks the "Add a Task" button
		 * @param	e - MouseEvent.CLICK
		 */
		private function addItemClicked(e:MouseEvent):void {
			var c : Number, p : Number;
			c = parseInt(widget.Ci.text); 
			p = parseInt(widget.Pi.text);
			if (isNaN(c) && isNaN(p)) {
				//TODO display error
			} else {
				addItem(c, p);
			}
				
			widget.Ci.text = "";
			widget.Pi.text = "";
		}
		
		/**
		 * Logic for adding a task to the task set
		 * @param	c - Computation Time
		 * @param	p - Period
		 */
		private function addItem(c : uint, p : uint):void {
			// Add item to data structure
			var Ti : uint = data.addTask(c, p);
			
			// Create visual display of item
			var new_item : task_item = new task_item();
			new_item.Ci.text = c.toString();
			new_item.Pi.text = p.toString();
			new_item.Ti.text = Ti.toString();
			widget.addChild(new_item);
			items.push(new_item);
			new_item.erase_task.addEventListener(MouseEvent.CLICK, removeItem);
			syncList();
		}
		
		/**
		 * Event handler for when a user clicks the "X" button next to a periodic task
		 * @param	e
		 */
		private function removeItem(e:MouseEvent):void {
			var item : task_item = task_item(SimpleButton(e.target).parent);
			// Remove item for data structure
			data.removeTask(parseInt(item.Ti.text));
			
			// Remove visual display of item
			widget.removeChild(item);
			var index : uint = items.indexOf(item);
			items.splice(index, 1);
			for (var i : uint = index; i < items.length; i++) {
				var current_task : task_item = task_item (items[i]);
				current_task.Ti.text = "" + i;
			}
			syncList();
		}
		
		/**
		 * Helper function - syncronizes list with data stored locally
		 */
		private function syncList():void {
			for (var i : uint = 0; i < items.length; i++ ) {
				var temp : task_item = task_item(items[i]);
				temp.x = 26.4;
				temp.y = 117.8 + (i*temp.height);
			}
			data.setSimulationEndTime();
			simulation.resetZoom();
			
			widget.utilization_txt.text = "U =\n" + Math.round(data.getUtilization() * 100.0) / 100.0;
			widget.energy1_txt.text = "" + Math.round(100.0 * data.getUtilization() * data.getMajorPeriod())/100.0;
			widget.energy2_txt.text = "" + Math.round(100.0 * Math.pow(data.getUtilization(), 3) * data.getMajorPeriod())/100.0;
			
			simulation.update();
		}
		
		/**
		 * Event handler for when the user clicks the "Main Menu" button
		 * @param	e - MouseEvent.CLICK
		 */
		private function gotoMainMenu(e:MouseEvent):void {
			SystemController.getInstance().animateChangeScreen(this, ScreenIndex.MAIN, true);
		}
		

	}
}