//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 lancelot1 inc. All rights reserved.
//

package com.admob
{
	/**
	 * AdMobBanner Class
	 * The class will construct and manage the AdMob Banner
	 *
	 * @author lancelot1
	 **/
	public class AdMobBanner
	{
		// Banner Position Type Constants
        public static const POS_RELATIVE:int		= 0;
        public static const POS_ABSOLUTE:int		= 1;
		
		// Banner Proprierties
        private var mBannerId:String;
        private var mAdSize:int;
        private var mAdPositionType:int;
        private var mAdPosition:int;
        private var mAdPositionCoord:Array;
        private var mAdMobId:String;
        private var mAutoShow:Boolean;
		
		/**
		 * Banner Unique ID
		 **/
		public function get bannerId():String
		{return mBannerId;}
		
		/**
		 * Banner Position Type
		 **/
		public function get adPositionType():int
		{return mAdPositionType;}
		
		/**
		 * Banner AdMobPosition type
		 **/
		public function get adPosition():int
		{return mAdPosition;}
		
		/**
		 * Banner Autoshow State
		 **/
		public function get adPositionCoord():Array
		{return mAdPositionCoord;}
		
		/**
		 * Banner Autoshow State
		 **/
		public function get autoShow():Boolean
		{return mAutoShow;}
		
		/** 
		 * Create the AdMobBanner
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * @param bannerId Unique Banner Id
		 * @param adMobId Unique AdMobId for the banner
		 * @param autoShow Automatic visualization
		 */
		public function AdMobBanner(_adSize:int,_adPositionType:int,_adPosition:Array,_bannerId:String,_adMobId:String,_autoShow:Boolean)
		{
			// Update banner proprierties
			mBannerId		= _bannerId;
			mAdSize			= _adSize;
			mAdPositionType	= _adPositionType;
			if (mAdPositionType == POS_RELATIVE) mAdPosition = _adPosition[0];
			if (mAdPositionType == POS_ABSOLUTE) mAdPositionCoord = _adPosition;
			mAdMobId		= _adMobId;
			mAutoShow		= _autoShow;
		}
	}
}