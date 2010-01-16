package uk.co.richtextformat.clients.richtextformat.cellularAutomata.grids
{
	public interface IGrid
	{
		function calculateNextRow ():void;
		function populateGrid (frameRate:int):void;
		function randomiseSwitches ():void;
	}
}