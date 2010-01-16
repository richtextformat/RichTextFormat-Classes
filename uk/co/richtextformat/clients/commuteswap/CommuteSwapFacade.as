package uk.co.richtextformat.clients.commuteswap
{
	import uk.co.richtextformat.clients.commuteswap.commands.StartUpCommand;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CommuteSwapFacade extends Facade implements IFacade
	{
		public static const STARTUP:String = "startup";
		
		public function CommuteSwapFacade ( key:String )
		{
			trace('CommuteSwapFacade constr');
			super(key);
		}
		
		public static function getInstance (key:String):CommuteSwapFacade
        {
        	//trace('CommuteSwapFacade getInstance');
            if ( instanceMap[ key ] == null ) instanceMap[ key ] = new CommuteSwapFacade(key);
            return instanceMap[ key ] as CommuteSwapFacade;
        }
		
		override protected function initializeController ():void
		{
			trace('CommuteSwapFacade initializeController');
			super.initializeController();
			registerCommand(STARTUP, StartUpCommand);
		}
		
		public function startUp (app:CommuteSwap):void
		{
			trace('CommuteSwapFacade startup');
			sendNotification(STARTUP, app);
		}
	}
}