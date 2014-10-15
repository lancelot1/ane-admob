package
{
	// Ane Extension Imports
	import com.admob.*;
	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/** 
	 * Singlebanner Class<br/>
	 * The class will construct The Single Banner Example
	 *
	 **/
	public class Singlebanner extends Sprite
	{
		public static const banner_id:String="your banner id";
		public static const full_id:String="your full id";
		private var adMobManager:AdMobManager;
		private var isShow:Boolean = false;
		
		/** 
		 * Singlebanner Constructor
		 *
		 **/
		public function Singlebanner()
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
				if (adMobManager.device == AdMobManager.IOS){
					adMobManager.bannersAdMobId =banner_id;// "ADMOB_IOS_BANNER_ID";
				}else{
					adMobManager.bannersAdMobId =full_id;// "ADMOB_ANDROID_BANNER_ID";
				}
				
				// Set Targetting Settings [Optional]
				adMobManager.gender = AdMobManager.GENDER_MALE;
				adMobManager.birthYear = 1996;
				adMobManager.birthMonth = 1;
				adMobManager.birthDay = 24;
				adMobManager.isCDT = true;
				
				// Create The Banner
				adMobManager.createBanner(AdMobSize.BANNER,AdMobPosition.MIDDLE_CENTER,"BottomBanner", null, true);
				
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
			adMobManager.showInterstitial();
			if(isShow){
				adMobManager.hideAllBanner();
				//adMobManager.hideBanner("BottomBanner");
				isShow = false;
			}else{
				adMobManager.showAllBanner();
				adMobManager.moveBanner("BottomBanner",10,60);
				//adMobManager.showBanner("BottomBanner");
				isShow = true;
			}
		}
	}
}