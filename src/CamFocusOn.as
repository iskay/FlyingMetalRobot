package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class CamFocusOn extends FlxSprite
	{
		
		public function CamFocusOn() 
		{
			super();
			//super(192 - 4, 96 - 4);
			createGraphic(8, 8, 0xffff00ff);
			x = Glob.SCREEN_WIDTH / 2 - width / 2;
			y = Glob.SCREEN_HEIGHT / 2 - height / 2;
			velocity.x = Glob.CAM_SPEED;
		}
		
		public override function update():void
		{
			super.update();
		}
		
	}
	
}