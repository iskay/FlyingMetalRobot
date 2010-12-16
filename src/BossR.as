package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class BossR extends FlxSprite
	{
		[Embed(source = '../media/boss_r.png')] private var Boss_rImage:Class;
		[Embed(source = '../media/damage.mp3')] private var DamageSnd:Class;
		[Embed(source = '../media/boss_r.mp3')] private var Boss_rSnd:Class;
		[Embed(source = '../media/boss_die.mp3')] private var Boss_r_dieSnd:Class;
		
		protected const c_x:int = 32;
		protected const c_y:int = 22;
		protected var d_x:int;
		protected var d_y:int;
		
		protected var damage_snd:FlxSound;
		protected var boss_r_snd:FlxSound;
		protected var sound_timer:Number = 8;
		
		protected var d_timer:Number = 2;
		public var side:int;
				
		public function BossR(Side:int, MaxV:int) 
		{
			super();
			loadGraphic(Boss_rImage, true, false, 66, 42);
			exists = false;
			dead = true;
			
			width = 62;
			height = 28;
			offset.x = 2;
			offset.y = 8;
			
			//animations
			addAnimation("fly", [0, 1], 12); 
			
			maxVelocity.x = maxVelocity.y = MaxV;
			side = Side;
			
			damage_snd = new FlxSound();
			  damage_snd.loadEmbedded(DamageSnd);
			boss_r_snd = new FlxSound();
			  boss_r_snd.loadEmbedded(Boss_rSnd);
		}
		
		public override function update():void
		{
			if (exists == false) return;
			else
			{	
				//moves towards random destination point
				super.update();
				if (!flickering()) this.color = 0xFFFFFF;
				play("fly");
				//if (x <= GameState.cam_tracker.x - Glob.SCREEN_WIDTH) kill();
				
				d_timer -= FlxG.elapsed * FlxU.random();
				if (d_timer <= 0)
				{
					//pick new destination point
					if (x < GameState.cam_tracker.x) d_x = GameState.cam_tracker.x + Glob.SCREEN_WIDTH;
					else d_x = GameState.cam_tracker.x - Glob.SCREEN_WIDTH;
					d_y = int(FlxU.random() * Glob.SCREEN_HEIGHT);
					d_timer = 2;
				}
				var delta_y:int = d_y - (y + c_y);
				var delta_x:int = d_x - (x + c_x);
				velocity.x = delta_x; velocity.y = delta_y;
				//if (y < 0) y = 0;
				//if (y > (y - height)) y = y - height
				
				sound_timer -= FlxG.elapsed;
				if (sound_timer <= 0)
				{
					sound_timer = 8;
					boss_r_snd.play();
				}
			}
		}
		
		public override function kill():void
		{
			if (!onScreen()) { super.kill(); return;}
			if (!flickering())
			{
				if (health > 1)
				{
					this.color = 0xFFDDDD;
					flicker(0.5);
					health --;
					damage_snd.play();
					/*if (bazooka)
					{
						health -= 3;
						if (health < 1) health = 1;
					}*/
				}
				else if (health <= 1)
				{
					exists = false;
					FlxG.play(Boss_r_dieSnd);
					var exp:Exp_b = GameState.grpExp_b.getFirstDead() as Exp_b;
					if (exp != null) exp.explode(x, y);
					for (var i:int = 0; i < 2; i++)
					{
						if (GameState.grpBigEmit_r.members[i] != null)
						{
							if (GameState.grpBigEmit_r.members[i].on == false)
							  {GameState.grpBigEmit_r.members[i].startBurst(x, y); break;}
						}
					}
					GameState.bosses_killed ++;
					GameState.fighting_boss --;
					super.kill();
				}
			}
		}
		
		public function setInPlay():void
		{
			var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;			
			if (side == 1) reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
			else reset(GameState.cam_tracker.x - Glob.SCREEN_WIDTH, rand_y);
			velocity.x = -10 - FlxU.random() * 40;
			health = 12 + 3 * GameState.bosses_killed;
		}
		
	}
	
}