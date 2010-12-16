package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class eSeeker extends FlxSprite
	{
		[Embed(source = '../media/enemy5.png')] private var Enemy5Image:Class;
		[Embed(source = '../media/seek.mp3')] private var SeekSnd:Class;
		
		protected var seek_snd:FlxSound;
		
		public function eSeeker() 
		{
			super();
			loadGraphic(Enemy5Image, true, false, 16, 16)
			exists = false;
			dead = true;
			
			width = 12;
			height = 12;
			offset.x = 2;
			
			//animations
			addAnimation("fly", [0, 1], 8); 			//this.color = 0x0F88FF;
			
			maxVelocity.x = maxVelocity.y = 85;
			
			seek_snd = new FlxSound();
			seek_snd.loadEmbedded(SeekSnd, true);
		}
		
		public override function update():void
		{
			if (exists == false) return;
			else
			{	
				super.update();
				if (onScreen()) seek_snd.play();
				if (GameState.fighting_boss > 0) kill();
				if (!flickering()) this.color = 0xFFFFFF;
				play("fly");
				//if (x <= GameState.cam_tracker.x - Glob.SCREEN_WIDTH) kill();
				
				var delta_y:int = (GameState.player.y + 8 - y) * 4;
				var delta_x:int = (GameState.player.x + 8 - x) * 4;
				velocity.x = delta_x; velocity.y = delta_y;
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
					seek_snd.stop();
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
			var rand_x:int = int(FlxU.random() * Glob.SCREEN_WIDTH);
			var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT);
			var rand_side:int = int(FlxU.random() * 4);
			switch (rand_side)
			{
				case 0:	//right
				  reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
				  break;
				case 1:	//left
				  reset(GameState.cam_tracker.x - Glob.SCREEN_WIDTH, rand_y);
				  break;
				case 2:	//top
				  reset(rand_x, GameState.cam_tracker.y - Glob.SCREEN_HEIGHT);
				  break;
				case 3:	//bottom
				  reset(rand_x, GameState.cam_tracker.y + Glob.SCREEN_HEIGHT);
				  break;
				default:
				  reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
			}
			//reset(GameState.cam_tracker.x + Glob.SCREEN_WIDTH, rand_y);
			//velocity.x = -10 - FlxU.random() * 40;
			health = 1 + int(GameState.bosses_killed / 4);
			
		}
		
	}
		
}