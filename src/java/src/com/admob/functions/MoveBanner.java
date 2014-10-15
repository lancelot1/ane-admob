package com.admob.functions;

import com.admob.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class MoveBanner
  implements FREFunction
{
  private static final String CLASS = "MoveBanner - ";
  
  public FREObject call(FREContext context, FREObject[] args)
  {
    try
    {
      ExtensionContext cnt = (ExtensionContext)context;
      cnt.log("MoveBanner - call");
      
      String bannerId = args[0].getAsString();
      int positionX = args[1].getAsInt();
      int positionY = args[2].getAsInt();
      
      cnt.moveBanner(bannerId, positionX, positionY);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return null;
  }
}
