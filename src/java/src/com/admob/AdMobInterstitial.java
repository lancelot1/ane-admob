//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code lancelot1 Inc. All rights reserved.
//

package com.admob;

//Android Includes
import android.app.Activity;

//Google adMob SDK Includes
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;

/**
 * AdMob Interstitial Class
 * The class will create and manage the Ad Interstitial
 *
 * @author Code lancelot1
 */
public class AdMobInterstitial {
	// Debug Tag
	private static final String CLASS = "AdMobInterstitial - ";

	// Interstitial unit AD Label
	public static final String INTER_ID	= "InterstitialAd";
	
	// Working Instances
	private ExtensionContext mContext;
	private Activity mActivity;
	private InterstitialAd mInterstitialAd;

	// Banner Propriety
    private String mInterstitialId;
	
	/**
	 * Public Getter for Extension Context
	 * 
	 * @return Extension Context Instance
	 **/
	public ExtensionContext getContext() { return mContext; }
	
	/**
	 * Public Getter for Extension Activity
	 * 
	 * @return Extension Activity Instance
	 **/
	public Activity getActivity() { return mActivity; }
	
	/**
	 * AdMob Interstitial Constructor
	 * 
	 * @param ctx Extension context instance
	 * @param act Activity instance
	 * @param interstitialId AdMobId
	 **/
    public AdMobInterstitial(ExtensionContext ctx, Activity act, String interstitialId)
    {
    	// Set Interstitial working Instances
    	mContext		= ctx;
    	mActivity		= act;

    	// Set Interstitial Propriety
    	mInterstitialId	= interstitialId;
    }
    
	/**
	 * Create the interstitial
	 * 
	 */
	public void create() {
    	mContext.log(CLASS+"create interstitial");

		// Create the interstitial.
		mInterstitialAd = new InterstitialAd(mActivity);
		mInterstitialAd.setAdUnitId(mInterstitialId);
		
    	mContext.log(CLASS+"set interstitial Listeners");
		// Add the Listener for the InterstitialAd
		mInterstitialAd.setAdListener(new AdListener() {
			/**
			 * onAdLoaded Callback
			 */
            @Override
            public void onAdLoaded() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.INTERSTITIAL_LOADED, INTER_ID);
            }
			/**
			 * onAdFailedToLoad Callback
			 */
            @Override
            public void onAdFailedToLoad(int error) {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.INTERSTITIAL_FAILED_TO_LOAD, INTER_ID);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdOpened() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.INTERSTITIAL_AD_OPENED, INTER_ID);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdClosed() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.INTERSTITIAL_AD_CLOSED, INTER_ID);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdLeftApplication() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.INTERSTITIAL_LEFT_APPLICATION, INTER_ID);
            }
        });
		
    	mContext.log(CLASS+"set interstitial Request");
		// Get the interstitial Request for adMob
		AdRequest request = mContext.getRequest();
		//AdRequest request = getRequest();
		// Load the ad
    	mContext.log(CLASS+"load interstitial Request");
		mInterstitialAd.loadAd(request);
	}
	
	/**
	 * Remove the Interstitial
	 * 
	 */
	public void remove() {
    	mContext.log(CLASS+"remove");
    	mContext		= null;
    	mActivity		= null;
    	mInterstitialId	= null;
	}
	
	/**
	 * Cache the interstitial
	 * 
	 */
	public void cache() {
    	mContext.log(CLASS+"cache interstitial");
    	mContext.log(CLASS+"set interstitial Request");
		// Get the interstitial Request for adMob
		AdRequest request = mContext.getRequest();
		//AdRequest request = getRequest();
		// Load the ad
    	mContext.log(CLASS+"load interstitial Request");
		mInterstitialAd.loadAd(request);
	}
	
	/**
	 * Check if the Interstitial is loaded
	 * 
	 * @return Interstitial Load state
	 */
	public Boolean isLoaded() {
    	mContext.log(CLASS+"isLoaded: "+mInterstitialAd.isLoaded());
		// Check the Interstitial
		return mInterstitialAd.isLoaded();
	}
	
	/**
	 * Show the interstitial
	 * 
	 */
	public void show() {
    	mContext.log(CLASS+"show");
		// Show the Interstitial
		mInterstitialAd.show();
	}
}
