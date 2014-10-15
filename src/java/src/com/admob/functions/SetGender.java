//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 lancelot1 Inc. All rights reserved.
//

package com.admob.functions;

//Extension includes

import com.admob.ExtensionContext;
//Adobe FRE Includes
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
* Set Gender Function Class
* Bridge AS called function to main extension function
*
* @author lancelot1
*/
public class SetGender implements FREFunction {
	// Debug Tag
	private static final String CLASS = "SetGender - ";

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
			// Get The Extension Context
			ExtensionContext cnt	= (ExtensionContext) context;
			cnt.log(CLASS+"call");
			// Set the passed parameter
			int gender 		= args[0].getAsInt();
			// Update the context production mode
			cnt.setGender(gender);
		} catch (Exception e) {
			// Print the exception stack trace
			e.printStackTrace();
		}
		// Return
		return null;
	}
}