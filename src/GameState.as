package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class GameState extends FlxState
	{
		
		[Embed(source = '../media/back.png')] private var BackImage:Class;	//background
		[Embed(source = '../media/plat.png')] private var PlatImage:Class;	//platforms
		[Embed(source = '../media/plat2.png')] private var Plat2Image:Class;
		[Embed(source = '../media/gradient.png')] private var GradientImage:Class;	//gradient
		//[Embed(source = '../media/b_hit.mp3')] private var B_hitSnd:Class;
		[Embed(source = '../media/exp_b.mp3')] private var Exp_bSnd:Class;
		[Embed(source = '../media/exp_s.mp3')] private var Exp_sSnd:Class;
		[Embed(source = '../media/fight.mp3')] private var FightSnd:Class;
		[Embed(source = '../media/respawn.mp3')] private var RespawnSnd:Class;
		[Embed(source = '../media/fly.mp3')] private var Music1Snd:Class;
		
	//////////////////////////////////
	
		public static var lyrBack:FlxGroup;
		public static var lyrStage:FlxGroup;
		public static var lyrSprites:FlxGroup;
		public static var lyrHUD:FlxGroup;
		
		protected static var gradient:FlxSprite;
		
		public static var kill_text:FlxText;
		public static var boss_text:FlxText;
		
		public static var plat_count:int = 0;
		protected static var plat_timer:Number = Glob.PLAT_INTERVAL;
		
		public static var cam_tracker:CamFocusOn;
		public static var powerTri:PowerUp;
		public static var powerBaz:PowerUp;
		public static var grpStraight:FlxGroup;
		public static var grpWave:FlxGroup;
		public static var grpFormation:FlxGroup;
		public static var grpSwoop:FlxGroup;
		public static var grpSeeker:FlxGroup;
		public static var grpEnemies:FlxGroup;
		
		public static var grpBossR:FlxGroup;
		public static var grpBossG:FlxGroup;
		
		public static var player:Player;
		public static var pBullets:FlxGroup;
		public static var bazShell:BazShell;
		public static var grpBaz:FlxGroup;
		public static var baz_timer:Number = -1;
		public static var grpIcons:FlxGroup;
		
		public static var straight_timer:Number = Glob.STRAIGHT_INTERVAL;
		public static var wave_timer:Number = 2;
		public static var formation_timer:Number = 2;
		public static var swoop_timer:Number = 2;
		public static var seeker_timer:Number = 2;
		public static var pow_spawn_timer:Number = 2;
		public static var pow_effect_timer:Number = -1;
		
		public static var kill_count:int = 0;
		public static var bosses_killed:int = 0;
		public static var till_boss:int = Glob.KILLS_TILL_BOSS;
		public static var boss_now:Boolean = false;
		public static var diff_now:Boolean = false;
		public static var till_diff:int = Glob.KILLS_TILL_DIFF;
		protected static var next_red:Boolean;
		public static var fighting_boss:int = 0;
		protected static var difficulty:int = Glob.STARTING_DIFF;
		protected static var diff_timer:int = Glob.DIFF_TIMER;
		
		protected static var first_time:Boolean = false;
		//public static var reset_game:Boolean = false;
		protected var death_timer:Number = 2;
		protected var death_max_timer:Number = 5;
		
		public static var grpExp_s:FlxGroup;
		public static var grpExp_b:FlxGroup;
		public static var grpEmit_r:FlxGroup;
		public static var grpEmit_g:FlxGroup;
		public static var grpEmit_b:FlxGroup;
		public static var grpBigEmit_r:FlxGroup;
		public static var grpBigEmit_g:FlxGroup;
		
		public static var grpPlay_Bul:FlxGroup;
		
		//protected static var b_hit_snd:FlxSound;
		//public static var grpB_snd:FlxGroup;
		protected static var exp_s_snd:FlxSound;
		protected static var exp_b_snd:FlxSound;
		protected static var music1_snd:FlxSound;

		public function GameState()
		{
			super();
		}
		
		public override function create():void
		{
			var i:int;	//reusable loop counter variable
			if (FlxU.random() > 0.5) next_red = false;
			else next_red = true;
			
			//initialize groups
			lyrBack = new FlxGroup;
			lyrStage = new FlxGroup;
            lyrSprites = new FlxGroup;
            lyrHUD = new FlxGroup;
			
			gradient = new FlxSprite(0, 0, GradientImage);
			gradient.scrollFactor.x = gradient.scrollFactor.y = 0;
			
			cam_tracker = new CamFocusOn();
			this.add(cam_tracker);
			
			powerTri = new PowerUp(0);
			powerBaz = new PowerUp(1);
	
			pBullets = new FlxGroup();
			  for (i = 0; i < 36; i++) pBullets.add(new Bullet());
			bazShell = new BazShell();
			
			grpExp_b = new FlxGroup;
			  for (i = 0; i < 5; i++) grpExp_b.add(new Exp_b());
			grpExp_s = new FlxGroup;
			  for (i = 0; i < 10; i++) grpExp_s.add(new Exp_s());
			
			var newEmitter:TimedEmitter;
			grpEmit_r = new FlxGroup;
			  for (i = 0; i < 4; i++) grpEmit_r.add(new TimedEmitter(0));
			grpEmit_g = new FlxGroup;
			  for (i = 0; i < 4; i++) grpEmit_g.add(new TimedEmitter(1));
			grpEmit_b = new FlxGroup;
			  for (i = 0; i < 4; i++) grpEmit_b.add(new TimedEmitter(2));
			grpBigEmit_r = new FlxGroup;
			  for (i = 0; i < 2; i++) grpBigEmit_r.add(new TimedEmitter(3));
			grpBigEmit_g = new FlxGroup;
			  for (i = 0; i < 2; i++) grpBigEmit_g.add(new TimedEmitter(4));

			player = new Player();
			lyrSprites.add(powerTri);
			lyrSprites.add(powerBaz);
			lyrSprites.add(player);
			lyrSprites.add(grpExp_b);
			lyrSprites.add(grpExp_s);
			lyrSprites.add(pBullets);
			lyrSprites.add(bazShell);
			lyrSprites.add(grpEmit_r);
			lyrSprites.add(grpEmit_g);
			lyrSprites.add(grpEmit_b);
			lyrSprites.add(grpBigEmit_r);
			lyrSprites.add(grpBigEmit_g);
					
			//initialize background
			var temp_block:FlxTileblock;
			for (i = 0; i <= 25; i++)
			{
				temp_block = new FlxTileblock(i * Glob.BLOCK_DIM, 0, Glob.BLOCK_DIM, Glob.BLOCK_DIM * 12);
				temp_block.loadGraphic(BackImage, 10);
				temp_block.scrollFactor.x = 0.25;
				lyrBack.add(temp_block);
			}
			
			//add starting platforms
			var plat:FlxTileblock;
			plat = new FlxTileblock(4 * Glob.BLOCK_DIM, 8 * Glob.BLOCK_DIM, 3 * Glob.BLOCK_DIM, Glob.BLOCK_DIM);
			plat.loadGraphic(PlatImage);
			lyrStage.add(plat);
			plat = new FlxTileblock(18 * Glob.BLOCK_DIM, 4 * Glob.BLOCK_DIM, 2 * Glob.BLOCK_DIM, Glob.BLOCK_DIM);
			plat.loadGraphic(PlatImage);
			lyrStage.add(plat);
			plat_count = 2;
			
		//create enemies
			grpStraight = new FlxGroup;
			  for (i = 0; i < 15; i++) grpStraight.add(new eStraight());
			grpWave = new FlxGroup;
			  for (i = 0; i < 15; i++) grpWave.add(new eWave());
			grpFormation = new FlxGroup;
			  for (i = 0; i < 10; i++) grpFormation.add(new eFormation());
			grpSwoop = new FlxGroup;
			  for (i = 0; i < 10; i++) grpSwoop.add(new eSwoop());
			grpSeeker = new FlxGroup;
			  for (i = 0; i < 6; i++) grpSeeker.add(new eSeeker());
			
			grpBossG = new FlxGroup;
			  grpBossG.add(new BossG(0, 55));
			  grpBossG.add(new BossG(1, 30));
			  grpBossG.add(new BossG(0, 30));
			  grpBossG.add(new BossG(1, 55));
			grpBossR = new FlxGroup;
			  grpBossR.add(new BossR(0, 75));
			  grpBossR.add(new BossR(1, 60));
			  grpBossR.add(new BossR(0, 60));
			  grpBossR.add(new BossR(1, 75));
			
			grpEnemies = new FlxGroup;
			  grpEnemies.add(grpStraight);
			  grpEnemies.add(grpWave);
			  grpEnemies.add(grpFormation);
			  grpEnemies.add(grpSwoop);
			  grpEnemies.add(grpSeeker);
			  grpEnemies.add(grpBossG);
			  grpEnemies.add(grpBossR);
		//////////
			
			//HUD
			kill_text = new FlxText(2, 0, 50);
			boss_text = new FlxText(Glob.SCREEN_WIDTH - 52, 0, 50);
			boss_text.alignment = "right";
			grpIcons = new FlxGroup();
			  for (i = 0; i < 10; i++)
			  {
				  grpIcons.add(new Icon(7 * Glob.BLOCK_DIM + i * Glob.BLOCK_DIM, 0));
				  grpIcons.members[i].scrollFactor.x = grpIcons.members[i].scrollFactor.y = 0
			  }
			kill_text.scrollFactor.x = kill_text.scrollFactor.y = 0;
			boss_text.scrollFactor.x = boss_text.scrollFactor.y = 0;
			lyrHUD.add(kill_text); lyrHUD.add(boss_text); lyrHUD.add(grpIcons);
			
			//lyrSprites.add(bazShell.helper);
			lyrSprites.add(grpEnemies);
			grpPlay_Bul = new FlxGroup;
			  grpPlay_Bul.add(player);
			  grpPlay_Bul.add(pBullets);
			grpBaz = new FlxGroup;
			  grpBaz.add(bazShell);
			  grpBaz.add(bazShell.helper);
			
			//layers to screen
			this.add(gradient);
			this.add(lyrBack);
			this.add(lyrStage);
			this.add(lyrSprites);
			//this.add(kill_text);
			//this.add(boss_text);
			this.add(lyrHUD);
			
			//initialize camera
			FlxG.follow(cam_tracker,2.5);
			FlxG.followAdjust(0.5, 0);
			
			//initialize sounds
			//b_hit_snd = new FlxSound();
			//  b_hit_snd.loadEmbedded(B_hitSnd);
			/*grpB_snd = new FlxGroup;
			var new_sound:FlxSound;
			for (i = 0; i < 3; i++)
			{
				new_sound = new FlxSound();
				new_sound.loadEmbedded(B_hitSnd);
				grpB_snd.add(new_sound);
			}*/
			exp_s_snd = new FlxSound();
			  exp_s_snd.loadEmbedded(Exp_sSnd);
			  exp_s_snd.volume = 0.5;
			exp_b_snd = new FlxSound();
			  exp_b_snd.loadEmbedded(Exp_bSnd);
			  exp_b_snd.volume = 0.8;
			music1_snd = new FlxSound();
			  music1_snd.loadEmbedded(Music1Snd, true);
			  music1_snd.volume = 0.6;
			  music1_snd.play();
		}

////////////////////////////////////////////////////////////////////////////////////////////////
		public override function update():void
		{
			//if (reset_game) resetGame();
			//if (FlxG.keys.justPressed("Z")) GameState.reset_game = true;
			if (player.is_dying)
			{
				death_timer -= FlxG.elapsed;
				death_max_timer -= FlxG.elapsed;
				if (death_timer <= 0)
				{
					//if (FlxG.keys.X || FlxG.keys.C || FlxG.keys.Z || death_max_timer <= 0)
					if (FlxG.keys.X || death_max_timer <= 0)
					{
						death_timer = 2;
						death_max_timer = 5;
						resetGame();
					}
				}
			}
			
			kill_text.text = kill_count.toString();
			boss_text.text = bosses_killed.toString();
			var n:int;
			for (n = 0; n < 10; n ++) grpIcons.members[n].full = false;
			for (n = 0; n < player.shells; n ++) grpIcons.members[n].full = true;
			
			diff_timer <= FlxG.elapsed;
			if (diff_timer <= 0)
			{
				diff_now = true;
				till_diff = Glob.KILLS_TILL_DIFF + 2 * difficulty;
				//diff_timer = 45;
				diff_timer = Glob.DIFF_TIMER;
			}
			if (diff_now)
			{
				difficulty ++;
				if (difficulty > Glob.MAX_DIFF) difficulty = Glob.MAX_DIFF;
				diff_now = false;
			}
			
			if (first_time) {FlxG.flash.start(0xff000000, 0.5, null, true); first_time = false; }
			super.update();
			
			if (baz_timer != -1)
			{
				baz_timer -= FlxG.elapsed;
				if (baz_timer <= 0)
				{
					//bazShell.helper.kill();
					bazShell.helper.reset(0, 0);
					bazShell.dead = true;
					baz_timer = -1;
				}
			}
			
			FlxU.collide(grpPlay_Bul, lyrStage);
			FlxU.collide(bazShell, lyrStage);
			FlxU.overlap(grpPlay_Bul, grpEnemies);
			FlxU.overlap(grpBaz, grpEnemies, handleBazCollision);
			//FlxU.overlap(bazShell, grpEnemies, handleBazCollision);
			//FlxU.overlap(bazShell.helper, grpEnemies, handleBazCollision);
			FlxU.overlap(player, powerTri, powerTri.pickedUp);
			FlxU.overlap(player, powerBaz, powerBaz.pickedUp);
			
			var screen_left:int = (cam_tracker.x + cam_tracker.width / 2) - Glob.SCREEN_WIDTH / 2;	
			var screen_right:int = screen_left + Glob.SCREEN_WIDTH;
					
			//update background
			var back_old_x:int = screen_left - lyrBack.members[0].x;
			if (lyrBack.members[0].x * 4 <= (screen_left - 4 * Glob.BLOCK_DIM))
			{
				delete lyrBack.members[0];
				for (var i:int = 1; i <= 25; i++) lyrBack.members[i - 1] = lyrBack.members[i];
				delete lyrBack.members[25];
				var new_back_strip:FlxTileblock = new FlxTileblock(screen_right + Glob.BLOCK_DIM - back_old_x,
				  0, Glob.BLOCK_DIM, Glob.BLOCK_DIM * 12);
				new_back_strip.loadGraphic(BackImage, 10);
				new_back_strip.scrollFactor.x = 0.25;
				lyrBack.members[25] = new_back_strip;
			}
			
			//update platforms
			plat_timer -= FlxG.elapsed;
			if (plat_count < Glob.PLAT_MAX && plat_timer <= 0)
			{
				addPlatform(screen_right - (screen_right % Glob.BLOCK_DIM) + Glob.BLOCK_DIM);
				plat_timer = Glob.PLAT_INTERVAL;
			}
			for each (var existing_plat:FlxTileblock in lyrStage.members)
			{
				if (existing_plat != null)
				{
					if (existing_plat.x < (screen_left - existing_plat.width)) //if offscreen to left
					{
						lyrStage.remove(existing_plat);
						existing_plat.destroy();
						plat_count --;
					}
				}
			}
			
		//add enemies
	if (fighting_boss == 0) {
			var recycled_enemy:FlxSprite;
			//straight
			straight_timer -= (FlxG.elapsed + FlxG.elapsed * FlxU.random());
			if (grpStraight.countDead() != 0 && straight_timer <= 0)
			{
				recycled_enemy = grpStraight.getRandom() as eStraight;
				if ((recycled_enemy as eStraight).exists == false) (recycled_enemy as eStraight).setInPlay();
				straight_timer = Glob.STRAIGHT_INTERVAL - difficulty;
				if (straight_timer < 2) straight_timer = 2;
			}
		if (kill_count > 4)
		{
			//wave
			wave_timer -= (FlxG.elapsed + FlxG.elapsed * FlxU.random());
			if (grpWave.countDead() != 0 && wave_timer <= 0)
			{
				recycled_enemy = grpWave.getFirstDead() as eWave;
				if (recycled_enemy != null) (recycled_enemy as eWave).setInPlay();
				wave_timer = Glob.WAVE_INTERVAL - difficulty;
				if (wave_timer < 2) wave_timer = 3;
			}
		}
		if (kill_count > 9)
		{
			//formation
			formation_timer -= (FlxG.elapsed + FlxG.elapsed * FlxU.random());
			if (grpFormation.countDead() >= 5 && formation_timer <= 0)
			{
				var rand_y:int = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM)
				if (rand_y < 2) rand_y = 2; if (rand_y > 9) rand_y = 9;
				i = 2;
				var j:int = 0;
				do
				{
					var f:eFormation = GameState.grpFormation.getFirstDead() as eFormation
					if (f != null)
					{
						f.setInPlay(i, rand_y * Glob.BLOCK_DIM);
						i --; j++;
					}
				} while (j < 5);
				formation_timer = Glob.FORMATION_INTERVAL - 2 * difficulty;
				if (formation_timer < 8) formation_timer = 8;
			}
		}
		if (kill_count > 14)
		{
			//swoop
			swoop_timer -= (FlxG.elapsed + FlxG.elapsed * FlxU.random());
			if (grpSwoop.countDead() != 0 && swoop_timer <= 0)
			{
				recycled_enemy = grpSwoop.getFirstDead() as eSwoop;
				if (recycled_enemy != null) (recycled_enemy as eSwoop).setInPlay();
				swoop_timer = Glob.SWOOP_INTERVAL - 2 * difficulty;
				if (swoop_timer < 6) swoop_timer = 6;
			}
		}
		if (kill_count > 24)
		{
			//seeker
			seeker_timer -= (FlxG.elapsed + FlxG.elapsed * FlxU.random());
			if (grpSeeker.countDead() != 0 && seeker_timer <= 0)
			{
				recycled_enemy = grpSeeker.getFirstDead() as eSeeker;
				if (recycled_enemy != null) (recycled_enemy as eSeeker).setInPlay();
				seeker_timer = Glob.SEEKER_INTERVAL - 2 * difficulty;
				if (seeker_timer < 12) seeker_timer = 12;
			}
		}
	}
		////////////
		//Bosses
		if (boss_now)
		{
			boss_now = false;
			addBoss(2 + bosses_killed / 2);
			FlxG.play(FightSnd);
		}
		if (fighting_boss != 0) FlxG.quake.start(0.005, 2.5);
		
		
			//update power-up
			pow_spawn_timer -= FlxG.elapsed;
			if (pow_spawn_timer <= 0)
			{
				if (FlxU.random() < 0.8)
				{
					//powerUp.setInPlay();
					if (FlxU.random() > 0.3) powerTri.setInPlay();
					else powerBaz.setInPlay();
					pow_spawn_timer = Glob.POW_SPAWN_INTERVAL;
				}
			}
			if (pow_effect_timer != -1)
			{
				pow_effect_timer -= FlxG.elapsed;
				if (pow_effect_timer < 0)
				{
					player.poweredUp = false;
					player.flicker(0.5);
					pow_effect_timer = -1;
				}	
			}
					
		}
