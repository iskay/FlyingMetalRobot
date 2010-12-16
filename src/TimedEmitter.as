package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class TimedEmitter extends FlxEmitter
	{
		[Embed(source = '../media/gibs_r.png')] private var Gibs_rImage:Class;
		[Embed(source = '../media/gibs_g.png')] private var Gibs_gImage:Class;
		[Embed(source = '../media/gibs_b.png')] private var Gibs_bImage:Class;
		[Embed(source = '../media/big_gibs_r.png')] private var Big_gibs_rImage:Class;
		[Embed(source = '../media/big_gibs_g.png')] private var Big_gibs_gImage:Class;
		
		public var type:int = 0;
		protected var on_timer:Number = -1;
		
		public function TimedEmitter(Type:int) 
		{
			type = Type;
			super();
			switch (type)
			{
				case 0:
				  createSprites(Gibs_rImage, 8, 16, true, 0);
				  setSize(Glob.BLOCK_DIM, Glob.BLOCK_DIM);
				  break;
				case 1:
				  createSprites(Gibs_gImage, 8, 16, true, 0);
				  setSize(Glob.BLOCK_DIM, Glob.BLOCK_DIM);
				  break;
				case 2:
				  createSprites(Gibs_bImage, 8, 16, true, 0);
				  setSize(Glob.BLOCK_DIM, Glob.BLOCK_DIM);
				  break;
				case 3:
				  createSprites(Big_gibs_rImage, 16, 16, true, 0);
				  setSize(62, 28);
				  break;
				case 4:
				  createSprites(Big_gibs_gImage, 16, 16, true, 0);
				  setSize(44, 32);
				  break;
			}
			
			setYSpeed(0, -150);
			on = false;
		}
		
		public override function update():void
		{
			super.update();
			if (on_timer == -1) return;
			on_timer -= FlxG.elapsed;
			if (on_timer <= 0)
			{
				on_timer = -1;
				stop(1);
			}
		}
		
		public function startBurst(X:int, Y:int):void
		{
			x = X; y = Y;
			start(false, 0.01, 8);
			on_timer = 0.5;
		}
		
	}
	
}