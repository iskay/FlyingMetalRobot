package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class TitleState extends FlxState
	{
		[Embed(source = '../media/title.png')] private var TitleImage:Class;
		[Embed(source = '../media/presents.png')] private var PresentsImage:Class;
		[Embed(source = '../media/to_start.png')] private var To_startImage:Class;
		[Embed(source = '../media/presents.mp3')] private var PresentsSnd:Class;
		[Embed(source = '../media/title.mp3')] private var TitleSnd:Class;
		[Embed(source = '../media/start.mp3')] private var StartSnd:Class;
		
		protected static var timer:Number = 3;
		protected static var title:FlxSprite;
		protected static var presents:FlxSprite;
		protected static var to_start:FlxSprite;
		protected static var presents_snd:FlxSound;
		protected static var title_snd:FlxSound;
		protected static var start_snd:FlxSound;
		
		public function TitleState() 
		{
			super();
		}
		
		public override function create():void
		{
			title = new FlxSprite(0, 0, TitleImage);
			  title.exists = false;
			  this.add(title);
			presents = new FlxSprite(0, 0, PresentsImage);
			  presents.x = Glob.SCREEN_WIDTH / 2 - presents.width / 2;
			  presents.y = Glob.SCREEN_HEIGHT / 2 - presents.height / 2 - 16;
			  this.add(presents);
			to_start = new FlxSprite();
			  to_start.loadGraphic(To_startImage, true, false, 261, 17);
			  to_start.exists = false;
			  to_start.x = 65; to_start.y = 154;
			  this.add(to_start);
			  to_start.addAnimation("flash", [0, 1, 2, 1], 8);
			  
			presents_snd = new FlxSound();
			  presents_snd.loadEmbedded(PresentsSnd);
			title_snd = new FlxSound();
			  title_snd.loadEmbedded(TitleSnd, true);
			start_snd = new FlxSound();
			  start_snd.loadEmbedded(StartSnd);
			  start_snd.survive = true;
			  
			FlxG.flash.start(0xff000000, 1, null, true);
			presents_snd.play();
		}
		
		public override function update():void
		{
			if (timer != -1) timer -= FlxG.elapsed;
			if (timer <= 0 && timer != -1)
			{
				timer = -1;
				FlxG.flash.start(0xff000000, 2.5, null, false);
				presents.exists = false;
				title.exists = true;
				to_start.exists = true;
				to_start.play("flash");
				title_snd.play();
			}
			
			if (timer == -1)
			{
				if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C"))
				{
					start_snd.play();
					title_snd.stop();
					FlxG.state = new GameState();
					FlxG.flash.start(0xff000000, 1, null, false);
					
				}
			}
			super.update();
		}
	}
	
}