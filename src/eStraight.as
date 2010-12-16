package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class eStraight extends FlxSprite
	{
		[Embed(source = '../media/enemy1.png')] private var Enemy1Image:Class;
		[Embed(source = '../media/enemy2.png')] private var Enemy2Image:Class;
		
		public var type:int;
		
		public function eStraight() 
		{
			super();
			if (FlxU.random() > 0.5) { loadGraphic(Enemy1Image, true, false, 16, 16); type = 0; }
			else { loadGraphic(Enemy2Image, true, false, 16, 16); type = 1; }
			exists = false;
			dead = true;
			
			width = 12;
			height = 12;
			offset.x = 2;
			
			//animations
			addAnimation("fly", [0, 1], 6); 			//this.color = 0x0F88FF;
			
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
					var i:int;
					if (type == 0)
					{
						for (i = 0; i < 3; i++)
						{
							if (GameState.grpEmit_g.members[i] != null)
							{
								if (GameState.grpEmit_g.members[i].on == false)
								  {GameState.grpEmit_g.members[i].startBurst(x, y); break;}
							}
						}
					}
					else
					{
						for (i = 0; i < 3; i++)
						{
							if (GameState.grpEmit_b.members[i] != null)
							{
								if (GameState.grpEmit_b.members[i].on == false)
								  {GameState.grpEmit_b.members[i].startBurst(x, y); break;}
							}
						}
					}
					GameState.increaseKillCount();
					super.kill();
				}
			}
		}
		
		public function setInPlay():void
		{
			var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;			
			reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
			velocity.x = -10 - FlxU.random() * 40;
			if (type == 0) health = 1 + int(GameState.bosses_killed / 4);
			else health = 2 + int(GameState.bosses_killed / 4);
		}
		
	}
	
}