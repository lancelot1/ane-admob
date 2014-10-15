//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code lancelot1 Inc. All rights reserved.
//

package com.admob;

//Java Utilities Includes
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


//Extension function includes

//Google adMob SDK Includes
import com.google.android.gms.ads.AdRequest;



//Android Includes
import android.app.Activity;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.FrameLayout.LayoutParams;



import com.admob.functions.*;
//Adobe FRE Includes
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

/**
 * AdMobANE Extension Context Class
 * The class will define the extension context
 * and Register all the necessary function called from AS to the actual Java functions
 *
 * @author Code lancelot1
 */
public class ExtensionContext extends FREContext {

	// Debug Tag
	private static final String TAG		= "[AdMobAne_JAVA]";
	private static final String CLASS	= "ExtensionContext - ";
	
	// Class Parameters
	private Boolean mProdMode			= false;
	private Boolean mVerbose			= false;
	private RelativeLayout mAdLayout;
	private AdMobInterstitial mInterstitialAd;
	private Map<String, AdMobBanner> mBannersMap;
	
	// Targeting Properties
	private String mTestDeviceID		= "*";
	private int mGender					= 0;
	private int mBirthYear				= 0;
	private int mBirthMonth				= 0;
	private int mBirthDay				= 0;
	private Boolean mIsCDT				= false;
	private int mLayerType;

	/**
	 * Public Getter for Production Mode State
	 * 
	 * @return mProdMode
	 **/
	public Boolean getProdMode() { return mProdMode; }
	
	/**
	 * Public Setter for Production Mode State
	 * 
	 * @param prodMode
	 **/
	public void setProdMode(Boolean prodMode) {
		mProdMode = prodMode;
		log(CLASS+"setProdMode: " +prodMode.toString());
	}
	
	/**
	 * Public Setter for Verbose State
	 * 
	 * @param verbose
	 **/
	public void setVerbose(Boolean verbose) {
		mVerbose = verbose;
		log(CLASS+"setVerbose: " +verbose.toString());
	}

	/**
	 * Public Setter for Test Device ID
	 * 
	 * @param gender
	 **/
	public void setTestDeiceID(String id) {
		mTestDeviceID = id;
		log(CLASS+"setTestDeiceID: " +id);
	}
	
	/**
	 * Public Setter for Targeting Gender
	 * 
	 * @param gender
	 **/
	public void setGender(int gender) {
		mGender = gender;
		log(CLASS+"setGender: " +gender);
	}
	
	/**
	 * Public Setter for Targeting Birth Year
	 * 
	 * @param year
	 **/
	public void setBirthYear(int year) {
		mBirthYear = year;
		log(CLASS+"setBirthYear: " +year);
	}
	
	/**
	 * Public Setter for Targeting Birth Month
	 * 
	 * @param month
	 **/
	public void setBirthMonth(int month) {
		mBirthMonth = month;
		log(CLASS+"setBirthMonth: " +month);
	}
	
	/**
	 * Public Setter for Targeting Birth Day
	 * 
	 * @param month
	 **/
	public void setBirthDay(int day) {
		mBirthDay = day;
		log(CLASS+"setBirthDay: " +day);
	}
	
	/**
	 * Public Setter for Tag For Child Directed Treatment
	 * 
	 * @param month
	 **/
	public void setIsCDT(Boolean cdt) {
		mIsCDT = cdt;
		log(CLASS+"setIsCDT: " +cdt);
	}
	
	// =================================================================================================
	//	Constructor / Deconstructors
	// =================================================================================================
	
	/**
	 * ExtensionContext Constructor
	 * 
	 */
	public ExtensionContext() {
		log(CLASS+"Constructor");
		// By default set the Production mode as false, it will be updated by AS
		mProdMode = false;
		// Create the Banners Map
		mBannersMap = new HashMap<String, AdMobBanner>();
	}
	
