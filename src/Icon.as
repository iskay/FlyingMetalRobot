package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Icon extends FlxSprite
	{
		[Embed(source = '../media/icon.png')] private var IconImage:Class;
		
		public var full:Boolean = false;
		
		public function Icon(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(IconImage, true, false, 16, 16);
			
			addAnimation("empty", [0]);
			addAnimation("full", [1]);
		}
		
		public override function update():void
		{
			if (full) play("full", true);
			else play("empty", true);
			super.update();
		}
		
	}
	
}