///////////////////////////////////////////////////////////////////////////////////////		
		
		protected function addPlatform(X:int):void
		{
			var orientation:int = 0;
			if (FlxU.random() > 0.5) orientation = 1;
			
			var plat:FlxTileblock;
			plat = createPlatform(X, orientation);
			if (plat != null)
			{
				if (orientation == 0) plat.loadGraphic(PlatImage);
				else plat.loadGraphic(Plat2Image);
				lyrStage.add(plat)
				plat_count ++;
			}
		}
		
		protected function createPlatform(X:int, orientation:int):FlxTileblock
		{
			var blockWidth:int = Glob.BLOCK_DIM;
			var blockHeight:int = Glob.BLOCK_DIM;
			var blockY:int = 0;
			var newBlock:FlxTileblock = null;
			//var orientation:int = 0;
			
			//if (FlxU.random() > 0.5) orientation = 1;
			
			if (orientation == 1) blockWidth = 1;
			  else blockWidth = Glob.PLAT_SIZE_MIN + int(FlxU.random() * (Glob.PLAT_SIZE_MAX - Glob.PLAT_SIZE_MIN));
			if (orientation == 0) blockHeight = 1;
			  else blockHeight = Glob.PLAT_SIZE_MIN + int(FlxU.random() * (Glob.PLAT_SIZE_MAX - Glob.PLAT_SIZE_MIN));
			
			blockY = int(FlxU.random() * Glob.SCREEN_HEIGHT / Glob.BLOCK_DIM) * Glob.BLOCK_DIM;

			newBlock = new FlxTileblock(X, blockY, blockWidth * Glob.BLOCK_DIM, blockHeight * Glob.BLOCK_DIM)
			FlxU.overlap(newBlock, powerBaz, powerBaz.onOverlap);
			FlxU.overlap(newBlock, powerTri, powerTri.onOverlap);

			return newBlock;
		}
		
		public static function addBoss(N:int):void
		{
			var i:int;
			var n:int = N;
			if (n > 4) n = 4;

			if (next_red)
			{
				for (i = 0; i < n; i++)
				{
					GameState.grpBossR.members[i].setInPlay();
				}
				next_red = false;
			}
			else
			{
				for (i = 0; i < n; i++)
				{
					GameState.grpBossG.members[i].setInPlay();
				}
				next_red = true;
			}
			fighting_boss = n;
			
		}
				
		public static function increaseKillCount():void
		{
			kill_count ++;
			till_boss = kill_count % Glob.KILLS_TILL_BOSS;
			  if (till_boss == 0) { boss_now = true; till_boss = Glob.KILLS_TILL_BOSS + 5 * bosses_killed;}
			till_diff = kill_count % Glob.KILLS_TILL_DIFF;	
			  if (till_diff == 0) { diff_now = true; till_diff = Glob.KILLS_TILL_DIFF + 2 * difficulty; }
		}
		
		protected static function handleBazCollision(Baz:FlxObject, Enemy:FlxObject):void
		{
			Baz.kill();
			Enemy.health -= 5;
			Enemy.kill();
		}
		
		protected function resetGame():void
		{
			var i:int;	//reusable loop counter variable
			
			var loop:int = 0;
			do
			{
				var collides:Boolean = false;
				var px:int = cam_tracker.x - 8 * Glob.BLOCK_DIM + loop * Glob.BLOCK_DIM;
				var py:int = Glob.BLOCK_DIM;
				for each (var block:FlxTileblock in lyrStage.members)
				  if (block != null)
				    if (block.overlapsPoint(px + 8, py + 8)) { collides = true; break;}
				    else collides = false;
				loop++;
			}while (loop < 100 && collides == true);
			player.resetPlayer(px, py);
			first_time = true;
			
			//reset enemies
			var enemy:FlxObject;
			for each (enemy in grpStraight.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpFormation.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpWave.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpSeeker.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpSwoop.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpBossG.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			for each (enemy in grpBossR.members)
			  if (enemy != null)
				if (enemy.exists) { (enemy as FlxSprite).health = 1; enemy.kill();}
			
			//reset variables
			baz_timer = -1;
			straight_timer = Glob.STRAIGHT_INTERVAL;
			wave_timer = 2;
			formation_timer = 2;
			swoop_timer = 2;
			seeker_timer = 2;
			pow_spawn_timer = 2;
			pow_effect_timer = -1;
			kill_count = 0;
			bosses_killed = 0;
			//till_boss = 50;
			till_boss = Glob.KILLS_TILL_BOSS;
			boss_now = false;
			diff_now = false;
			till_diff = Glob.KILLS_TILL_DIFF;
			//next_red:Boolean = true;
			if (FlxU.random() > 0.5) next_red = false;
			else next_red = true;
			fighting_boss = 0;
			difficulty = Glob.STARTING_DIFF;
			diff_timer = Glob.DIFF_TIMER;
			death_timer = 2;
			death_max_timer = 5;
			//reset_game = false;
			
			FlxG.play(RespawnSnd);
		}
		/*
		public static function playB_hitSnd():void
		{
			b_hit_snd.play();
			//for (var i:int = 0; i < 3; i++)
			//{
			//	if (!grpB_snd.members[i].active)
			//	  { grpB_snd.members[i].play(); break;}
			//}
		}
		*/
		public static function playExp_sSnd():void
		{
			exp_s_snd.play();
		}
		
		public static function playExp_bSnd():void
		{
			exp_b_snd.play();
		}

	}
}