    /**
     * Build The Layout for the Ads Views
     * 
     */
	public void buildLayout(Activity act) {
		log(CLASS+"buildLayout");
    	// Create the new relative Layout
    	mAdLayout = new RelativeLayout(act);
    	// Get the current Frame Layout
    	ViewGroup fl = (ViewGroup)act.findViewById(android.R.id.content);
		fl = (ViewGroup)fl.getChildAt(0);
		// Add the new relative Layout to the Frame Layout
		fl.addView(mAdLayout, new FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    }
    
	/**
	 * Map AS function names to Java Function Class
	 * 
	 */
	@Override
	public Map<String, FREFunction> getFunctions() {
		log(CLASS+"getFunctions");
		// Define new function map collection
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

		// Push all necessary functions to the Map
		functionMap.put(ExtensionFunctions.BANNER_CREATE,			new CreateBanner());
		functionMap.put(ExtensionFunctions.BANNER_CREATE_ABSOLUTE,	new CreateBannerAbsolute());
    
		functionMap.put(ExtensionFunctions.BANNER_SHOW,				new ShowBanner());
		functionMap.put(ExtensionFunctions.BANNER_HIDE,				new HideBanner());
		functionMap.put(ExtensionFunctions.BANNER_REMOVE,			new RemoveBanner());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_CREATE,		new CreateInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_REMOVE,		new RemoveInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_SHOW,		new ShowInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_CACHE,		new CacheInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_IS_LOADED,	new IsInterstitialLoaded());
		functionMap.put(ExtensionFunctions.SET_MODE,				new SetMode());
		functionMap.put(ExtensionFunctions.SET_TEST_DEVICE_ID,		new SetTestDeviceID());
		functionMap.put(ExtensionFunctions.SET_VERBOSE,				new SetVerbose());
		functionMap.put(ExtensionFunctions.SET_GENDER,				new SetGender());
		functionMap.put(ExtensionFunctions.SET_BIRTHYEAR,			new SetBirthYear());
		functionMap.put(ExtensionFunctions.SET_BIRTHMONTH,			new SetBirthMonth());
		functionMap.put(ExtensionFunctions.SET_BIRTHDAY,			new SetBirthDay());
		functionMap.put(ExtensionFunctions.SET_CDT,					new SetCDT());
		
    functionMap.put("getAdSize", new GetAdSize());
    functionMap.put("getScreenSize", new GetScreenSize());
    functionMap.put("setLayerType", new SetLayerType());
    functionMap.put("moveBanner", new MoveBanner());
    functionMap.put("rotateBanner", new RotateBanner());
		// Return the Array
	    return functionMap;
	}

	/**
	 * Create and return a new AD request
	 * 
	 * @return Ad Request
	 */
	public AdRequest getRequest() {
    	log("getRequest");
    	log("Request Building...");
		// Create the Banner Request for adMob
		AdRequest.Builder requestBld = new AdRequest.Builder();
		
		// Set the Targeting Gender if it was specified
    	if (mGender>0){
    		String target = "Male";
    		if (mGender == 2) target = "Female";
        	log("Adding Gender Targeting!, Target: " + target);
    		requestBld.setGender(mGender);
    	}
		
		// Set the Birth Date if it was specified
    	if(mBirthYear>0){
    		int year = mBirthYear;
    		int month = 1;
    		int day = 1;
    		if(mBirthMonth>0) month = mBirthMonth;
    		if(mBirthDay>0) day = mBirthDay;
        	log("Adding Birth Date Targeting!, Birth Date = Year: " + year + " month: "+month+" day: "+day);
    		requestBld.setBirthday(new GregorianCalendar(year, month, day).getTime());
    	}
    	
		// Set the Tag For Child Directed Treatment if it was specified
    	if(mIsCDT){
        	log("Adding Tag For Child Directed Treatment Targeting!");
    		requestBld.tagForChildDirectedTreatment(mIsCDT);
    	}
		
		// Add test device if not in production mode
    	if (!mProdMode){
        	log("Setting the request as Test mode!");
    		requestBld.addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
    		requestBld.addTestDevice(mTestDeviceID);
    	}
		// Build and return the Request
		AdRequest request = requestBld.build();
		return request;
	}

	/**
	 * Dispose the context content
	 * 
	 */
	@Override
	public void dispose() {
		log(CLASS+"dispose");
		// Remove all available Ads in the Map
		for (String bannerId : mBannersMap.keySet()) {
			removeBanner(bannerId);
		}
		// Clear the map
		mBannersMap = null;
	}

	// =================================================================================================
	//	Manager Banners Functions
	// =================================================================================================
	
	/**
	 * Create the Banner in relative layout
	 * 
	 * @param act Activity instance
	 * @param bannerId Unique banner ID
	 * @param adMobId AdMobId
	 * @param adSize Banner size index
	 * @param posType Type of position (POS_RELATIVE|POS_ABSOLUTE)
	 * @param position Banner Position
	 * 
	 */
	public void createBanner(Activity act,String bannerId,String adMobId,int adSize,int posType,int position) {
		log(CLASS+"createBanner");
		if(mAdLayout == null) buildLayout(act);
		// Add the Banner to the Banners Map
		mBannersMap.put(bannerId, new AdMobBanner(
				this, act, mAdLayout, bannerId, adMobId, adSize, posType, position, 0));
		// Create the Banner
		mBannersMap.get(bannerId).create();
	}
	
