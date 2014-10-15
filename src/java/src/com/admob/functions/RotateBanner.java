package com.admob.functions;

import com.admob.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class RotateBanner
  implements FREFunction
{
  private static final String CLASS = "RotateBanner - ";
  
  public FREObject call(FREContext context, FREObject[] args)
  {
    try
    {
      ExtensionContext cnt = (ExtensionContext)context;
      cnt.log("RotateBanner - call");
      
      String bannerId = args[0].getAsString();
      double dAngle = args[1].getAsDouble();
      
      cnt.rotateBanner(bannerId, (float)dAngle);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return null;
  }
}
