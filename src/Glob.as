package  
{
	
	/**
	 * Global constants
	 * @author Ian
	 */
	public class Glob 
	{
		public static const SCREEN_WIDTH:int = 384;
		public static const SCREEN_HEIGHT:int = 192;
		
		public static const CAM_SPEED:int = 15;
		
		public static const BLOCK_DIM:int = 16;
		
		public static const PLAT_MAX:int = 8;
		public static const PLAT_SIZE_MIN:int = 1;
		public static const PLAT_SIZE_MAX:int = 6;
		public static const PLAT_INTERVAL:Number = 4;
		
		public static const POW_SPAWN_INTERVAL:Number = 20;
		public static const POW_EFFECT_TIME:Number = 10;
		
		public static const STRAIGHT_INTERVAL:Number = 5;
		public static const WAVE_INTERVAL:Number = 8;
		public static const FORMATION_INTERVAL:Number = 16;
		public static const SWOOP_INTERVAL:Number = 12;
		public static const SEEKER_INTERVAL:Number = 20;
		
		public static const P_START_X:int = 5 * BLOCK_DIM; 
		public static const P_START_Y:int = 7 * BLOCK_DIM;
		public static const P_RUN_SPEED:int = 80;
		public static const GRAVITY:Number = 360;
		public static const JUMP:Number = 200;
		
		public static const P_WIDTH:int = 14;
		
		public static const BULLET_VEL:int = 100;
		public static const BULLET_BOOST:int = 40;
		public static const BULLET_DELAY:Number = 0.1;
		
		public static const KILLS_TILL_BOSS:int = 30;
		public static const KILLS_TILL_DIFF:int = 10;
		public static const STARTING_DIFF:int = 2;
		public static const MAX_DIFF:int = 8;
		public static const DIFF_TIMER:int = 30;
			
		public function Glob() 
		{
			//
		}
		
	}
	
}