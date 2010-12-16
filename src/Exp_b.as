package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Exp_b extends FlxSprite
	{
		[Embed(source = '../media/exp_b.png')] private var Exp_bImage:Class;
		
		
		public function Exp_b() 
		{
			super();
			loadGraphic(Exp_bImage, true, false, 64, 64);
			addAnimation("boom", [0, 1, 2, 3, 4, 5, 6], 16, false);
			
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
			GameState.playExp_bSnd();
		}
	}
	
}