package
{
	// Ane Extension Imports
	import com.admob.AdMobManager;
	
	// Flash Imports
	import flash.display.Sprite;

	/** 
	 * Interstitial Class<br/>
	 * The class will construct The Interstitial Example
	 *
	 **/
	public class Interstitial extends Sprite
	{
		public static const banner_id:String="banner id";
		public static const full_id:String="intersitial id";
		private var adMobManager:AdMobManager;
		private var isShow:Boolean = false;
		
		/** 
		 * Interstitial Constructor
		 *
		 **/
		public function Interstitial()
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
					adMobManager.interstitialAdMobId = full_id//"ADMOB_IOS_INTERSTITIAL_ID";
				}else{
					adMobManager.interstitialAdMobId =full_id;// "ADMOB_ANDROID_INTERSTITIAL_ID";
				}
				
				// Set Targetting Settings [Optional]
				adMobManager.gender = AdMobManager.GENDER_MALE;
				adMobManager.birthYear = 1996;
				adMobManager.birthMonth = 1;
				adMobManager.birthDay = 24;
				adMobManager.isCDT = true;
				
				// Create The Banner
				adMobManager.createInterstitial(null,true);
			}			
		}
	}
}