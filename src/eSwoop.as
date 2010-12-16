package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class eSwoop extends FlxSprite
	{
		[Embed(source = '../media/enemy6.png')] private var Enemy6Image:Class;
		
		private var swoop_timer:Number = 1;

		public function eSwoop() 
		{
			super();
			loadGraphic(Enemy6Image, true, false, 16, 16);
			exists = false;
			dead = true;
			
			width = 12;
			height = 12;
			offset.x = 2;
			
			maxVelocity.x = 40;
			maxVelocity.y = 50;
			
			//animations
			addAnimation("fly", [0, 1, 0, 2], 10);
		}
		
		public override function update():void
		{
			
			if (exists == false) return;
			else
			{	
				swoop_timer -= FlxG.elapsed;
				if (swoop_timer <= 0 && FlxU.random() < 0.4)
				{
					acceleration.y = 200 * FlxU.random() - 100;
					velocity.x += (FlxU.random() * 24) - 12;
				}
				if (y < 0 || y > Glob.SCREEN_HEIGHT - Glob.BLOCK_DIM) velocity.y *= -1;
				
				super.update();
				if (GameState.fighting_boss > 0) kill();
				if (!flickering()) this.color = 0xFFFFFF;
				play("fly");
				if (x <= GameState.cam_tracker.x - Glob.SCREEN_WIDTH) kill();
				//velocity.y = Math.cos(x % 64);
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
						if (GameState.grpEmit_r.members[i] != null)
						{
							if (GameState.grpEmit_r.members[i].on == false)
							  {GameState.grpEmit_r.members[i].startBurst(x, y); break;}
						}
					}
					GameState.increaseKillCount();
					super.kill();
				}
			}
		}
		
		public function setInPlay():void
		{
			//var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;
			var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT);
			reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
			velocity.x = -15 - FlxU.random() * 25;
			health = 2 + int(GameState.bosses_killed / 4);
		}
		
	}
	
}