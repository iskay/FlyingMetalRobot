package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class PowerUp extends FlxSprite
	{
		[Embed(source = '../media/pow_tri.png')] private var Pow_triImage:Class;
		[Embed(source = '../media/pow_baz.png')] private var Pow_bazImage:Class;
		//[Embed(source = '../media/pickup.mp3')] private var PickupSnd:Class;
		[Embed(source = '../media/get_shell.mp3')] private var Get_shellSnd:Class;
		
		public var type:int;
		
		public function PowerUp(Type:int) 
		{
			type = Type;
			super();
			if (type == 0) loadGraphic(Pow_triImage, true, false, 16, 16);
			else loadGraphic(Pow_bazImage, true, false, 16, 16);
			width = 12; offset.x = 2;
			
			addAnimation("idle", [0, 1, 2, 1], 6);
			exists = false;
			fixed = true; moves = false;
		}
		
		public override function update():void
		{
			if (!exists) return;
			else
			{
				play("idle");
				super.update();
			}
		}
	
		public function pickedUp(Object1:FlxObject,Object2:FlxObject):void
		{
			if (type == 0)
			{
				GameState.player.poweredUp = true;
				GameState.player.flicker(0.5);
				GameState.pow_effect_timer = Glob.POW_EFFECT_TIME;
			}
			else
			{
				GameState.player.shells ++;
				if (GameState.player.shells > 10) GameState.player.shells = 10;
			}
			//if (type == 0) FlxG.play(PickupSnd);
			//else FlxG.play(Get_shellSnd);
			FlxG.play(Get_shellSnd);
			exists = false;
		}
		
		public function setInPlay():void
		{
			var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;			
			reset((GameState.cam_tracker.x - GameState.cam_tracker.x % 16) + 2 + Glob.SCREEN_WIDTH, rand_y);
			for each (var block:FlxTileblock in GameState.lyrStage.members)
				  if (block != null)
				    //if (block.overlapsPoint(x + 8, y + 8)) { exists = false; break;}
					FlxU.overlap(block, this, onOverlap);

		}
		
		public function onOverlap(Obj1:FlxObject, Obj2:FlxObject):void
		{
			//x = y = 0;
			this.reset(0, 0);
			exists = false;
		}
	}
	
}