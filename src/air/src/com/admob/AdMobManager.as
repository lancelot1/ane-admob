//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 lancelot1 inc. All rights reserved.
//

package com.admob
{
	// Flash Includes
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	/** 
	 * AdMobManager Class<br/>
	 * The class will construct and manage the AdMobManager
	 *
	 * @author lancelot1
	 **/
	public class AdMobManager extends EventDispatcher
	{
		// Tag Constant for log
		static private const LOG_TAG:String				= 'AdMobAne_AS3';
		
		// AdMobManager Static constants
		static public const TEST_MODE:Boolean			= false;
		static public const PROD_MODE:Boolean			= true;
		
		// Targeting Costants
		static public const GENDER_UNDEFINED:int		= 0;
		static public const GENDER_MALE:int				= 1;
		static public const GENDER_FEMALE:int			= 2;
		
		// Supported Devices Constants
		static public const IOS:String					= "iOS";
		static public const ANDROID:String				= "Android";
		
		// ANE Name
		private const ANE_NAME:String					= "com.admob.ane";
		
		// Supported Devices Definition
		private const ID_IOS:String						= "iOS";
		private const ID_ANDROID:String					= "Android";
		
		// Operation Mode Definitions
		private const ID_TEST_MODE:String				= "Testing Mode";
		private const ID_PROD_MODE:String				= "Production Mode";
		
		// AdMobManager Static parameters
		static private var mManager:AdMobManager		= null;
		
		// Manager Proprierties
		private var mCtx:ExtensionContext				= null;
		private var mDispatcher:EventDispatcher			= null;
		private var mBannersAdMobId:String				= null;
		private var mInterstitialAdMobId:String			= null;
		private var mTestDeviceID:String				= null;
		private var mOperationMode:Boolean				= false;
		private var mVerbose:Boolean					= false;
		private var mDevice:String						= null;
		private var mBannersDic:Dictionary				= null;
		private var mIsInterstitialCreated:Boolean		= false;
		private var mInterstitialAutoShow:Boolean		= false;
		
		// Targeting Proprieties
		private var mGender:int							= 0;
		private var mBirthYear:int						= 0;
		private var mBirthMonth:int						= 0;
		private var mBirthDay:int						= 0;
		private var mIsCDT:Boolean						= false;
		
		// =================================================================================================
		//	Getters/Setters
		// =================================================================================================
		
		/**
		 * Extension context Instance
		 **/
		static public function get manager():AdMobManager
		{
			// Return null if the device is not supported
			if (!mManager) mManager = new AdMobManager();
			// Return the context instance
			return mManager;
		}
		
		/** 
		 * Extension event Dispatcher
		 */
		public function get dispatcher():EventDispatcher
		{
			// Check if the dispatcher is available or create a new one
			if(!mDispatcher) { mDispatcher = new EventDispatcher(); }
			// Return the Dispatcher
			return mDispatcher;
		}
		
		/**
		 * Extension context Instance
		 **/
		private function get ctx():ExtensionContext
		{return mCtx;}
		
		/**
		 * Banners AdMob Unit ID
		 **/
		public function get bannersAdMobId():String
		{ return mBannersAdMobId; }
		public function set bannersAdMobId(id:String):void
		{ mBannersAdMobId = id; }
		
		/**
		 * Interstitial AdMob Unit ID
		 **/
		public function get interstitialAdMobId():String
		{ return mInterstitialAdMobId; }
		public function set interstitialAdMobId(id:String):void
		{ mInterstitialAdMobId = id; }
		
		/**
		 * Extension Operation Mode
		 **/
		public function get operationMode():Boolean
		{ return mOperationMode; }
		public function set operationMode(mode:Boolean):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the operatioon Mode, the extension is not supported or not initialized");
				return;
			}
			// Update local instance
			mOperationMode = mode;
			// Now we can create the banner
			log(LOG_TAG, "Native SetMode Call Performed!");
            ctx.call(AdMobFunctions.SET_MODE, mOperationMode);
		}
		
		/**
		 * Extension Verbose Mode
		 **/
		public function get verbose():Boolean
		{ return mVerbose; }
		public function set verbose(mode:Boolean):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the verbose Mode, the extension is not supported or not initialized.");
				return;
			}
			// Update local instance
			mVerbose = mode;
			// Now we can create the banner
			log(LOG_TAG, "Native SetVerbose Call Performed!");
            ctx.call(AdMobFunctions.SET_VERBOSE, mVerbose);
		}
		
		/**
		 * Extension support state
		 **/
		public function get isSupported():Boolean
		{
			// Return false if there is no context (which means the extension is not supported)
			if (device) return true;
			// Otherwise return true
			return false;
		}
		
		/**
		 * Interstitial Creation state
		 **/
		private function get isInterstitialCreated():Boolean
		{return mIsInterstitialCreated;}
		
		/**
		 * Interstitial Automatic Visualization state
		 **/
		private function get interstitialAutoShow():Boolean
		{return mInterstitialAutoShow;}
		
		/** 
		 * Device in use
		 */
		public function get device():String
		{
			// Check if the device instance is already available
			if (!mDevice) {
				// If not update the instance with the device in use
				if(Capabilities.manufacturer.indexOf(ID_IOS) > -1)		mDevice = ID_IOS;
				if(Capabilities.manufacturer.indexOf(ID_ANDROID) > -1)	mDevice = ID_ANDROID;
			}
			// Return the Device
			return mDevice;
		}
		
		/** 
		 * Banners Dictionary
		 */
		private function get bannersDic():Dictionary
		{
			// Check if the dvice instance is already available
			if (!mBannersDic) mBannersDic = new Dictionary();
			// Return the Dispatcher
			return mBannersDic;
		}
		
		/** 
		 * Currently available Banners Quantity
		 */
		public function get bannersQuantity():int
		{
			// Count the number of banners currently Available in the Dictionary
			var n:int = 0;
			for (var key:String in bannersDic) {
				n++;
			}
			// Return the count
			return n;
		}
		
		/** 
		 * Currently available Banners names
		 */
		public function get bannersNames():Array
		{
			// Create returning Array
			var names:Array = new Array();
			// Collect all banners names if there is banners in the dictionary
			if (bannersQuantity > 0) {
				for (var key:String in bannersDic) {
					names.push(key);
				}
			}
			// Return the names Array
			return names;
		}
		
		/**
		 * Device ID for Testing
		 **/
		public function get testDeviceID():String
		{ return mTestDeviceID; }
		public function set testDeviceID(deviceID:String):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the Test Device ID, the extension is not supported or not initialized");
				return;
			}
			
			// Check if the parameter is valid
			if (deviceID == null) {
				log(LOG_TAG, "Cannot set the Test Device ID, an incorrect value as been passet. Please use the public constant values available in AdMobManager");
				return;
			}

			// Check if the parameter is valid
			if (deviceID == "") {
				log(LOG_TAG, "Cannot set the Test Device ID, an incorrect value as been passet. Please use the public constant values available in AdMobManager");
				return;
			}
			
			// Update local instance
			mTestDeviceID = deviceID;
			
			// Make native call
			log(LOG_TAG, "Native setTestDeviceID Call Performed!");
			ctx.call(AdMobFunctions.SET_TEST_DEVICE_ID, mTestDeviceID);
		}
		
		/**
		 * Targeting Gender
		 **/
		public function get gender():int
		{ return mGender; }
		public function set gender(sex:int):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the Gender, the extension is not supported or not initialized");
				return;
			}
			
			// Check if the Extension is Supported
			if (sex < 0 || sex > 3) {
				log(LOG_TAG, "Cannot set the Gender, an incorrect value as been passet. Please use the public constant values available in AdMobManager");
				return;
			}
			// Update local instance
			mGender = sex;
			
			// Now we can create the banner
			log(LOG_TAG, "Native SetGender Call Performed!");
			ctx.call(AdMobFunctions.SET_GENDER, mGender);
		}
		
		/**
		 * Targeting Birth Year
		 * 
		 **/
		public function get birthYear():int
		{ return mBirthYear; }
		public function set birthYear(year:int):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the Birth Year, the extension is not supported or not initialized");
				return;
			}
			
			// Check if the Extension is Supported
			//var thisYear:Number = int(new Date().getFullYear());
			//var minValue:int = thisYear - 100;
			//var maxValue:int = thisYear - 10;
			var minValue:int = 1910;
			var maxValue:int = 2012;
			if (year < minValue || year > maxValue) {
				log(LOG_TAG, "Cannot set the Birth Year, an incorrect value as been passet. The allow value are only Form: " +minValue+ " To: "+maxValue);
				return;
			}
			
			// Update local instance
			mBirthYear = year;
			// Now we can create the banner
			log(LOG_TAG, "Native SetBirthYear Call Performed!");
            ctx.call(AdMobFunctions.SET_BIRTHYEAR, mBirthYear);
		}
		
		/**
		 * Targeting Birth Month
		 * 
		 **/
		public function get birthMonth():int
		{ return mBirthMonth; }
		public function set birthMonth(month:int):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the Birth Month, the extension is not supported or not initialized");
				return;
			}
			
			// Check if the Extension is Supported
			if (month < 1 || month > 12) {
				log(LOG_TAG, "Cannot set the Birth Month, an incorrect value as been passet. The allow value are only Form: 1 To: 12");
				return;
			}
			
			// Update local instance
			mBirthMonth = month;
			// Now we can create the banner
			log(LOG_TAG, "Native SetBirthMonth Call Performed!");
            ctx.call(AdMobFunctions.SET_BIRTHMONTH, mBirthMonth);
		}
		
		/**
		 * Targeting Birth Day
		 * 
		 **/
		public function get birthDay():int
		{ return mBirthDay; }
		public function set birthDay(day:int):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the Birth Day, the extension is not supported or not initialized");
				return;
			}
			
			// Check if the Extension is Supported
			if (day < 1 || day > 31) {
				log(LOG_TAG, "Cannot set the Birth Day, an incorrect value as been passet. The allow value are only Form: 1 To: 31");
				return;
			}
			
			// Update local instance
			mBirthDay = day;
			// Now we can create the banner
			log(LOG_TAG, "Native SetBirthDay Call Performed!");
            ctx.call(AdMobFunctions.SET_BIRTHDAY, mBirthDay);
		}
		
		/**
		 * Targeting Tag For Child Directed Treatment
		 **/
		public function get isCDT():Boolean
		{ return mIsCDT; }
		public function set isCDT(val:Boolean):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot set the tag For Child Directed Treatment, the extension is not supported or not initialized");
				return;
			}
			
			// Update local instance
			mIsCDT = val;
			// Now we can create the banner
			log(LOG_TAG, "Native SetGender Call Performed!");
            ctx.call(AdMobFunctions.SET_CDT, mIsCDT);
		}
		
		// =================================================================================================
		//	Constructor / Deconstructors
		// =================================================================================================
		
		/** 
		 * AdMobManager Constructor
		 * 
		 */
        public function AdMobManager()
		{
            // Create the extension context
			mCtx = ExtensionContext.createExtensionContext(ANE_NAME, null);
            // Check if the context was created
            if (ctx){
				// Add the context event listener
                ctx.addEventListener(StatusEvent.STATUS, onStatus);
            };
        }
		
		/** 
		 * AdMobManager Disposal
		 * 
		 */
        public function dispose():void{
            // Dispose the Extension Context
			if (ctx != null){
                ctx.removeEventListener(StatusEvent.STATUS, onStatus);
                ctx.dispose();
                mCtx = null;
            };
            // Destroy the Manager Instance
            mManager = null;
        }
		
		// =================================================================================================
		//	Manager Banners Functions
		// =================================================================================================
		
		/** 
		 * Create the adMob Banner in relative position<br/>
		 * @see AdmobPosition
		 * @see AdMobSize
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * @param adPosition Banner Position to be used
		 * @param bannerId Unique Banner Id identifier, used for identifie the banner when multiple banner<br/>
		 * are use in the same application. (please note, this is not the adMobId). Optional, if an id is not given an automatic id is generated
		 * @param adMobId Unique AdMobId for the banner. Optional, if an id is not given the common Id will be used
		 * @param autoShow Automatic visualization. Optional, Default = false<br/>
		 * If the autoShow is set to true the banner will be automatically render when is recieved, otherwise will need to be render manualy<br/>
		 * After BANNER_RECIEVED event.
		 */
        public function createBanner(adSize:int,adPosition:int,bannerId:String=null,adMobId:String=null,autoShow:Boolean=false):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot create the banner, the extension is not supported");
				return;
			}
			
			// Check if there is a AdModId available
			if (adMobId == null) adMobId = bannersAdMobId;
			if (adMobId == null) {
				log(LOG_TAG, "Cannot create the banner, the AdMobId is not set. Please pass an Id during banner creation or set the common Id");
				return;
			}
			
			// Check if a banner id was given there or create an id automatically
			if (!bannerId) {
				bannerId = getBannerId();
			}else {
				// Check if the given name already exist
				if (bannersDic.hasOwnProperty(bannerId)) {
					log(LOG_TAG, "Cannot create the banner, the a banner with the same id already exist");
					return;
				}
			}
			
			// Validate the Test Mode Operation
			validateTestMode();
			
			// Set Banner Position
			var positionType:int = AdMobBanner.POS_RELATIVE;
			var position:Array = new Array(adPosition);
			// Create the new AdmobBanner
			var banner:AdMobBanner = new AdMobBanner(adSize,positionType,position,bannerId,adMobId,autoShow);
			// Add the Banner in the Dictionary
			bannersDic[bannerId] = banner;
			
			// Now we can create the banner
			log(LOG_TAG, "Native CreateBanner Call Performed!");
            ctx.call(AdMobFunctions.BANNER_CREATE, bannerId, adMobId, adSize, positionType, adPosition);
        }
		
		/** 
		 * Create the adMob Banner in a given absolute position
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * @param posX Banner x coordinate Position
		 * @param posY Banner y coordinate Position
		 * @param bannerId Unique Banner Id identifier, used for identifie the banner when multiple banner<br/>
		 * are use in the same application. (please note, this is not the adMobId). Optional, if an id is not given an automatic id is generated
		 * @param adMobId Unique AdMobId for the banner. Optional, if an id is not given the common Id will be used
		 * @param autoShow Automatic visualization. Optional, Default = false<br/>
		 * If the autoShow is set to true the banner will be automatically render when is recieved, otherwise will need to be render manualy<br/>
		 * After BANNER_RECIEVED event.
		 */
        public function createBannerAbsolute(adSize:int,posX:Number,posY:Number,bannerId:String=null,adMobId:String=null,autoShow:Boolean=false):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot create the banner, the extension is not supported");
				return;
			}
			
			// Check if there is a AdModId available
			if (!adMobId) adMobId = bannersAdMobId;
			if (!adMobId) {
				log(LOG_TAG, "Cannot create the banner, the AdMobId is not set. Please pass an Id during banner creation or set the common Id");
				return;
			}
			
			// Check if a banner id was given there or create an id automatically
			if (!bannerId) {
				bannerId = getBannerId();
			}else {
				// Check if the given name already exist
				if (bannersDic.hasOwnProperty(bannerId)) {
					log(LOG_TAG, "Cannot create the banner, the a banner with the same id already exist");
					return;
				}
			}
			
			// Validate the Test Mode Operation
			validateTestMode();
			
			// Set Banner Position
			var positionType:int = AdMobBanner.POS_ABSOLUTE;
			var position:Array = new Array(posX,posY);
			// Create the new AdmobBanner
			var banner:AdMobBanner = new AdMobBanner(adSize,positionType,position,bannerId,adMobId,autoShow);
			// Add the Banner in the Dictionary
			bannersDic[bannerId] = banner;
			
			// Now we can create the banner
			log(LOG_TAG, "Native CreateBanner Call Performed!");
            ctx.call(AdMobFunctions.BANNER_CREATE_ABSOLUTE, bannerId, adMobId, adSize, positionType, posX, posY);
        }
		
		/** 
		 * Show a specific Banner
		 * 
		 * @param bannerId Unique Banner Id identifier for the banner to be show.<br/>
		 * Please note, this is not the adMobId.<br/>
		 * If you are not sure about which id the banner has, please access <code>bannersNames</code><br/>
		 * For a full list of created banners id
		 */
        public function showBanner(bannerId:String):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banner, the extension is not supported");
				return;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot show the banner, the given banner id is invalid");
				return;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot show the banner, there is no banner created for the given id");
				return;
			}
			
			// Show the banner according to its type
			log(LOG_TAG, "Native ShowBanner Call Performed!");
			ctx.call(AdMobFunctions.BANNER_SHOW, bannerId);
        }
		
		/** 
		 * Hide a specific Banner
		 * 
		 * @param bannerId Unique Banner Id identifier for the banner to be hide.<br/>
		 * Please note, this is not the adMobId.<br/>
		 * If you are not sure about which id the banner has, please access <code>bannersNames</code><br/>
		 * For a full list of created banners id
		 */
        public function hideBanner(bannerId:String):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot hide the banner, the extension is not supported");
				return;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot hide the banner, the given banner id is invalid");
				return;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot hide the banner, there is no banner created for the given id");
				return;
			}
			
			// Hide the banner
			log(LOG_TAG, "Native HideBanner Call Performed!");
			ctx.call(AdMobFunctions.BANNER_HIDE,bannerId);
        }
		
		/** 
		 * Remove a specific Banner
		 * 
		 * @param bannerId Unique Banner Id identifier for the banner to be hide.<br/>
		 * Please note, this is not the adMobId.<br/>
		 * If you are not sure about which id the banner has, please access <code>bannersNames</code><br/>
		 * For a full list of created banners id.<br/>
		 * <br/>
		 * IMPORTANT: Removing a banner it means completly destroy the banner and its requests.<br/>
		 * A removed banner cannot be show again and it will need to be created again.<br/>
		 * use with caution...
		 */
        public function removeBanner(bannerId:String):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot remove the banner, the extension is not supported");
				return;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot remove the banner, the given banner id is invalid");
				return;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot remove the banner, there is no banner created for the given id");
				return;
			}
			
			// Remove the banner from the dictionary
			bannersDic[bannerId] = null;
			if(bannersDic.hasOwnProperty(bannerId)) delete bannersDic[bannerId];
			
			// Remove the banner
			log(LOG_TAG, "Native RemoveBanner Call Performed!");
			ctx.call(AdMobFunctions.BANNER_REMOVE,bannerId);
        }
		
		/** 
		 * Show all the created banners
		 * 
		 */
        public function showAllBanner():void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banners, the extension is not supported");
				return;
			}
			
			// Process all banner in the dictionary
			for each (var banner:AdMobBanner in bannersDic) 
			{ showBanner(banner.bannerId); }
        }
		
		/** 
		 * Hide all the created banners
		 * 
		 */
        public function hideAllBanner():void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot hide the banners, the extension is not supported");
				return;
			}
			
			// Process all banner in the dictionary
			for each (var banner:AdMobBanner in bannersDic) 
			{ hideBanner(banner.bannerId); }
        }
		
		/** 
		 * Remove all the created banners<br/>
		 * ... use with caution...
		 * 
		 */
        public function removeAllBanner():void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot remove the banners, the extension is not supported");
				return;
			}
			
			// Process all banner in the dictionary
			for each (var banner:AdMobBanner in bannersDic) 
			{ removeBanner(banner.bannerId); }
        }
		
		// =================================================================================================
		//	Manager Interstitial Functions
		// =================================================================================================
		
		/** 
		 * Create the Interstitial
		 * 
		 * @param adMobId Unique AdMobId for the Interstitial. Optional, if an id is not given the common Id will be used
		 * @param autoShow Automatic visualization. Optional, Default = false<br/>
		 * If the autoShow is set to true the Interstitial will be automatically render when ready, otherwise will need to be render manualy<br/>
		 * After INTERSTITIAL_RECIEVED event.
		 */
        public function createInterstitial(adMobId:String=null,autoShow:Boolean=false):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot create the Interstitial, the extension is not supported");
				return;
			}
			
			// Check if the Interstitial was already created
			if (isInterstitialCreated) {
				log(LOG_TAG, "Cannot create the Interstitial, An Interstitial has already been created");
				return;
			}
			
			// Check if there is a AdModId available
			if (!adMobId) adMobId = interstitialAdMobId;
			if (!adMobId) {
				log(LOG_TAG, "Cannot create the Interstitial, the AdMobId is not set. Please pass an Id during Interstitial creation or set the common Id");
				return;
			}
			
			// Validate the Test Mode Operation
			validateTestMode();
			
			// Update Interstitial States
			mIsInterstitialCreated = true;
			mInterstitialAutoShow = autoShow;
			
			// Create the Interstitial
			log(LOG_TAG, "Native CreateInterstitial Call Performed!");
			ctx.call(AdMobFunctions.INTERSTITIAL_CREATE, adMobId);
        }
		
		/** 
		 * Remove the Interstitial
		 * 
		 */
        public function removeInterstitial():void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot remove the banner, the extension is not supported");
				return;
			}
			
			// Check if the Interstitial has been created
			if (!isInterstitialCreated) {
				log(LOG_TAG, "Cannot destroy the Interstitial, The Interstitial has not been created yet");
				return;
			}
			
			// Remove the Interstitial
			log(LOG_TAG, "Native removeInterstitial Call Performed!");
			ctx.call(AdMobFunctions.INTERSTITIAL_REMOVE);
			// Reset states
			mIsInterstitialCreated = false;
			mInterstitialAutoShow = false;
        }
		
		/** 
		 * Cache the Interstitial<br/>
		 * Listent to Event <code>INTERSTITIAL_RECIEVED</code> for know when the caching is complet<br/>
		 * After the Interstitial is recieved you can use also the public method <code>isInterstitialLoaded</code> for check<br/>
		 * if the Interstitial is ready to be visualized.<br/>
		 * 
		 * @param adMobId Unique AdMobId for the Interstitial. Optional, if an id is not given the common Id will be used
		 */
        public function cacheInterstitial(adMobId:String=null):void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot cache the Interstitial, the extension is not supported");
				return;
			}
			
			// Check if there is a AdModId available
			if (!adMobId) adMobId = interstitialAdMobId;
			if (!adMobId) {
				log(LOG_TAG, "Cannot cache the Interstitial, the AdMobId is not set. Please pass an Id during Interstitial creation or set the common Id");
				return;
			}
			
			// Create the Interstitial if it was not yet created
			if (!isInterstitialCreated) {
				log(LOG_TAG, "The Interstitial was not available, an Interstitial will be created");
				createInterstitial(adMobId);
			}
			
			// Create the Interstitial
			log(LOG_TAG, "Native CacheInterstitial Call Performed!");
			ctx.call(AdMobFunctions.INTERSTITIAL_CACHE, adMobId);
        }
		
		/** 
		 * Check if the Interstitial is ready to be visualize.<br/>
		 * Please note that checking this status before creating the Interstitial or recieving its Event <code>INTERSTITIAL_RECIEVED</code> will make nosense.
		 * 
		 * @param Interstitial ready state
		 */
        public function isInterstitialLoaded():Boolean
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "The Interstitial is not ready, and will not be ready, since the extension is not supported");
				return false;
			}
			
			// Check if the Interstitial has already been created
			if (!isInterstitialCreated) {
				log(LOG_TAG, "The Interstitial is not ready, and will not be ready, since the Interstitial was never created");
				return false;
			}
			
			// Create the Interstitial
			log(LOG_TAG, "Native isInterstitialLoaded Call Performed!");
			var result:Boolean = ctx.call(AdMobFunctions.INTERSTITIAL_IS_LOADED);
			// return the call result
			return result;
        }
		
		/** 
		 * Show the Interstitial.<br/>
		 * Please note that a Interstitial cannot be show if it was never created or recieved.
		 * 
		 * @param Interstitial ready state
		 */
        public function showInterstitial():void
		{
			// Check if the Extension is Supported
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the Interstitial, the extension is not supported!");
				return;
			}
			
			// Check if the Interstitial has already been created
			if (!isInterstitialCreated) {
				log(LOG_TAG, "Cannot show the Interstitial, the Interstitial has not yet been created!");
				return;
			}
			
			// Check if the Interstitial is ready to be visualized
			if (!isInterstitialLoaded()) {
				log(LOG_TAG, "Cannot show the Interstitial, the Interstitial is not yet ready!");
				return;
			}
			
			// Create the Interstitial
			log(LOG_TAG, "Native ShowInterstitial Call Performed!");
			ctx.call(AdMobFunctions.INTERSTITIAL_SHOW);
        }
		
		// =================================================================================================
		//	Events Manager
		// =================================================================================================
		
		/** 
		 * Extension Events Manager
		 * Recieve the Event from the context and dispatche it for internal listeners
		 * 
		 * @param event (StatusEvent): Status Event Object
		 */
		private function onStatus(event:StatusEvent):void
		{
			trace("ane event ",event.code,event.level);
			// Event Instance
			var e:AdMobEvent = null;
			
			// Swhich according the recieved even level
			switch(event.code)
			{
				case AdMobEvent.BANNER_LOADED:
				{
					log(LOG_TAG, "Event Recieved: Banner Loaded!");
					var bannerId:String = event.level;
					var banner:AdMobBanner = bannersDic[bannerId];
					if (banner.autoShow) showBanner(bannerId);
					e = new AdMobEvent(AdMobEvent.BANNER_LOADED, event.level);
					break;
				}
				case AdMobEvent.BANNER_FAILED_TO_LOAD:
				{
					log(LOG_TAG, "Event Recieved: Banner Failed to Load!");
					e = new AdMobEvent(AdMobEvent.BANNER_FAILED_TO_LOAD, event.level);
					break;
				}
				case AdMobEvent.BANNER_AD_OPENED:
				{
					log(LOG_TAG, "Event Recieved: Banner Ad Opened!");
					e = new AdMobEvent(AdMobEvent.BANNER_AD_OPENED, event.level);
					break;
				}
				case AdMobEvent.BANNER_AD_CLOSED:
				{
					log(LOG_TAG, "Event Recieved: Banner Ad Closed!");
					e = new AdMobEvent(AdMobEvent.BANNER_AD_CLOSED, event.level);
					break;
				}
				case AdMobEvent.BANNER_LEFT_APPLICATION:
				{
					log(LOG_TAG, "Event Recieved: Banner Has left the Application!");
					e = new AdMobEvent(AdMobEvent.BANNER_LEFT_APPLICATION, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_LOADED:
				{
					log(LOG_TAG, "Event Recieved: Interstitial Loaded!");
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_LOADED, event.level);
					if (mInterstitialAutoShow) showInterstitial();
					break;
				}
				case AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD:
				{
					log(LOG_TAG, "Event Recieved: Interstitial Failed to Load!");
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_AD_OPENED:
				{
					log(LOG_TAG, "Event Recieved: Interstitial Ad Opened!");
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_AD_OPENED, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_AD_CLOSED:
				{
					log(LOG_TAG, "Event Recieved: Interstitial Ad Closed!");
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_AD_CLOSED, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_LEFT_APPLICATION:
				{
					log(LOG_TAG, "Event Recieved: Interstitial Has left the Application!");
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_LEFT_APPLICATION, event.level);
					break;
				}
			}
			// If the event is available dispatch it
			if(e != null) dispatcher.dispatchEvent(e);
		}		
		
		// =================================================================================================
		//	Utilities
		// =================================================================================================
		
		/** 
		 * Validate the use of test mode
		 * 
		 */
        private function validateTestMode():void
		{
			// Skip if we are in Production mode
			if (mOperationMode) return;
			
			// Check if the deide Id is null
			if (mTestDeviceID == null) {
				log(LOG_TAG, "IMPORTANT ALLER: You are using the Test mode, however a test device id was not given!");
				log(LOG_TAG, "Please set the proprierty '.testDeviceID' correctly, in the current state google will register the impression done by the device");
				log(LOG_TAG, "and you may risk to have your account banned!");
				return;
			}
			
			// Check if the deide Id is blank
			if (mTestDeviceID == "") {
				log(LOG_TAG, "IMPORTANT ALLER: You are using the Test mode, however a test device id is blank!");
				log(LOG_TAG, "Please set the proprierty '.testDeviceID' correctly, in the current state google will register the impression done by the device");
				log(LOG_TAG, "and you may risk to have your account banned!");
				return;
			}
			
			// Log the device in which we are testing
			log(LOG_TAG, "Test Mode correctly running on device: " + mTestDeviceID);
        }
		
		/** 
		 * Get a random Banner Id<br/>
		 * The id will be validate to avoid double names in the dictionary
		 * 
		 * @return Resulted banner id
		 */
        public function getBannerId():String
		{
			// Generate the Random Name
			var id:String = generateBannerId();
			// Check if we already have Banners
			if (bannersQuantity > 0) {
				// If soo we need to check the existing names for avoid conflicts, and create a new one if necessary
				while (bannersDic.hasOwnProperty(id)) 
				{id = generateBannerId();}
			}
			// return the created ID
			return id;
        }
		
		/** 
		 * Geenerate a random Banner id
		 * 
		 * @return Resulted banner id
		 */
        public function generateBannerId():String
		{
			// Generate the Random Name
			var id:String = "BannerID";
			var num:int = randomRange(0, 1000000);
			id += num;
			// return the created ID
			return id;
        }
		
		/** 
		 * Get a random value from the given Range
		 * 
		 * @param minNum Minimum number for the range
		 * @param maxNum Minimum number for the range
		 * 
		 * @return Resulted random number
		 */
		private function randomRange(minNum:int, maxNum:int):int
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		
		
		final public function moveBanner(bannerId:String, _arg2:Number, _arg3:Number):void{
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banner, the extension is not supported");
				return;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot show the banner, the given banner id is invalid");
				return;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot show the banner, there is no banner created for the given id");
				return;
			}
			
			// Show the banner according to its type
			log(LOG_TAG, "Native ShowBanner Call Performed!");
			this.ctx.call(AdMobFunctions.BANNER_MOVE, bannerId, _arg2, _arg3);
		}
		final public function rotateBanner(bannerId:String, _arg2:Number):void{
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banner, the extension is not supported");
				return;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot show the banner, the given banner id is invalid");
				return;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot show the banner, there is no banner created for the given id");
				return;
			}
			
			// Show the banner according to its type
			log(LOG_TAG, "Native ShowBanner Call Performed!");
			this.ctx.call(AdMobFunctions.BANNER_ROTATE, bannerId, _arg2);
		}
		final public function getScreenSize():ScreenSize{
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banner, the extension is not supported");
				return null;
			}
			var _local1:ScreenSize = (this.ctx.call(AdMobFunctions.GET_SCREEN_SIZE) as ScreenSize);
			return (_local1);
		}
		final public function getBannerSize(_arg1:int):AdSize{
			if(_arg1==AdMobSize.WIDE_SKYSCRAPER){
				this.log("AdMobAne_AS3", "The wide Skyscrapper banner is not supported by Admob, therefore it cannot be measured before creation. Please create the banner and then use the method getExistingBannerSize. Please note that this kind of banner can only be created on specific mediation network.");
				return null;
			}
			if(_arg1==AdMobSize.SMART_BANNER||_arg1==AdMobSize.SMART_BANNER_LAND||_arg1==AdMobSize.SMART_BANNER_PORT){
				this.log("AdMobAne_AS3", "Smart Banner cannot be measured before creation. Please create the banner and then use the method getExistingBannerSize");
				return null;
			}
			return AdMobSize.typeSize(_arg1);
		}
		final public function getExistingBannerSize(bannerId:String):AdSize{
			if (!isSupported) {
				log(LOG_TAG, "Cannot show the banner, the extension is not supported");
				return null;
			}
			
			// Check if the banner id
			if (bannerId == null) {
				log(LOG_TAG, "Cannot show the banner, the given banner id is invalid");
				return null;
			}
			if (!bannersDic.hasOwnProperty(bannerId)) {
				log(LOG_TAG, "Cannot show the banner, there is no banner created for the given id");
				return null;
			}
			var _local2:AdSize = (this.ctx.call(AdMobFunctions.GET_AD_SIZE, bannerId) as AdSize);
			return (_local2);
		}
		
		// =================================================================================================
		//	Logger Functions
		// =================================================================================================
		
		/**
		 * Log Debug messages if in Verbose Mode
		 *
		 * @param msg Message to be logged
		 * @param args Further args to be included in the log
		 **/
		private function log(msg:String, ... args):void
		{
			// Trace the message if in debug mode
			var now:Number = new Date().time;
			if (verbose) trace('['+LOG_TAG+ ']',msg, args);
		}
	}
}