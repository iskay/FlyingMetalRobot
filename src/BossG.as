package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class BossG extends FlxSprite
	{
		[Embed(source = '../media/boss_g.png')] private var Boss_gImage:Class;
		[Embed(source = '../media/damage.mp3')] private var DamageSnd:Class;
		[Embed(source = '../media/boss_g.mp3')] private var Boss_gSnd:Class;
		[Embed(source = '../media/boss_die.mp3')] private var Boss_g_dieSnd:Class;
		
		protected const c_x:int = 28;
		protected const c_y:int = 18;
		protected var damage_snd:FlxSound;
		protected var boss_g_snd:FlxSound;
		protected var sound_timer:Number = 8;
		
		public var side:int;
		
		public function BossG(Side:int, MaxV:int) 
		{
			super();
			loadGraphic(Boss_gImage, true, false, 54, 36);
			exists = false;
			dead = true;
			
			width = 44;
			height = 32;
			offset.x = 5;
			offset.y = 2;
			
			//animations
			addAnimation("fly", [0, 1], 12); 
			
			maxVelocity.x = maxVelocity.y = MaxV;
			side = Side;
			
			damage_snd = new FlxSound();
			  damage_snd.loadEmbedded(DamageSnd);
			boss_g_snd = new FlxSound();
			  boss_g_snd.loadEmbedded(Boss_gSnd);
		}
		
		public override function update():void
		{
			if (exists == false) return;
			else
			{	
				//seeks out player slowly
				super.update();
				if (!flickering()) this.color = 0xFFFFFF;
				play("fly");
				var delta_y:int = GameState.player.y + 8 - (y + c_y);
				var delta_x:int = GameState.player.x + 8 - (x + c_x);
				velocity.x = delta_x; velocity.y = delta_y;
				
				sound_timer -= FlxG.elapsed;
				if (sound_timer <= 0)
				{
					sound_timer = 8;
					boss_g_snd.play();
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
					FlxG.play(Boss_g_dieSnd);
					var exp:Exp_b = GameState.grpExp_b.getFirstDead() as Exp_b;
					if (exp != null) exp.explode(x, y);
					for (var i:int = 0; i < 2; i++)
					{
						if (GameState.grpBigEmit_g.members[i] != null)
						{
							if (GameState.grpBigEmit_g.members[i].on == false)
							  {GameState.grpBigEmit_g.members[i].startBurst(x, y); break;}
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