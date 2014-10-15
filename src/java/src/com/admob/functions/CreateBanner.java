//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 lancelot1 Inc. All rights reserved.
//

package com.admob.functions;

//Extension includes


//Android Includes
import android.app.Activity;


import com.admob.ExtensionContext;
//Adobe FRE Includes
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * Create Banner Function Class
 * Bridge AS called function to main extension function
 *
 * @author lancelot1
 */
public class CreateBanner implements FREFunction {
	// Debug Tag
	private static final String CLASS = "CreateBanner - ";

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
		// Try to process the call
		try {
			// Get The Extension Context and Activity
			ExtensionContext cnt	= (ExtensionContext) context;
			Activity act			= context.getActivity();
			cnt.log(CLASS+"call");
			// Set the passed parameter
			String bannerId			= args[0].getAsString();
			String adMobId			= args[1].getAsString();
			int adSize				= args[2].getAsInt();
			int posType				= args[3].getAsInt();
			int position			= args[4].getAsInt();
			// Get the Extension context instance
			cnt.createBanner(act,bannerId,adMobId,adSize,posType,position);
		} catch (Exception e) {
			// Print the exception stack trace
			e.printStackTrace();
		}
		// Return
		return null;
	}
}