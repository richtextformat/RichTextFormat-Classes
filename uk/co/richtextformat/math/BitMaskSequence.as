package uk.co.richtextformat.math
{
	public class BitMaskSequence
	{
		public function BitMaskSequence ()
		{
			throw new Error("uk.co.richtextformat.math.BitMaskSequence must not be directly instantiated");
		}
		
		public static function encode (indices:Array):int
		{
			//trace('encode', indices);
			var sum:int = 0;
			
			var len:int = indices.length;
			for (var i:int=0; i<len; i++){
				sum += ( 1 << int(indices[i]) );
			}
			
			return sum;
		}
		
		public static function decode (sum:int):Array
		{
			var indices:Array = new Array();
			var count:int = 1;
			var index:int = 0;
			
			while (sum > 0){
				while ( (count = count<<1) <= sum ) { ++index; }
				count = count>>1;
				sum -= count;
				indices.unshift(index);
				count = 1;
				index = 0;
			}
			
			return indices;
		}
	}
}