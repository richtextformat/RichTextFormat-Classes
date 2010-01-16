package uk.co.richtextformat.localisation
{
	public class MXMLParser
	{
		public static function parseLanguage (languageSource:XML):Object
		{
			return _parseLanguageChild( languageSource, new Object() );
		}
		
		
		
		
		
		
		
		// todo make sure this parser can cope with html content in the same way the ASParser can
		
		// recursive method that turns xml nodes into hierarchies of objects
		private static function _parseLanguageChild (languageSource:XML, language:Object):Object
		{
			var childObj:Object;
			var childName:String;
			var childID:XMLList;
			var children:XMLList = languageSource.children();
			var child:XML;
			var len:int = children.length();
		 
			// go thru xml child nodes
			for (var i:int=0; i<len; i++){
		 
				// create next object name. combine name and id attribute as _camelCased string if we've got an id attr.
				child = children[i] as XML;
				childName = child.name().toString();
				childID = child.attribute("id");
				if (childID.length() == 1){ childName = _camelCase( [childName, childID.toString()] ); }
		 		
				// do different things with different node types
				switch (true){
		 
					// actual text content: store it
					case child.hasSimpleContent():
						language[childName] = child.toString();
						break;
		 
					// we've got a nodename or property name that already exists in the object tree: warn and break out
					case language.hasOwnProperty(childName):
						throw new Error('MXMLParser ERROR: childnode ' + childName + ' already exists, forbidding overwrite! ALL YOUR XML NAMES MUST BE UNIQUE');
						break;
		 
					// this node has child nodes: recurse the child
					default:
						childObj = new Object();
						language[childName] = childObj;
						_parseLanguageChild(child, childObj);
						break;
					}
				}
			return language;
		}
		 
		private static function _camelCase ( strings:Array ):String
		{
			var s:String = strings[0].toString().toLowerCase();
			var i:int = 0;
			var len:int = strings.length;
			while (++i < len){ s += _capitalise(strings[i]); }
			return s;
		}
		 
		private static function _capitalise ( string:String ):String
		{
			return string.substring(0,1).toUpperCase() + string.substring(1, string.length)
		}
	}
}