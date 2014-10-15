package
{
	// Ane Extension Imports
	import com.admob.*;
//	import com.codealchemy.ane.admobane.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/** 
	 * Multibanners Class<br/>
	 * The class will construct The Multi Banners Example
	 *
	 **/
	public class Multibanners extends Sprite
	{
		public static const banner_id:String="banner id";
		public static const full_id:String="your interstitial id";
		private var adMobManager:AdMobManager;
		private var isShow:Boolean = false;
		
		/** 
		 * Multibanners Constructor
		 *
		 **/
		public function Multibanners()
		{
			// Init Sprite
			super();
			// Get the AdMobManager instance
			adMobManager = AdMobManager.manager;
			// Check if the Extension is supported
			if(adMobManager.isSupported){
				// Set Operation settings
				adMobManager.verbose = true;
				adMobManager.operationMode = AdMobManager.TEST_MODE;
				
				// Set AdMobId settings
//				if (adMobManager.device == AdMobManager.IOS){
//				}else{
//				}
				adMobManager.bannersAdMobId = banner_id;//"ADMOB_IOS_BANNER_ID";
				adMobManager.interstitialAdMobId = full_id;//"ADMOB_ANDROID_BANNER_ID";
				
				// Set Targetting Settings [Optional]
				adMobManager.gender = AdMobManager.GENDER_MALE;
				adMobManager.birthYear = 1996;
				adMobManager.birthMonth = 1;
				adMobManager.birthDay = 24;
				adMobManager.isCDT = true;
				
				// Create Multiple Banners [In this case 2]
				adMobManager.createBanner(AdMobSize.SMART_BANNER,AdMobPosition.MIDDLE_CENTER,"BottomBanner1", null, true);
				adMobManager.createBanner(AdMobSize.BANNER,AdMobPosition.BOTTOM_CENTER,"BottomBanner2", null, true);
				adMobManager.cacheInterstitial();
				// Function Button
				var txtFormat:TextFormat = new TextFormat(null,38);
				var funcButton:TextField = new TextField();
				funcButton.width = 200;
				funcButton.height = 48;
				funcButton.defaultTextFormat = txtFormat;
				funcButton.text = "SHOW/HIDE BANNERS";
				addChild(funcButton);
				funcButton.addEventListener(MouseEvent.CLICK,onClick);
				funcButton.x=100;
				funcButton.border=true;
				funcButton.y=100;
			}			
		}
		
		/** 
		 * Hide/Show function Event Listener
		 *
		 **/
		private function onClick(e:Event):void
		{
			trace(adMobManager.isInterstitialLoaded(),"------------------");
			if(adMobManager.isInterstitialLoaded()){				
				adMobManager.showInterstitial();
			}else{
				adMobManager.cacheInterstitial();
			}
			if(isShow){
				adMobManager.hideAllBanner();
				//adMobManager.hideBanner("BottomBanner1");
				//adMobManager.hideBanner("BottomBanner2");
				isShow = false;
			}else{
//				adMobManager.rotateBanner("BottomBanner1",Math.PI/2);
//				adMobManager.moveBanner("BottomBanner2",50,150);
				adMobManager.showAllBanner();
				isShow = true;
			}
			
			var  screenSize:ScreenSize=adMobManager.getScreenSize();
			trace("screenSize ",screenSize.width,screenSize.height);
			var adSize:AdSize=adMobManager.getBannerSize(AdMobSize.FULL_BANNER);
			trace("adSize ",adSize.width,adSize.height);
			var exitSize:AdSize=adMobManager.getExistingBannerSize("BottomBanner2");
			trace("exitsize ",exitSize.width,exitSize.height);
		}
	}
}