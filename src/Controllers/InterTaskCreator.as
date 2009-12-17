package Controllers {
	
	import flash.display.*;
	import fl.events.*;
	import flash.events.*;
	import Services.InterTaskService;
	
	/**
	 * Controller for Inter-Task Creation.  Responsible for connecting the view to data services.
	 * 
	 * 1) Imports file (csv) to data grid
	 * 2) Exports data grid to file (csv)
	 * 3) Handling user interactions to build their own set of tasks
	 */
	public class InterTaskCreator extends Sprite {
		
		private var widget : wInterTaskSimulator = new wInterTaskSimulator();
		private var simulation : InterTaskSimulator = new InterTaskSimulator();
		private var count : uint;
		
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
			widget.export_btn.addEventListener(MouseEvent.CLICK, exportDataGrid);
			widget.import_btn.addEventListener(MouseEvent.CLICK, importDataGrid);
			widget.add_btn.addEventListener(MouseEvent.CLICK, addItem);
			widget.remove_btn.addEventListener(MouseEvent.CLICK, removeItem);
			
			//Initialize DataGrid
			widget.dataGrid.columns = ["Ti", "Ci", "Pi"];
			widget.dataGrid.editable = true;
			widget.dataGrid.allowMultipleSelection = false;
			widget.dataGrid.rowCount = 17;
			widget.dataGrid.minColumnWidth = widget.dataGrid.width / 3;
			widget.dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, syncModel);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		/**
		 * Runs code when the view is added to the stage.
		 * @param	e - Event.ADDED_TO_STAGE
		 */
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function addItem(e:MouseEvent):void {
			count++;
			widget.dataGrid.addItem({ Ti:count, Ci:"", Pi:"" });
		}
		private function removeItem(e:MouseEvent):void {
			if (widget.dataGrid.selectedIndex != -1) {
				count--;
				widget.dataGrid.removeItemAt(widget.dataGrid.selectedIndex);
			}
		}
		
		/**
		 * Synchronizes the data grid with our data model (InterTaskService).
		 * @param	e - DataGridEvent.ITEM_EDIT_END
		 */
		private function syncModel(e:DataGridEvent):void {
			//Check for valid data
			if (parseFloat(e.dataField) == NaN) {
				//Invalid data
				//TODO show message
				return;
			}
			//Put data from view into model
		}
		
		/**
		 * Event handler for when the user clicks the "Main Menu" button
		 * @param	e - MouseEvent.CLICK
		 */
		private function gotoMainMenu(e:MouseEvent):void {
			SystemController.getInstance().animateChangeScreen(this, ScreenIndex.MAIN, true);
		}
		
		/**
		 * Event handler for when the user clicks the "export" button
		 * @param	e - MouseEvent.CLICK
		 */
		private function exportDataGrid(e:MouseEvent):void {
			//TODO
		}
		
		/**
		 * Event handler for when the user clicks the "Import" button
		 * @param	e - MouseEvent.CLICK
		 */
		private function importDataGrid(e:MouseEvent):void {
			//TODO
		}
	}
}