	/**
	 * Create the Banner in absolute layout
	 * 
	 * @param act Activity instance
	 * @param bannerId Unique banner ID
	 * @param adMobId AdMobId
	 * @param adSize Banner size index
	 * @param posType Type of position (POS_RELATIVE|POS_ABSOLUTE)
	 * @param positionX Banner X Position
	 * @param positionY Banner Y Position
	 * 
	 */
	public void createBannerAbsolute(Activity act,String bannerId,String adMobId,int adSize,int posType,int positionX, int positionY) {
		log(CLASS+"createBannerAbsolute");
		if(mAdLayout == null) buildLayout(act);
		// Add the Banner to the Banners Map
		mBannersMap.put(bannerId, new AdMobBanner(
				this, act, mAdLayout, bannerId, adMobId, adSize, posType, positionX, positionY));
		// Create the Banner
		mBannersMap.get(bannerId).create();
	}
	
	/**
	 * Remove the Banner
	 * 
	 * @param bannerId Banner id to be removed
	 */
	public void removeBanner(String bannerId) {
		log(CLASS+"removeBanner");
		// Remove the Banner
		mBannersMap.get(bannerId).remove();
		// Remove the Banner from the Banners Map
		mBannersMap.remove(bannerId);
	}

	/**
	 * Show the Banner
	 * 
	 * @param bannerId Banner id to be show
	 */
	public void showBanner(String bannerId) {
		log(CLASS+"showBanner");
		// Remove the Banner
		mBannersMap.get(bannerId).show();
	}

	/**
	 * Hide the Banner
	 * 
	 * @param bannerId Banner id to be hide
	 */
	public void hideBanner(String bannerId) {
		log(CLASS+"hideBanner");
		// Remove the Banner
		mBannersMap.get(bannerId).hide();
	}
	
	// =================================================================================================
	//	Manager Interstitial Functions
	// =================================================================================================
	
	/**
	 * Create the Interstitial
	 * 
	 * @param act Activity instance
	 * @param interstitialId AdMobId
	 */
	public void createInterstitial(Activity act,String interstitialId) {
		log(CLASS+"createInterstitial");
		log(CLASS+"interstitialId: "+interstitialId);

		// Create the Banner
		mInterstitialAd =  new AdMobInterstitial(this, act, interstitialId);
		mInterstitialAd.create();
	}
	
	/**
	 * Cache the Interstitial
	 * 
	 */
	public void cacheInterstitial() {
		log(CLASS+"cacheInterstitial");
		// Cache the Banner
		mInterstitialAd.cache();
	}
	
	/**
	 * Remove the Interstitial
	 * 
	 */
	public void removeInterstitial() {
		log(CLASS+"removeBanner");
		// Remove the Interstitial
		mInterstitialAd.remove();
		mInterstitialAd = null;
	}

	/**
	 * Check the Interstitial Load state
	 * 
	 */
	public Boolean isInterstitialLoaded() {
		log(CLASS+"isInterstitialLoaded");
		// Check the Interstitial
		return mInterstitialAd.isLoaded();
	}
	
	/**
	 * Show the Interstitial
	 * 
	 */
	public void showInterstitial() {
		log(CLASS+"showInterstitial");
		// Cache the Banner
		mInterstitialAd.show();
	}
	
	 public Map<String, Integer> getScreenSize(Activity act)
	  {
	    log("ExtensionContext - getScreenSize");
	    DisplayMetrics metric = new DisplayMetrics();
	    act.getWindowManager().getDefaultDisplay().getMetrics(metric);
	    int width = metric.widthPixels;
	    int height = metric.heightPixels;
	    
	    Map<String, Integer> screenSize = new HashMap();
	    
	    screenSize.put("width", Integer.valueOf(width));
	    screenSize.put("height", Integer.valueOf(height));
	    

	    return screenSize;
	  }
	  
	  public Map<String, Integer> getAdSize(Activity act, String bannerId)
	  {
	    log("ExtensionContext - getAdSize");
	    

	    return ((AdMobBanner)this.mBannersMap.get(bannerId)).measure(act);
	  }
	  
	  public int getLayerType()
	  {
	    return this.mLayerType;
	  }
	  
	  public void setLayerType(int type)
	  {
	    this.mLayerType = type;
	    log("ExtensionContext - setLayerType: " + type);
	  }
	  public void moveBanner(String bannerId, int positionX, int positionY)
	  {
	    log("ExtensionContext - moveBanner");
	    
	    ((AdMobBanner)this.mBannersMap.get(bannerId)).move(positionX, positionY);
	  }
	  public void rotateBanner(String bannerId, float angle)
	  {
	    log("ExtensionContext - rotateBanner");
	    
	    ((AdMobBanner)this.mBannersMap.get(bannerId)).rotate(angle);
	  }
	
	// =================================================================================================
	//	Logger Functions
	// =================================================================================================
	
	/**
	 * Log a message
	 * 
	 */
	public void log(String msg) {
		// Log the message only if in verbose mode
		if(mVerbose) Log.d(TAG,msg);
	}
}
