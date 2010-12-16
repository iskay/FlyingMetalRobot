package  
{
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class BazHelper extends FlxObject
	{
		
		public function BazHelper() 
		{
			super(0, 0, 72, 72);
			//createGraphic(72, 72, 0xffff00ff);
			dead = true;
			//GameState.grpBaz.add(this);
		}
		
		public override function kill():void
		{
			//
		}
		
	}
	
}