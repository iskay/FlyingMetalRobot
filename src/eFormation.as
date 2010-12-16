package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class eFormation extends FlxSprite
	{
		[Embed(source = '../media/enemy4.png')] private var Enemy4Image:Class;
		
		public function eFormation() 
		{
			super();
			loadGraphic(Enemy4Image, true, false, 16, 16);
			exists = false;
			dead = true;
			
			width = 12;
			height = 12;
			offset.x = 2;
			
			//animations
			addAnimation("fly", [0, 1], 8);
		}

		public override function update():void
		{
			if (exists == false) return;
			else
			{	
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
		
		public function setInPlay(position:int, Y:int):void
		{
			//var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;			
			reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH + Math.abs(position) * Glob.BLOCK_DIM, Y + position * Glob.BLOCK_DIM);
			velocity.x = -35;
			health = 1 + int(GameState.bosses_killed / 4);
		}
		
	}
	
}