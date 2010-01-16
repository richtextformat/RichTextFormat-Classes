package uk.co.richtextformat.clients.richtextformat.cellularAutomata.grids
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	
	import uk.co.richtextformat.clients.richtextformat.cellularAutomata.events.SwitchEvent;
	
	public class MultiGrid extends AbstractGrid implements IGrid
	{
		public var currentGrid:Array;
		public var nextGrid:Array;
		
		private var _binaryGrid:BinaryGrid;
		private var _maxGradiations:int;
		
		public static const MULTI_GRID_AT_FIRST_ROW:String = 'multigridatfirstrow';
		
		public static const TOP:String = 'startwhite';
		public static const MIDDLE:String = 'startgray';
		public static const BOTTOM:String = 'startblack';
		
		
		
		
		public function MultiGrid (width:int, height:int, maxGradiations:int = 6, start:String = TOP)
		{
			_init(width, height, maxGradiations, start);
		}
		
		private function _init (width:int, height:int, maxGradiations:int, start:String):void
		{
			this.width = width;
			this.height = height;
			_maxGradiations = maxGradiations - 1;
			
			_createGrids(start);
		}
		
		private function _createGrids (start:String):void
		{
			_binaryGrid = new BinaryGrid(width, height);
			_binaryGrid.addEventListener(SwitchEvent.TOGGLED, _onSwitchToggled);
			currentGrid = new Array(width);
			nextGrid = new Array(width);
			
			var startingFigure:int;
			switch (start) {
				case MIDDLE:		startingFigure = int(_maxGradiations/2);		break;
				case BOTTOM:		startingFigure = 0;								break;
				default:			startingFigure = _maxGradiations;				break;
			}
			
			var i:int = -1;
			var j:int;
			while (++i<width){
				currentGrid[i] = new Array(height);
				nextGrid[i] = new Array(height);
				
				// pop multi grids with default values (starting colour)
				j = -1;
				while (++j<height){
					currentGrid[i][j] = startingFigure;
					nextGrid[i][j] = startingFigure;
				}
			}
			
			// init switches with random binary values
			_binaryGrid.randomiseSwitches();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function calculateNextRow ():void
		{
			_binaryGrid.calculateNextRow();
			
			// increment row count 
			if (_binaryGrid.currentRow == 0){
				_incrementGrids();
				dispatchEvent( new Event( MULTI_GRID_AT_FIRST_ROW) )
			}
			
			var i:int = -1;
			var bin:int;
			var nextMulti:int;
			var tooHigh:int = _maxGradiations+1;
			
			while (++i<width){
				
				// get the 3 vals
				bin = _binaryGrid.grid[i][_binaryGrid.currentRow];
				nextMulti = nextGrid[i][_binaryGrid.currentRow];
				
				// can we change the value?
				switch (bin + nextMulti){
					
					// no: its already either at 0 or _maxGradiations
					case 0:			break;
					case tooHigh:	break;
					
					// yes: ensure bin is 1 or -1 and add
					default:
						if (bin == 0) bin = -1;
						nextGrid[i][_binaryGrid.currentRow] += bin;
						break;
				}
				
				//trace(['_calcNextMultiRow ',i, prevMulti, _nextMulti[i][_binaryGrid.currentRow] ]);
			}
		}
		
		public function randomiseSwitches ():void
		{
			_binaryGrid.randomiseSwitches();
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function _incrementGrids ():void
		{
			//trace("_incrementGrids ");
			
			// overwrite prev with curr and curr with next
			var i:int = -1;
			var j:int;
			while (++i<width){
				j = -1;
				while (++j<height){
					currentGrid[i][j] = nextGrid[i][j];
				}
			}
			
			//traceGrid(_prevMultiGrid);
			//traceGrid(_currMultiGrid);
			//traceGrid(_nextMultiGrid);
		}
		
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// listeners
		
		private function _onSwitchToggled (event:SwitchEvent):void
		{
			dispatchEvent(event);
		}
		
		override protected function _initialise (event:TimerEvent):void
		{
			//trace('init' );
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
		
		
		
		
		
		
		
		
		
		public function get currentRow ():int
		{
			return _binaryGrid.currentRow;
		}
		
		public function get iterations ():int
		{
			return _binaryGrid.iterations;
		}
		
		public function get previousRow ():int
		{
			return _binaryGrid.previousRow;
		}
	}
}