package com.admob.functions;

import com.admob.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetLayerType
  implements FREFunction
{
  private static final String CLASS = "SetLayerType - ";
  
  public FREObject call(FREContext context, FREObject[] args)
  {
    try
    {
      ExtensionContext cnt = (ExtensionContext)context;
      cnt.log("SetLayerType - call");
      
      int type = args[0].getAsInt();
      
      cnt.setLayerType(type);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return null;
  }
}
