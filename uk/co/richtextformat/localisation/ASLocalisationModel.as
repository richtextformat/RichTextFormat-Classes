package uk.co.richtextformat.localisation
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	// PLEASE READ THE README.txt FILE BEFORE HAVING A LOOK THROUGH THE CODE
	
	public class ASLocalisationModel
	{
		// two objects for storing our languages
		// _language contains the currently selected language
		// _languages contains all the potential languages
		private var _language:DispatchingObject;
		private var _languages:Dictionary;
		
		// we need to store a list of all the binded properties
		private var _bindedProperties:Array;
		
		
		
		
		// constructor
		public function ASLocalisationModel ()
		{
			_init();
		}
		
		// constructor continued
		private function _init ():void
		{
			// create language holders
			_languages = new Dictionary();
			_language = new DispatchingObject();
			
			// listen for language change events
			_language.addEventListener(Event.CHANGE, _onLanguageChange);
		}
		
		// store new languages
		public function addLanguage (language:Object, languageID:String):void
		{
			_languages[languageID] = language;
		}
		
		
		
		
		
		public function changeLanguage (languageID:String):void
		{
			// do we have a language object that matches the passed id?
			var newLanguage:Object = _languages[languageID] as Object;
			
			// yes: apply the new language
			if (newLanguage){
				language = newLanguage;
				
			// no: better let everyone know that this is going to fail
			} else {
				throw new Error('ASLocalisationModel changeLanguage ERROR: no such language exists with the id/name: ' + languageID);
			}
		}
		
		
		
		
		
		private function _onLanguageChange (event:Event):void
		{
			// do we have a list of binded properties?
			if (_bindedProperties){
				
				// yes: go through each one, changing its value
				var bindableProperty:BindableProperty;
				var len:int = _bindedProperties.length;
				for (var i:int=0; i<len; i++){
					bindableProperty = _bindedProperties[i] as BindableProperty;
					_displayBindedProperty(bindableProperty);
				}
			}
		}
		
		public function bindProperty (site:Object, prop:String, chain:String):void
		{
			// create the array if we need to
			if (!_bindedProperties) _bindedProperties = new Array();
			
			// store and display the property to bind
			var bindableProperty:BindableProperty = new BindableProperty(site, prop, chain);
			_displayBindedProperty(bindableProperty);
			_bindedProperties.push(bindableProperty);
		}
		
		private function _displayBindedProperty (bindableProperty:BindableProperty):void
		{
			// display the passed binded property
			bindableProperty.site[bindableProperty.prop] = _language.object[bindableProperty.chain];
		}
		
		
		
		
		
		// the getter and setter for our language
		[Bindable]
		public function get language ():Object { return _language.object; }
		public function set language (language:Object):void { _language.object = language; }
	}
}