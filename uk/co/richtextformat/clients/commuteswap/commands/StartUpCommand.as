package uk.co.richtextformat.clients.commuteswap.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class StartUpCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			trace('StartupCommand execute',note.toString());
			//var app:CommuteSwap = note.getBody() as CommuteSwap;
			//facade.registerMediator(new ApplicationMediator(app));
		}
	}
}