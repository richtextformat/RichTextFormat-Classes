package uk.co.richtextformat.localisation
{
	public class BindableProperty
	{
		private var _site:Object;
		private var _property:String;
		private var _chain:String;
		
		public function BindableProperty ( site:Object, property:String, chain:String )
		{
			_site = site;
			_property = property;
			_chain = chain;
		//	trace('BindableProperty',_site,_property,_chain)
		}
		
		public function get site ():Object { return _site; }
		public function get property ():String { return _property; }
		public function get chain ():String { return _chain; }
	}
}