package uk.co.richtextformat.localisation
{
	public class ASParser
	{
		private static var _language:Object;
		
		public static function parseLanguage (languageSource:XML):Object
		{
			_language = new Object();
			_parseLanguageChild(languageSource);
			return _language;
		}
		
		
		
		
		
		
		
		private static function _parseLanguageChild (languageSource:XML):void
		{
			var children:XMLList = languageSource.children();
			var child:XML;
			var propertyName:String;
			var len:int = children.length();
			var hasHTMLContent:Boolean = _hasHTMLContent(children);
			
			// go thru xml child nodes 
			for (var i:int=0; i<len; i++){
				child = children[i] as XML;
				
				// actual content
				switch (true)
				{
					// HTML or simple content found: store as value
					case hasHTMLContent:
					case child.hasSimpleContent():
					
						// create next object name. combine name and id attribute as _camelCased string if we've got an id attr.
						propertyName = _constructPropertyName(child, hasHTMLContent);
						
						// reject duplicate values
						if ( _language[propertyName] ) throw new Error('ASParser ERROR: childnode ' + propertyName + 
															' already exists, forbidding overwrite! ALL YOUR XML NAMES MUST BE UNIQUE');
						
						// save unique values
						_language[propertyName] = child.toString();
					//	trace('_parseLanguageChild property:', propertyName, _language[propertyName])
						break;
					
					// recurse child nodes
					default:
						_parseLanguageChild(child);
						break;
				}
			}
		}
		
		private static function _constructPropertyName (node:XML, hasHTMLContent:Boolean):String
		{
			var propertyName:String = "";
			var propertyNamePortion:String;
			var parentID:XMLList;
			var id:String;
			
			// whilst we have parent nodes, get them and their 'id' attributes and construct a dot-notated string name from them
			while ( node.parent() ){
				propertyNamePortion = node.name();
				parentID = node.attribute("id");
				
				if (parentID.length() == 1) propertyNamePortion = _camelCase( [propertyNamePortion, parentID.toString()], false );
				
				propertyName = propertyNamePortion + "." + propertyName;
				node = node.parent();
			}
			
			// lose the last dot [or two, if it's html conetnt] and return
			propertyName = propertyName.substring( 0, propertyName.lastIndexOf(".") );
			if (hasHTMLContent) propertyName = propertyName.substring( 0, propertyName.lastIndexOf(".") );
			return propertyName;
		}
		
		private static function _camelCase ( strings:Array, forceToLowerCase:Boolean = true ):String
		{
			var s:String = strings[0].toString()
			if (forceToLowerCase){ s = s.toLowerCase(); }
			
			var i:int = 0;
			var len:int = strings.length;
			while (++i<len) s += _capitalise( strings[i], forceToLowerCase );
			
			return s;
		}
		
		private static function _capitalise ( string:String, forceToLowerCase:Boolean = true ):String
		{
			var newString:String = string.substring(0,1).toUpperCase();
			var suffix:String = string.substring(1, string.length);
			newString += forceToLowerCase? suffix.toLowerCase() : suffix;
			return newString;
		}
		
		private static function _hasHTMLContent ( children:XMLList ):Boolean
		{
			var hasHTMLContent:Boolean = false;
			
			var child:XML = children[0] as XML;
			var childName:String = child.name().toString().toLowerCase();
			var HTMLTags:Array = ['p', 'ul', 'ol', 'font'];
			
			for each (var tag:String in HTMLTags){
				if (tag == childName){
					hasHTMLContent = true;
					break;
				}
			}
			
			return hasHTMLContent;
		}
	}
}