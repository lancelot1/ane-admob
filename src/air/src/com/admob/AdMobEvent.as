//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 lancelot1 inc. All rights reserved.
//

package com.admob
{
	// Flash Includes
	import flash.events.Event;
	
	/**
	 * AdMobEvent Class
	 * The class will construct and manage the AdMob ANE Events
	 *
	 * @author lancelot1
	 **/
	public class AdMobEvent extends Event
	{
		// Banner Events Constants
        public static const BANNER_LOADED:String					= "onBannerLoaded";
        public static const BANNER_FAILED_TO_LOAD:String			= "onBannerFailedToLoad";
        public static const BANNER_AD_OPENED:String					= "onBannerAdOpened";
        public static const BANNER_AD_CLOSED:String					= "onBannerAdClosed";
        public static const BANNER_LEFT_APPLICATION:String			= "onBannerLeftApplication";
        public static const INTERSTITIAL_LOADED:String				= "onInterstitialLoaded";
        public static const INTERSTITIAL_FAILED_TO_LOAD:String		= "onInterstitialFailedToLoad";
        public static const INTERSTITIAL_AD_OPENED:String			= "onInterstitialAdOpened";
        public static const INTERSTITIAL_AD_CLOSED:String			= "onInterstitialAdClosed";
        public static const INTERSTITIAL_LEFT_APPLICATION:String	= "onInterstitialLeftApplication";
		
		// json encoded data (if any available)
		public var data:String;
		
		/**
		 * AdMobAne Event Constructor
		 **/
		public function AdMobEvent(type:String, data:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			// Set current Data
			this.data = data;
			// Construct the event
			super(type, bubbles, cancelable);
		}
	}
}