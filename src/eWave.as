package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class eWave extends FlxSprite
	{
		[Embed(source = '../media/enemy3.png')] private var Enemy3Image:Class;
		
		protected var y_base:int;
		
		
		public function eWave() 
		{
			super();
			loadGraphic(Enemy3Image, true, false, 16, 16);
			exists = false;
			dead = true;
			
			width = 12;
			height = 12;
			offset.x = 2;
					
			//animations
			addAnimation("fly", [0, 1], 10);
		}
		
		public override function update():void
		{
			if (exists == false) return;
			else
			{	
				var x_rad:Number = (x % 180 * 2) * Math.PI / 180;
				y = y_base + (32 * Math.cos(x_rad));
				super.update();
				if (GameState.fighting_boss > 0) kill();
				if (!flickering()) this.color = 0xFFFFFF;
				play("fly");
				if (x <= GameState.cam_tracker.x - Glob.SCREEN_WIDTH) kill();
			}
		}
		
		public override function kill():void
		{
			if (dead || !exists) return;
			if (!onScreen()) { super.kill(); return;}
			if (!flickering())
			{
				if (health > 1)
				{
					this.color = 0xDDDDDD;
					flicker(0.25);
					FlxG.flash.start(0x40ffffff, 0.25);
					health --;
				}
				else if (health <= 1)
				{
					exists = false;
					var exp:Exp_s = GameState.grpExp_s.getFirstDead() as Exp_s;
					if (exp != null) exp.explode(x, y);
					FlxG.flash.start(0x80ffffff, 0.4);
					for (var i:int = 0; i < 3; i++)
					{
						if (GameState.grpEmit_g.members[i] != null)
						{
							if (GameState.grpEmit_g.members[i].on == false)
							  {GameState.grpEmit_g.members[i].startBurst(x, y); break;}
						}
					}
					GameState.increaseKillCount();
					super.kill();
				}
			}
		}
		
		public function setInPlay():void
		{		
			y_base = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;
			if ((y_base + 32) >= (Glob.SCREEN_HEIGHT - Glob.BLOCK_DIM)) y_base = Glob.SCREEN_HEIGHT - Glob.BLOCK_DIM - 32;
			if ((y_base - 32) <= 0) y_base = 32;
			
			reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, y_base);
			velocity.x = -25 - FlxU.random() * 25;
			health = 1 + int(GameState.bosses_killed / 4);
		}
		
	}
	
}