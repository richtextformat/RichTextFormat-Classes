package uk.co.richtextformat.flex.utils
{
	import flash.display.DisplayObject;
	
	import mx.collections.ListCollectionView;
	import mx.states.RemoveChild;
	import mx.states.State;
	
	public class FlexStatics
	{
		public static function cloneListCollectionView (collection:ListCollectionView, collectionType:Class):ListCollectionView
		{
			var newCollection:ListCollectionView = new collectionType();
			for each (var object:Object in collection) newCollection.addItem(object);
			return newCollection;
		}
		
		public static function createState (stateID:String, removes:Array):State
		{
			var state:State = new State();
			state.name = stateID;
			
			// add a RemoveChild instance for every display object passed
			var len:int = removes.length;
			for (var i:int=0; i<len; i++) state.overrides.push( new RemoveChild( removes[i] as DisplayObject ) );
			
			return state;
		}
	}
}