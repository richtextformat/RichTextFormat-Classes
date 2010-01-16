package uk.co.richtextformat.clients.richtextformat.cellularAutomata.grids
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	
	import uk.co.richtextformat.clients.richtextformat.cellularAutomata.events.SwitchEvent;
	import uk.co.richtextformat.math.Random;
	
	public class BinaryGrid extends AbstractGrid implements IGrid
	{
		public var state:String;
		public var iterations:int;
		public var previousRow:int;
		public var currentRow:int;
		
		public var grid:Array;
		public var switches:SwitchArray;
		
		public static const INITING:String = 'INITING';
		public static const RUNNING:String = 'RUNNING';
		public static const PAUSED:String = 'PAUSED';
		
		
		
		
		
		
		// -------------------------------------------------------------
		// construct
		
		public function BinaryGrid (width:int, height:int)
		{
			_init(width, height);
		}
		
		private function _init (width:int, height:int):void
		{
			//trace("binarygrid _init: ");
			
			state = INITING;
			this.width = width + 2;
			this.height = height;
			iterations = -1;
			
			_createGrid();
			_createSwitches();
			
			//populateGrid();
		}
		
		private function _createGrid ():void
		{
			grid = new Array(width);
			
			var i:int = -1;
			while (++i<width){
				grid[i] = new Array(height);
			}
			
			// row id needs to be set to the last row (so it starts on the first row)
			currentRow = height-1;
			
			// create random bottom line of binary numbers in the grid
			i = -1;
			var len:int = width;
			var row:int = height-1;
			while(++i<len){
				grid[i][row] = Random.generate(0,1,Random.INTEGER);
			}
		}
		
		private function _createSwitches ():void
		{
			switches = new SwitchArray();
			switches.addEventListener(SwitchEvent.TOGGLED, _onSwitchToggled);
			randomiseSwitches();
		}
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// public
		
		public function calculateNextRow ():void
		{
			// calc rows ids
			if (++currentRow == height){
				++iterations;
				currentRow = 0;
			}
			previousRow = (height + currentRow - 1) % height;
			
			//trace(" _calcNextBinaryRow START ",previousRow,currentRow);
			
			//*
			// calc new row
			var i:int = 0;
			var len:int = width-1;
			//trace('_calcNextBinaryRow', previousRow, currentRow, len)
			while (++i<len){
				//trace(i, previousRow);
				//trace('_calcNextBinaryRow', previousRow, currentRow, grid[i-1][previousRow], grid[i][previousRow], grid[i+1][previousRow])
				//trace('_calcNextBinaryRow', previousRow, currentRow, i, width);
				//trace('_calcNextBinaryRow', grid[i-1][previousRow]);
				//trace('_calcNextBinaryRow', grid[i][previousRow]);
				//trace('_calcNextBinaryRow', grid[i+1][previousRow]);
				grid[i][currentRow] = switches.switches	[ grid[i-1]	[previousRow] ]
														[ grid[i]	[previousRow] ]
														[ grid[i+1]	[previousRow] ];
				//trace('grid[i][currentRow]', grid[i][currentRow]);
			}
			
			grid[0][currentRow] = 0;
			grid[grid.length-1][currentRow] = 0;
			
			//trace("CellularAutomata _calcNextRow END  : "+( getTimer() - time)  );
			//*/
			
			// flip a switch on the way out?
			switches.tryToggleSwitch();
		}
		
		public function randomiseSwitches ():void
		{
			switches.randomiseSwitches();
		}
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// listeners
		
		private function _onSwitchToggled (event:SwitchEvent):void
		{
			dispatchEvent(event);
		}
		
		override protected function _initialise (event:TimerEvent):void
		{
			trace('init' );
			var i:int = -1;
			var len:int = int(MAX_FLAGS_TO_CALCULATE_PER_FRAME / width);
			while (++i<len){
				
				if ( currentRow+1 == height && iterations == 1){
					_timer.stop();
					dispatchEvent( new Event(Event.COMPLETE) );
					break;
					
				} else {
					//trace('init mult', (currentRow + (height * iterations) ) / ( height * 2 ) );
					calculateNextRow();
					var progress:int =  int( 100 * ( ( currentRow + (height * iterations) ) / ( height * 2 ) ) );
					dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, progress, 100) );
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// debug
		
		private function traceGrid ():void
		{
			var i:int = -1;
			var len:int = grid.length;
			while (++i<len){
				trace(grid[i]);
			}
			trace(" "); 
		}
	}
}