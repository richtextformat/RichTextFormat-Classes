package uk.co.richtextformat.utils
{
	import flash.display.DisplayObjectContainer;
	
	public class FlashStatics
	{
		public static function removeChild (parent:DisplayObjectContainer, child:DisplayObjectContainer):Boolean
		{
			var success:Boolean = true;
			
			try {
				parent.removeChild(child);
				
			} catch (e:Error){
				success = false;
			}
			
			return success;
		}
		
		public static function camelCase ( strings:Array, forceToLowerCase:Boolean = true ):String
		{
			var s:String = strings[0].toString()
			if (forceToLowerCase){
				s = s.toLowerCase();
			}
			var i:int = 0;
			var len:int = strings.length;
			while (++i<len){
				s += capitalise( strings[i], forceToLowerCase );
			}
			
			return s;
		}
		
		public static function capitalise ( string:String, forceToLowerCase:Boolean = true ):String
		{
			var newString:String = string.substring(0,1).toUpperCase();
			var suffix:String = string.substring(1, string.length)
			newString += forceToLowerCase? suffix.toLowerCase() : suffix;
			return newString;
		}
	}
}