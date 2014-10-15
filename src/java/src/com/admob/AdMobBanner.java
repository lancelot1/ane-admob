//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code lancelot1 Inc. All rights reserved.
//

package com.admob;

//Android Includes
import java.util.HashMap;

import android.app.Activity;
import android.os.Build;
import android.view.View;
import android.widget.RelativeLayout;


//Google adMob SDK Includes
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

/**
 * AdMob Banner Class
 * The class will create and manage the Ad Banner
 *
 * @author Code lancelot1
 */
public class AdMobBanner {
	// Debug Tag
	private static final String CLASS = "AdMobBanner - ";
	
	// Position Types Constants
	//private static int POS_RELATIVE		= 0;
	private static int POS_ABSOLUTE		= 1;
	
	// Working Instances
	private ExtensionContext mContext;	// Extension Context
	private Activity mActivity;			// Extension Activity
	private RelativeLayout mAdLayout;	// adView Instance
	private AdView mAdView;				// adView Instance

	// Banner Propriety
    private String mBannerId;
    private String mAdMobId;
    private AdSize mAdMobSize;
    private int mAdPositionType;
    private int mAdRelPosition;
    private int mAdAbsPositionX;
    private int mAdAbsPositionY;
	
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
	 * Public Getter for Banner AdView
	 * 
	 * @return Banner AdView Instance
	 **/
	public AdView getAdView() { return mAdView; }

