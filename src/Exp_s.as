package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Exp_s extends FlxSprite
	{
		[Embed(source = '../media/exp_s.png')] private var Exp_sImage:Class;
		
		
		public function Exp_s() 
		{
			super();
			loadGraphic(Exp_sImage, true, false, 16, 16);
			addAnimation("boom", [0, 1, 2, 3, 4, 5], 20, false);
			
			exists = false; dead = true;
		}
		
		override public function update():void
		{
			if(dead) return;
			else
			{
				//play("boom");
				super.update();
				if (finished) { dead = true; exists = false;}
			}
		}
		
		public function explode(X:int, Y:int):void
		{
			x = X; y = Y;
			exists = true; dead = false;
			play("boom", true);
			GameState.playExp_sSnd();
		}
		
	}
	
}