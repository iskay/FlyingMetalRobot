package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Player extends FlxSprite
	{
		[Embed(source = '../media/man.png')] private var ManImage:Class;
		[Embed(source = '../media/jet.png')] private var JetImage:Class;
		[Embed(source = '../media/gibs_p.png')] private var Gibs_pImage:Class;
		[Embed(source = '../media/jump.mp3')] private var JumpSnd:Class;
		[Embed(source = '../media/land.mp3')] private var LandSnd:Class;
		[Embed(source = '../media/jetpack.mp3')] private var JetpackSnd:Class;
		[Embed(source = '../media/shoot.mp3')] private var ShootSnd:Class;
		
		
		protected var aimingUp:Boolean = false;
		protected var aimingDown:Boolean = false;
		public var jets:FlxEmitter;
		public var poweredUp:Boolean = false;
		public var shells:int = 6;
		protected var busy:Boolean = false;
		public var is_dying:Boolean = false;
		public var gibs:FlxEmitter;
		protected var bullet_timer:Number = -1;
		protected var in_air:Boolean = false;
		protected var jet_snd:FlxSound;
		protected var jump_snd:FlxSound;
		protected var land_snd:FlxSound;
		protected var shoot_snd:FlxSound;
		protected var baz_shoot_snd:FlxSound;

		public function Player() 
		{
			super(Glob.P_START_X, Glob.P_START_Y);
			loadGraphic(ManImage, true, true, 16, 16);

			drag.x = Glob.P_RUN_SPEED * 8;
			acceleration.y = Glob.GRAVITY;
			maxVelocity.x = Glob.P_RUN_SPEED;
			maxVelocity.y = Glob.JUMP;
			
			width = 12;
			offset.x = 2;

			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
			addAnimation("jump_idle", [11]);
			//addAnimation("explode", [12, 13, 14, 15, 16, 17], 15, false);
			
			jets = new FlxEmitter();
			jets.createSprites(JetImage, 24, 0, true);
			jets.setRotation(0, 0);
			jets.setXSpeed(-25, 25);
			jets.setYSpeed(25, 65);
			jets.particleDrag.x = 100; jets.particleDrag.y = 65;
			jets.gravity = 1;
			GameState.lyrSprites.add(jets);
			
			gibs = new FlxEmitter();
			gibs.createSprites(Gibs_pImage, 8, 16, true, 0);
			gibs.setYSpeed(0, -150);
			GameState.lyrSprites.add(gibs);
			
			jet_snd = new FlxSound();
			  jet_snd.loadEmbedded(JetpackSnd, true);
			jump_snd = new FlxSound();
			  jump_snd.loadEmbedded(JumpSnd);
			land_snd = new FlxSound();
			  land_snd.loadEmbedded(LandSnd);
			shoot_snd = new FlxSound();
			  shoot_snd.loadEmbedded(ShootSnd);
			  
			  onFloor = true; in_air = false;

		}
		
		public override function update():void
		{
			if (is_dying)
			{
				super.update();
				return;
			}
			
			if (y < -2) { y = -2; velocity.y = -1;}
			else if (!onScreen()) die(null, null);
			
			if (poweredUp) 	color = 0xFF0000;
			else color = 0xFFFFFF;
						
			aimingUp = false;
			aimingDown = false;
			if(FlxG.keys.UP) aimingUp = true;
			//else if(FlxG.keys.DOWN && velocity.y) aimingDown = true;
			else if(FlxG.keys.DOWN && !onFloor) aimingDown = true;

			acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x = -drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x = drag.x;
			}
			
			//jetpack stuff
			if (facing == RIGHT) jets.x = x + 2;
			else jets.x = x + 14;
			jets.y = y + 12;
			
			if (!onFloor) in_air = true;
			
			if(FlxG.keys.X)
			{
				//if (velocity.y == 0) jump_snd.play();
				if (onFloor) jump_snd.play();
				//in_air = true;
				//FlxG.play(JetpackSnd, 1, true);
				acceleration.y = -Glob.JUMP;
			}
			else
			{
				acceleration.y = Glob.GRAVITY;
			}
			if (FlxG.keys.justPressed("X"))
			{
				jets.start(false, 0.01, 0);
				jet_snd.play();
			}
			if (FlxG.keys.justReleased("X"))
			{
				jets.stop(1);
				jet_snd.stop();
			}		
			
			//shooting
			bullet_timer -= FlxG.elapsed;
			if (bullet_timer <= 0)
			{
				if (!GameState.bazShell.dead && GameState.bazShell.exists) busy = true;
				else busy = false;
				//if(!busy)
				if (1)
				{
					var bXVel:int = 0;
					var bYVel:int = 0;
					var bX:int = x;
					var bY:int = y;
					var shoot_now:Boolean = FlxG.keys.justPressed("C");
					var curBullet:Bullet = GameState.pBullets.getFirstDead() as Bullet;
					if (curBullet != null)
					{
						if(aimingUp)
						{
							if (facing == RIGHT) bX += 6;
							//else bX += 2;
							//bY -= 6;
							bYVel = -Glob.BULLET_VEL;
							if (velocity.y != 0 && shoot_now) velocity.y -= Glob.BULLET_BOOST / 2;
						}
						else if(aimingDown)
						{
							if (facing == RIGHT) bX += 2;
							else bX += 3;
							bY += 16;
							bYVel = Glob.BULLET_VEL;
							if (velocity.y != 0 && shoot_now) velocity.y -= Glob.BULLET_BOOST;
						}
						else if(facing == RIGHT)
						{
							bX += 10;
							bY += 6;
							bXVel = Glob.BULLET_VEL;
							if (velocity.y != 0 && shoot_now) velocity.x -= Glob.BULLET_BOOST;
						}
						else
						{
							bY += 6;
							bXVel = -Glob.BULLET_VEL;
							if (velocity.y != 0 && shoot_now) velocity.x += Glob.BULLET_BOOST;
						}
					
						if (shoot_now)
						{
							curBullet.shoot(bX, bY, bXVel, bYVel);
							shoot_snd.play();
							bullet_timer = Glob.BULLET_DELAY;
							if (poweredUp)
							{
								var curBullet2:Bullet = GameState.pBullets.getFirstDead() as Bullet;
								if (curBullet2 != null) curBullet2.dead = false;
								var curBullet3:Bullet = GameState.pBullets.getFirstDead() as Bullet;
								if (aimingDown || aimingUp)
								{
									if (curBullet2 != null)
									  curBullet2.shoot(bX, bY, bXVel - Glob.BULLET_VEL / 2, bYVel);
									if (curBullet3 != null)
									  curBullet3.shoot(bX, bY, bXVel + Glob.BULLET_VEL / 2, bYVel);
								}
								else
								{
									if (curBullet2 != null)
									  curBullet2.shoot(bX, bY, bXVel, bYVel - Glob.BULLET_VEL / 2);
									if (curBullet3 != null)
									  curBullet3.shoot(bX, bY, bXVel, bYVel + Glob.BULLET_VEL / 2);
								}
							}
						}
						//bazooka
						if (FlxG.keys.justPressed("Z") && shells > 0 && !busy)
						{
							var dir:uint = facing;
							if (aimingUp) { dir = UP; bX += 1; bY -= 2; }
							if (aimingDown) { dir = DOWN; bX += 2;}
							if (!aimingUp && !aimingDown)
							{
								bY += 4;
								//if (facing == RIGHT) bX -= 0;
								if (facing == LEFT) bX -= 6;
							}
							GameState.bazShell.shoot(bX, bY, bXVel, bYVel, dir);
							shells --;
						}
					}
				}
			}
			
			//if(velocity.y != 0)
			if(in_air)
			{
				if (aimingDown == true) play("jump_down");
				else if (aimingUp == true) play("jump_up");
				else
				{
					if (velocity.x != 0) play("jump");
					else play("jump_idle");
				}
			}
			else if(velocity.x == 0)
			{
				if (aimingUp == true) play("idle_up");
				else play("idle");
			}
			else
			{
				if (aimingUp == true) play("run_up");
				else play("run");
			}

			super.update();
		}
		
		public override function kill():void
		{
			die(null, null);
		}
		
		public override function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			if (in_air) { FlxG.play(LandSnd); in_air = false;}
			super.hitBottom(Contact, Velocity);
		}
		
		public function die(Obj1:FlxObject, Obj2:FlxObject):void
		{
			if (!is_dying)
			{
				jets.stop(1);
				jet_snd.stop();
				is_dying = true;
				velocity.x = velocity.y = 0;
				//play("explode");
				exists = false;
				(GameState.grpExp_b.getFirstDead() as Exp_b).explode(x - 32, y - 32);
				FlxG.quake.start(0.005, 0.25)
				FlxG.flash.start(0xffffffff, 0.5);
				gibs.x = x + Glob.BLOCK_DIM / 2; gibs.y = y + Glob.BLOCK_DIM / 2;
				gibs.start(false, 0.01, 8);
			}

		}
		
		public function resetPlayer(X:int, Y:int):void
		{
			reset(X, Y);
			velocity.x = 0; velocity.y = -80;
			aimingUp = false;
			aimingDown = false;
			poweredUp = false;
			shells = 6;
			busy = false;
			is_dying = false;
			bullet_timer = -1;

		}
		
	}
	
}