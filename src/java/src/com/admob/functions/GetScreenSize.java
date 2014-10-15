package com.admob.functions;

import android.app.Activity;

import com.admob.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.Map;

public class GetScreenSize
  implements FREFunction
{
  private static final String CLASS = "GetScreenSize - ";
  
  public FREObject call(FREContext context, FREObject[] args)
  {
    try
    {
      ExtensionContext cnt = (ExtensionContext)context;
      Activity act = context.getActivity();
      cnt.log("GetScreenSize - call");
      
      Map<String, Integer> dimensions = cnt.getScreenSize(act);
      if (dimensions != null)
      {
        FREObject res = FREObject.newObject("com.admob.ScreenSize", null);
        
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