	/**
	 * AdMobBanner Constructor
	 * 
	 * @param ctx Extension context instance
	 * @param act Activity instance
	 * @param lay Layout Instance
	 * @param bannerId Unique banner ID
	 * @param adMobId AdMobId
	 * @param adSize Banner size index
	 * @param posType Type of position (POS_RELATIVE|POS_ABSOLUTE)
	 * @param position1 First position data
	 * @param position2 Second position data
	 * 
	 **/
    public AdMobBanner(
    		ExtensionContext ctx, Activity act, RelativeLayout lay, 
    		String bannerId, String adMobId, int adSize, 
    		int posType, int position1, int position2)
    {
    	// Set banner working Instances
    	mContext	= ctx;
    	mActivity	= act;
    	mAdLayout	= lay;

    	mContext.log(CLASS+"Constructor");

    	// Set banner Propriety
        mBannerId		= bannerId;
        mAdMobId		= adMobId;
        mAdMobSize		= getAdSize(adSize);
        mAdPositionType	= posType;
        mAdRelPosition	= mAdAbsPositionX = position1;
        mAdAbsPositionY = position2;
    }
    public HashMap<String, Integer> measure(Activity act)
    {
      this.mContext.log("AdMobBanner - remove");
      if (this.mAdMobSize == null) {
        return null;
      }
      int widthInPixels = this.mAdMobSize.getWidthInPixels(act);
      int heightInPixels = this.mAdMobSize.getHeightInPixels(act);
      
      HashMap<String, Integer> bannerSize = new HashMap();
      
      bannerSize.put("width", Integer.valueOf(widthInPixels));
      bannerSize.put("height", Integer.valueOf(heightInPixels));
      

      return bannerSize;
    }
	/**
	 * Create the Banner
	 * 
	 */
	public void create() {
    	mContext.log(CLASS+"create adview");

    	// Create the new adView
		mAdView = new AdView(mActivity);
		mAdView.setAdUnitId(mAdMobId);
		mAdView.setAdSize(mAdMobSize);

		// Force Hardware Rendering on supported devices
    	if (Build.VERSION.SDK_INT >= 11) {
    		mAdView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
    	}
    	mContext.log(CLASS+"set adview Listeners");
		// Add the Listener for the adView
		mAdView.setAdListener(new AdListener() {
			/**
			 * onAdLoaded Callback
			 */
            @Override
            public void onAdLoaded() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_LOADED, mBannerId);
            }
			/**
			 * onAdFailedToLoad Callback
			 */
            @Override
            public void onAdFailedToLoad(int error) {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_FAILED_TO_LOAD, mBannerId);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdOpened() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_AD_OPENED, mBannerId);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdClosed() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_AD_CLOSED, mBannerId);
            }
			/**
			 * onReceiveAd Callback
			 */
            @Override
            public void onAdLeftApplication() {
            	// Dispatch event to AS
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_LEFT_APPLICATION, mBannerId);
            }
        });
		
		// Set the adView visibility as hidden by default
		mAdView.setVisibility(View.GONE);
    	mContext.log(CLASS+"set adview Layout");
		
		// Set the view Position in the layout
		RelativeLayout.LayoutParams layoutParams;
		if(mAdPositionType == POS_ABSOLUTE){
			layoutParams = getAbsoluteParams();
		}else{
			layoutParams = getRelativeParams();
		}
		mAdLayout.addView(mAdView, layoutParams);
    	mContext.log(CLASS+"set adview Request");
		// Create the Banner Request for adMob
		AdRequest request = mContext.getRequest();

		// Load the ad
    	mContext.log(CLASS+"load adview Request");
		mAdView.loadAd(request);
	}
	
	/**
	 * Remove the Ad
	 * 
	 */
	public void remove() {
    	mContext.log(CLASS+"remove");
		// If a Layout is available remove the banner view
		if(mAdLayout != null)
		{
			// Remove views
			mAdLayout.removeView(mAdView);
			// Clear the adView instance
			mAdView = null;
		}
	}
	
	/**
	 * Show the Ad
	 * 
	 */
	public void show() {
    	mContext.log(CLASS+"show");
		// Set the adView visibility
		mAdView.setVisibility(View.VISIBLE);
		// Resume ad activity
		mAdView.resume();
	}
	
	/**
	 * Hide the Ad
	 * 
	 */
	public void hide() {
    	mContext.log(CLASS+"hide");
		// Set the adView visibility
		mAdView.setVisibility(View.GONE);
		// Pause ad activity
		mAdView.pause();
	}
	 public void move(int positionX, int positionY)
	  {
	    this.mContext.log("AdMobBanner - move");
	    

	    this.mAdAbsPositionX = positionX;
	    this.mAdAbsPositionY = positionY;
	    

	    RelativeLayout.LayoutParams layoutParams = getAbsoluteParams();
	    
	    this.mAdView.setLayoutParams(layoutParams);
	  }
	 public void rotate(float angle)
	  {
	    this.mContext.log("AdMobBanner - rotate");
	    this.mContext.log("AdMobBanner - Rotation Agnle: " + angle);
	    if (Build.VERSION.SDK_INT >= 11) {
	      this.mAdView.setRotation(angle);
	    } else {
	      this.mContext.log("AdMobBanner - Android version uncompatible with rotation function");
	    }
	  }
	
	/**
	 * Get the view Absolute Layout Parameters
	 * 
	 * @return Calculated Layout Parameters
	 */
	private RelativeLayout.LayoutParams getAbsoluteParams() {
    	mContext.log(CLASS+"getAbsoluteParams");
		// Define returning instance
		RelativeLayout.LayoutParams params;
		
    	// Set banner coordinates
		int bannerWidth = mAdMobSize.getWidth();
		int bannerHeight = mAdMobSize.getHeight();
		
    	// Create the Parameters
		params = new RelativeLayout.LayoutParams (-2, -2);
    	// Set the Layout Margins
		params.leftMargin = mAdAbsPositionX;
		params.topMargin = mAdAbsPositionY;
		
    	mContext.log(CLASS+"Absolute Params = width: "+bannerWidth+", height: "+bannerHeight+", x: "+mAdAbsPositionX+", y: "+mAdAbsPositionY);
        // Return the Parameters
        return params;
	}
	
	/**
	 * Get the view Relative Layout Parameters
	 * 
	 * @return Calculated Layout Parameters
	 */
	private RelativeLayout.LayoutParams getRelativeParams() {
    	mContext.log(CLASS+"getRelativeParams");
		// Define instances
        int firstVerb;
        int secondVerb;
        int anchor = RelativeLayout.TRUE;
		RelativeLayout.LayoutParams params;
		
		// Create the Parameters
		params = new RelativeLayout.LayoutParams (-2, -2);
        
        // Set the alignment verbs according to the given position
        switch(mAdRelPosition)
        {
        case 1: // TOP_LEFT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_LEFT;
            break;
        case 2: // TOP_CENTER
        	firstVerb	= RelativeLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.CENTER_HORIZONTAL;
            break;
        case 3: // TOP_RIGHT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_RIGHT;
            break;
        case 4: // MIDDLE_LEFT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_LEFT;
        	secondVerb	= RelativeLayout.CENTER_VERTICAL;
            break;
        case 5: // MIDDLE_CENTER
        	firstVerb	= RelativeLayout.CENTER_HORIZONTAL;
        	secondVerb	= RelativeLayout.CENTER_VERTICAL;
            break;
        case 6: // MIDDLE_RIGHT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_RIGHT;
        	secondVerb	= RelativeLayout.CENTER_VERTICAL;
            break;
        case 7: // BOTTOM_LEFT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_LEFT;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_BOTTOM;
            break;
        case 8: // BOTTOM_CENTER
        	firstVerb	= RelativeLayout.CENTER_HORIZONTAL;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_BOTTOM;
            break;
        case 9: // BOTTOM_RIGHT
        	firstVerb	= RelativeLayout.ALIGN_PARENT_RIGHT;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_BOTTOM;
            break;
        default: // TOP_CENTER
        	firstVerb	= RelativeLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.CENTER_HORIZONTAL;
            break;
        }
        // Set the alignment rules
    	params.addRule(firstVerb,anchor);
    	params.addRule(secondVerb,anchor);
    	mContext.log(CLASS+"Relative Params = first Verb: "+firstVerb+", second Verb: "+secondVerb+", anchor: "+anchor);
        // Return the Parameters
        return params;
	}
	
	/**
	 * Get the respective adSize according to the given index
	 * 
	 * @param idx adSize index to be searched
	 * 
	 * @return found adSize instance
	 */
	private AdSize getAdSize(int idx) {
    	mContext.log(CLASS+"getAdSize, idx: "+idx);
        // Return the AdSize according to the given index
		if(idx == 0)		return AdSize.BANNER;
        else if(idx == 1)	return AdSize.MEDIUM_RECTANGLE;
        else if(idx == 2)	return AdSize.FULL_BANNER;
        else if(idx == 3)	return AdSize.LEADERBOARD;
        else if(idx == 4)	return AdSize.WIDE_SKYSCRAPER;
        else if(idx == 5)	return AdSize.SMART_BANNER;
        else if(idx == 6)	return AdSize.SMART_BANNER;
        else if(idx == 7)	return AdSize.SMART_BANNER;
        else if(idx == 8)	return AdSize.LARGE_BANNER;
        // Return the default if not found
        return AdSize.BANNER;
	}
}
