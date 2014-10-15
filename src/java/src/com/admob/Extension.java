//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code lancelot1 Inc. All rights reserved.
//

package com.admob;

//Adobe FRE Includes
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * AdMobAne Extension Class
 * The class will generate the context for AS-Android integration
 *
 * @author Code lancelot1
 */
public class Extension implements FREExtension {
	
	// Context definition
	public static FREContext context;
	
	/**
	 * Create the Extension.
	 * 
     * @param extId [String] unique extension Id identifier
	 */
	@Override
	public FREContext createContext(String extId)
	{
		context = new ExtensionContext();
		return context;
	}

	/**
	 * Dispose the Extension.
	 * 
	 */
	@Override
	public void dispose()
	{
		context.dispose();
		context = null;
	}

	/**
	 * Initialise the Extension.
	 * 
	 */
	@Override
	public void initialize() {}
}
