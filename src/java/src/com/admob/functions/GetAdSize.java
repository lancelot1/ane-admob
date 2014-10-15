package com.admob.functions;

import android.app.Activity;

import com.admob.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.Map;

public class GetAdSize
  implements FREFunction
{
  private static final String CLASS = "GetAdSize - ";
  
  public FREObject call(FREContext context, FREObject[] args)
  {
    try
    {
      ExtensionContext cnt = (ExtensionContext)context;
      Activity act = context.getActivity();
      cnt.log("GetAdSize - call");
      
      String bannerId = args[0].getAsString();
      
      Map<String, Integer> dimensions = cnt.getAdSize(act, bannerId);
      if (dimensions != null)
      {
        FREObject res = FREObject.newObject("com.admob.AdSize", null);
        
        res.setProperty("width", FREObject.newObject(((Integer)dimensions.get("width")).intValue()));
        res.setProperty("height", FREObject.newObject(((Integer)dimensions.get("height")).intValue()));
        

        return res;
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return null;
  }
}
