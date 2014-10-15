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
* SetMode Function Class
* Bridge AS called function to main extension function
*
* @author lancelot1
*/
public class SetMode implements FREFunction {
	// Debug Tag
	private static final String CLASS = "SetMode - ";

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
			Boolean prodMode 		= args[0].getAsBool();
			// Update the context production mode
			cnt.setProdMode(prodMode);
		} catch (Exception e) {
			// Print the exception stack trace
			e.printStackTrace();
		}
		// Return
		return null;
	}
}