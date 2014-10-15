package com.admob
{	
	/**
	 * AdMobSize Class
	 * The class will construct and manage the In Admob Banner Sizes
	 *
	 * @author lancelot1
	 **/
	public class AdMobSize
	{
        public static const BANNER:int				= 0;
        public static const MEDIUM_RECTANGLE:int	= 1;
        public static const FULL_BANNER:int			= 2;
        public static const LEADERBOARD:int			= 3;
		public static const WIDE_SKYSCRAPER:int		= 4;
        public static const SMART_BANNER:int		= 5;
        public static const SMART_BANNER_PORT:int	= 6;
        public static const SMART_BANNER_LAND:int	= 7;
        public static const LARGE_BANNER:int	= 8;
		public static function typeSize(adMobSizeType:int):AdSize{
			switch(adMobSizeType)
			{
				case BANNER:
				{
					return new AdSize(320,50);
					break;
				}
				case MEDIUM_RECTANGLE:
				{
					return new AdSize(320,250);
					break;
				}
				case FULL_BANNER:
				{
					return new AdSize(468,60);
					break;
				}
				case LEADERBOARD:
				{
					return new AdSize(728,90);
					break;
				}
				case WIDE_SKYSCRAPER:
				{
					return new AdSize(160,600);
					break;
				}
				case SMART_BANNER:
				{
					return new AdSize(-1,-2);
					break;
				}
				case SMART_BANNER_PORT:
				{
					return new AdSize(-1,-2);
					break;
				}
				case SMART_BANNER_LAND:
				{
					return new AdSize(-1,-2);
					break;
				}
				case LARGE_BANNER:
				{
					return new AdSize(320,100);
					break;
				}
					
				default:
				{
					return new AdSize(320,50);
				}
			}
		}
	}
}