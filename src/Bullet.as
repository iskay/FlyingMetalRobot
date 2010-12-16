package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Ian
	 */
	public class Bullet extends FlxSprite
	{
		[Embed(source = '../media/bullet.png')] private var BulletImage:Class;
		[Embed(source = '../media/b_hit.mp3')] private var B_hitSnd:Class;
		
		public function Bullet() 
		{
			super();
			loadGraphic(BulletImage, true, false, 7, 7);
			exists = false; dead = true;

			addAnimation("shoot",[0, 1], 12);
			addAnimation("poof",[2, 3, 4, 5], 50, false);
			
			maxVelocity.x = maxVelocity.y = Glob.BULLET_VEL
		}
		
		override public function update():void
		{
			if(dead && finished) exists = false;
			else
			{
				super.update();
				if (!onScreen()) hurt(0);
			}
		}
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void { hurt(0); }
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void { hurt(0); }
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void { hurt(0); }
		override public function hitRight(Contact:FlxObject, Velocity:Number):void { hurt(0);}
		
		public override function hurt(Damage:Number):void
		{
			if(dead) return;
			velocity.x =  velocity.y = 0;
			dead = true;
			play("poof");
			//if (onScreen()) GameState.playB_hitSnd();
			if (onScreen()) FlxG.play(B_hitSnd);
		}
		
		public override function kill():void
		{
			//super.kill();
			hurt(0);
		}

		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			reset(X,Y);
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			
			play("shoot");
		}

		
	}
	
}