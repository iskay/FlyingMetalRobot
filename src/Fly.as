package  
{
	
	import org.flixel.*;
	[SWF(width = "768", height = "384", backgroundColor = "#000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Fly extends FlxGame
	{
		
		public function Fly() 
		{
			//super(Glob.SCREEN_WIDTH, Glob.SCREEN_HEIGHT, GameState, 2);
			super(Glob.SCREEN_WIDTH, Glob.SCREEN_HEIGHT, TitleState, 2);
		}
		
	}
	
}