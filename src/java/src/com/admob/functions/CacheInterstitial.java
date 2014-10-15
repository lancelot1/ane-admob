//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code lancelot1 Inc. All rights reserved.
//

package com.admob.functions;

//Extension includes

import com.admob.ExtensionContext;
//Adobe FRE Includes
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * Cache Interstitial Function Class
 * Bridge AS called function to main extension function
 *
 * @author Code lancelot1
 */
public class CacheInterstitial implements FREFunction {
	// Debug Tag
	private static final String CLASS = "CacheInterstitial - ";
	
	/**
	 * Process the Call.
	 * 
     * @param ctx Extension context used to invoke the method
     * @param args Collection of the parameters passed to the method, one FREObject for each parameter.
     * 
	 * @return Returning FREObject
	 */
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		// Set the passed parameter
		ExtensionContext cnt	= (ExtensionContext) context;
		cnt.log(CLASS+"call");
		// Get the Extension context instance
		cnt.cacheInterstitial();
		
		// Return
		return null;
	}
}