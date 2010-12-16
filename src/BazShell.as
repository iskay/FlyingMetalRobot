package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class BazShell extends FlxSprite
	{
		[Embed(source = '../media/shell.png')] private var ShellImage:Class;
		[Embed(source = '../media/gibs_s.png')] private var Gibs_sImage:Class;
		[Embed(source = '../media/baz_shoot.mp3')] private var Baz_shootSnd:Class;
		
		public var gibs:FlxEmitter;
		public var helper:BazHelper;
		protected var baz_shoot_snd:FlxSound;
		
		public function BazShell() 
		{
			super();
			loadGraphic(ShellImage, true, true, 9, 9);
			exists = false; dead = true;

			addAnimation("side", [0, 1], 12);
			addAnimation("up", [2, 3], 12);
			addAnimation("down", [4, 5], 12);
			
			maxVelocity.x = maxVelocity.y = 400;
			
			gibs = new FlxEmitter();
			gibs.createSprites(Gibs_sImage, 8, 16, true, 0);
			GameState.lyrSprites.add(gibs);
			
			helper = new BazHelper();
			//helper = new FlxSprite(0, 0);
			//helper.createGraphic(72, 72, 0xffff00ff);
			//helper.dead = true;
			//GameState.grpPlay_Bul.add(helper);
			
			baz_shoot_snd = new FlxSound();
			  baz_shoot_snd.loadEmbedded(Baz_shootSnd, true);
		}
				
		override public function update():void
		{
			if(dead) exists = false;
			else
			{
				super.update();
				if (!onScreen()) hurt(0);
			}
		}
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void { hurt(1); }
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void { hurt(1); }
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void { hurt(1); }
		override public function hitRight(Contact:FlxObject, Velocity:Number):void { hurt(1);}
		
		public override function hurt(Damage:Number):void
		{
			baz_shoot_snd.stop();
			if(dead) return;
			velocity.x =  velocity.y = 0;
			if (onScreen())
			{
				var exp:Exp_b = GameState.grpExp_b.getFirstDead() as Exp_b;
				if (exp != null) exp.explode(x - 24, y - 32);
				FlxG.quake.start(0.005, 0.25)
				FlxG.flash.start(0xffffffff, 0.5);
				if (Damage == 1)
				{
					if (facing == RIGHT) { gibs.x = x + 9; gibs.y = y + 3; gibs.setXSpeed(-150, 5); gibs.setYSpeed(-150, 50);}
					else if (facing == LEFT) { gibs.x = x; gibs.y = y + 3; gibs.setXSpeed(5, 150); gibs.setYSpeed(-150, 50);}
					else if (facing == UP) { gibs.x = x + 3; gibs.y = y; gibs.setXSpeed(-50, 50); gibs.setYSpeed(-5 , 150);}
					else { gibs.x = x + 3; gibs.y = y + height; gibs.setXSpeed(-50, 50); gibs.setYSpeed(-5, -150);}
					gibs.start(false, 0.01, 8);
				}
				helper.reset(x - 28, y - 36);
				GameState.baz_timer = 0.35;
				//FlxU.overlap(helper, GameState.grpEnemies);
				
			}
			dead = true;
		}
		
		public override function kill():void
		{
			//super.kill();
			hurt(0);
		}

		public function shoot(X:int, Y:int, AccelX:int, AccelY:int, dir:uint):void
		{
			super.reset(X,Y);
			//velocity.x = VelocityX;
			//velocity.y = VelocityY;
			velocity.x = velocity.y = 0;
			acceleration.x = AccelX;
			acceleration.y = AccelY;
			facing = dir;
			if (dir == RIGHT)
			{
				facing = RIGHT;
				play("side");
				height = 3; offset.y = 3;
				width = 9; offset.x = 0;
			}
			else if (dir == LEFT)
			{
				facing = LEFT;
				play("side");
				height = 3; offset.y = 3;
				width = 9; offset.x = 0;
			}
			else if (dir == UP)
			{
				play("up");
				height = 9; offset.y = 0;
				width = 3; offset.x = 3;
			}
			else
			{
				play("down");
				height = 9; offset.y = 0;
				width = 3; offset.x = 3;
			}
			baz_shoot_snd.play();
		}
	}
}