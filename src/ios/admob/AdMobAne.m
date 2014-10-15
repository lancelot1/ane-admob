//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobAne.m
//  AdMobAneExtension
//
//  Copyright (c) 2011-2015  lancelot Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AdMobAne.h"
#import "AdMobFunctions.h"
#import "AdMobBanner.h"
#import "AdMobInterstitial.h"

// Debug Tag
const NSString *TAG = @"[AdMobAne_OBJC]";

// Class Parameters
FREContext mContext;
BOOL mProdMode;
BOOL mVerbose;
AdMobInterstitial *mInterstitialAd;
NSMutableDictionary *mBannersMap;

// Targeting Proprieties
NSString *mTestDeviceID;
uint8_t mGender;
uint16_t mBirthYear;
uint8_t mBirthMonth;
uint8_t mBirthDay;
BOOL mIsCDT;

// =================================================================================================
//	Context Functions
// =================================================================================================

/**
 * Add a Banner to the Dictionary
 *
 */
void addStoredBanner(id object, NSString *bannerId)
{
    Log(@"addStoredBanner");
    [mBannersMap setValue:object forKey:bannerId];
}

/**
 * Get an existing Banner from the Dictionary
 *
 */
id getStoredBanner(NSString *key)
{
    Log(@"getStoredBanner");
    id object = [mBannersMap valueForKey:key];
    Log(@"Got something?");
    if (object) Log(@"has Object!");
    return object;
}

/**
 * Remove an existing Banner from the Dictionary
 *
 */
void removeStoredBanner(NSString *bannerId)
{
    Log(@"removeStoredBanner");
    [mBannersMap setValue:nil forKey:bannerId];
}

/**
 * Create the adMob Request
 *
 */
GADRequest* getRequest()
{
    Log(@"getRequest");
    Log(@"Request Building...");
    
    // Create the banner request for Admob
    GADRequest *request = [GADRequest request];
    
    // Set the Targetin Gender if it was specified
    if (mGender>0){
        Log([NSString stringWithFormat:@"Adding Gender Targeting!, Target: %@", NSStringFromGender(mGender)]);
        if(mGender == 1) request.gender = kGADGenderMale;
        else request.gender = kGADGenderFemale;
    }
    
    // Set the Birth Date if it was specified
    if(mBirthYear>0){
        uint16_t year = mBirthYear;
        uint8_t month = 1;
        uint8_t day = 1;
        // Check for valid Month and Day, otherwise keep the defaults
        if(mBirthMonth>0) month = mBirthMonth;
        if(mBirthDay>0) day = mBirthDay;
        Log([NSString stringWithFormat:@"Adding Birth Date Targeting!, Birth Date = Year: %u month: %u day: %u", year,month,day]);
        // Set the Request Data
        [request setBirthdayWithMonth:month day:day year:year];
    }
    
    // Set the Tag For Child Directed Treatment if it was specified
    if(mIsCDT){
        Log(@"Adding Tag For Child Directed Treatment Targeting!");
        // Set the Request Data
        [request tagForChildDirectedTreatment:(mIsCDT)];
    }
    
    // Add test device if not in production mode
    if (!mProdMode){
        Log(@"Setting the request as Test mode!");
        // Set the Request Data
        request.testDevices = [NSArray arrayWithObjects:
                               mTestDeviceID,
                               nil];
    }
    Log(@"Request build Completed.");
    // Return the Request
    return request;
}

/**
 * Create the adMob Banner in a relative position
 *
 */
void createBanner(FREContext context, NSString *bannerId, NSString *adMobId, GADAdSize adSize, uint32_t posType, uint32_t position)
{
    Log(@"Called createBanner");
    
    // Init the new Banner
    AdMobBanner *banner = [[AdMobBanner alloc] init];
    
    Log(@"Setting Banner Proprierty");
    // Set the Bnnner Proprierties
    banner.context = context;
    banner.adMobRequest = getRequest();
    banner.bannerId = bannerId;
    banner.adMobId = adMobId;
    banner.adMobSize = &adSize;
    banner.positionType = posType;
    banner.relPosition = position;
    
    Log([NSString stringWithFormat:@"Set Banner Id: %@",bannerId]);
    Log([NSString stringWithFormat:@"Set Admob Id: %@",adMobId]);
    Log([NSString stringWithFormat:@"Set Position Type: %d",posType]);
    Log([NSString stringWithFormat:@"Set Position Anchor Type: %d",position]);
    
    // Add the Banner to the Banners Map
    addStoredBanner(banner, bannerId);
    
    Log(@"Creating the Banner...");
    // Create the Banner View
    [banner create];
}

/**
 * Create the adMob Banner in an Absolute position
 *
 */
void createBannerAbsolute(FREContext context, NSString *bannerId, NSString *adMobId, GADAdSize adSize, uint32_t posType, uint32_t positionX, uint32_t positionY)
{
    Log(@"Called createBannerAbsolute");
   
    // Init the new Banner
    AdMobBanner *banner = [[AdMobBanner alloc] init];
    
    Log(@"Setting Banner Proprierty");
    // Set the Bnnner Proprierties
    banner.context = context;
    banner.adMobRequest = getRequest();
    banner.bannerId = bannerId;
    banner.adMobId = adMobId;
    banner.adMobSize = &adSize;
    banner.positionType = posType;
    banner.absPositionX = positionX;
    banner.absPositionY = positionY;
    
    Log([NSString stringWithFormat:@"Set Banner Id: %@",bannerId]);
    Log([NSString stringWithFormat:@"Set Admob Id: %@",adMobId]);
    Log([NSString stringWithFormat:@"Set Position Type: %d",posType]);
    Log([NSString stringWithFormat:@"Set Absolute x Position: %d",positionX]);
    Log([NSString stringWithFormat:@"Set Absolute y Position: %d",positionY]);
    
    // Add the Banner to the Banners Map
    addStoredBanner(banner, bannerId);
    
    Log(@"Creating the Banner...");
    // Create the Banner View
    [banner create];
}

/**
 * Show a specific Banner
 *
 */
void showBanner(NSString *bannerId)
{
    Log(@"Called showBanner");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    AdMobBanner *banner = getStoredBanner(bannerId);
    Log(@"Showing the Banner...");
    [banner show];
}

/**
 * Hide a specific Banner
 *
 */
void hideBanner(NSString *bannerId)
{
    Log(@"Called hideBanner");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    AdMobBanner *banner = getStoredBanner(bannerId);
    Log(@"Hiding the Banner...");
    [banner hide];
}
void moveBanner(NSString *bannerId,uint32_t positionX,uint32_t positionY)
{
    Log(@"Called moveBanner");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    AdMobBanner *banner = getStoredBanner(bannerId);
    Log(@"Hiding the Banner...");
    [banner moveBanner:positionX withPositionY:positionY];
}
void rotateBanner(NSString *bannerId,double angle)
{
    Log(@"Called rotate");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    AdMobBanner *banner = getStoredBanner(bannerId);
    Log(@"Hiding the Banner...");
    [banner rotateBanner:angle];
}
FREObject getBannerSize(NSString *bannerId)
{
    Log(@"Called getBannerSize");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    AdMobBanner *banner = getStoredBanner(bannerId);
    Log(@"Hiding the Banner...");
    return [banner getBannerSize];
}
/**
 * Remove a specific Banner
 *
 */
void removeBanner(NSString *bannerId)
{
    Log(@"Called removeBanner");
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    Log(@"Removing the Banner...");
    // Clear the instance
    AdMobBanner *banner = getStoredBanner(bannerId);
    // Destroy the current ad
    [banner remove];
    banner = nil;
    
    // Remove the Banner from the ictionary
    removeStoredBanner(bannerId);
}

/**
 * Create the Interstitial
 *
 */
void createInterstitial(FREContext context, NSString *interstitialId)
{
    Log(@"Called createInterstitial");
    
    // Init the new Interstitial
    mInterstitialAd = [[AdMobInterstitial alloc] init];
    
    Log(@"Setting Banner Proprierty");
    // Set the Interstitial Proprierties
    mInterstitialAd.context = context;
    mInterstitialAd.adMobRequest = getRequest();
    mInterstitialAd.adMobId = interstitialId;
    
    Log([NSString stringWithFormat:@"Set Admob Id: %@",interstitialId]);
    
    Log(@"Creating the Banner...");
    // Create the Interstitial View
    [mInterstitialAd create];
}

/**
 * Remove the Interstitial
 *
 */
void removeInterstitial()
{
    Log(@"Called removeInterstitial");
    if(mInterstitialAd) {
        Log(@"Removing...");
        // Destroy the current ad
        if(mInterstitialAd) [mInterstitialAd remove];
    }
}

/**
 * Clear the Interstitial Instance
 *
 */
void clearInterstitialInstance()
{
    Log(@"Called clearInterstitialInstance");
    if(mInterstitialAd) {
        Log(@"Clearing...");
        //[mInterstitialAd removeFromParentViewController];
        [mInterstitialAd release];
        //[mInterstitialAd dealloc];
        mInterstitialAd = nil;
    }
}

/**
 * Show the Interstitial
 *
 */
void showInterstitial()
{
    Log(@"Called showInterstitial");
    if(mInterstitialAd) {
        Log(@"Showing...");
        [mInterstitialAd show];
    }
}

/**
 * Cache the Interstitial
 *
 */
void cacheInterstitial()
{
    Log(@"Called cacheInterstitial");
    if(mInterstitialAd) {
        Log(@"Chaching...");
        [mInterstitialAd cache];
    }
}

/**
 * Check if the Interstitial is loaded
 *
 */
BOOL isInterstitialLoaded()
{
    Log(@"Called isInterstitialLoaded");
    Log([NSString stringWithFormat:@"Response: %@", NSStringFromBOOL(mIsInterstitialLoaded)]);
    return mIsInterstitialLoaded;
}

// =================================================================================================
//	FRE Functions
// =================================================================================================

/**
 * Create the adMob Banner in a relative position
 *
 */
FREObject FRECreateBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRECreateBanner");
    
    // Function Parameter
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    uint32_t adMobIdlength = 0;
    const uint8_t *adMobIdVal = NULL;
    NSString *adMobId;
    uint32_t adSizeVal;
    uint32_t posType;
    uint32_t position;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    FREGetObjectAsUTF8( argv[1], &adMobIdlength, &adMobIdVal );
    adMobId = [NSString stringWithUTF8String: (char*) adMobIdVal];
    FREGetObjectAsUint32(argv[2], &adSizeVal);
    FREGetObjectAsUint32(argv[3], &posType);
    FREGetObjectAsUint32(argv[4], &position);
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    Log([NSString stringWithFormat:@"Given AdMob Id: %@",adMobId]);
    Log([NSString stringWithFormat:@"Given AdSize type: %d",adSizeVal]);
    Log([NSString stringWithFormat:@"Given Position Type: %d",posType]);
    Log([NSString stringWithFormat:@"Given Position Anchor type: %d",position]);
    
    // Get the correct AdSize according to the one given
    GADAdSize adSize;
    switch (adSizeVal)
    {
        case 0: // Standard Banner
            adSize = kGADAdSizeBanner;
            break;
        case 1: // IAB Medium Rectangle
            adSize = kGADAdSizeMediumRectangle;
            break;
        case 2: // IAB Full-Size Banner
            adSize = kGADAdSizeFullBanner;
            break;
        case 3: // IAB Leaderboard
            adSize = kGADAdSizeLeaderboard;
            break;
        case 4: // Wide Skyscraper
            adSize = kGADAdSizeSkyscraper;
            break;
        case 5: // Smart Banner (Portrait) - Android Compatibility
        case 6: // Smart Banner (Portrait)
            adSize = kGADAdSizeSmartBannerPortrait;
            break;
        case 7: // Smart Banner (Landscape)
            adSize = kGADAdSizeSmartBannerLandscape;
            break;
        default: // Default (Standard Banner)
            adSize = kGADAdSizeBanner;
            break;
    }
    
    // Execute the Context function
    createBanner(ctx, bannerId, adMobId, adSize, posType, position);
    
    // Return
    return NULL;
}

/**
 * Create the adMob Banner in a relative position
 *
 */
FREObject FRECreateBannerAbsolute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRECreateBannerAbsolute");
    
    // Function Parameter
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    uint32_t adMobIdlength = 0;
    const uint8_t *adMobIdVal = NULL;
    NSString *adMobId;
    uint32_t adSizeVal;
    uint32_t posType;
    uint32_t positionX;
    uint32_t positionY;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    FREGetObjectAsUTF8( argv[1], &adMobIdlength, &adMobIdVal );
    adMobId = [NSString stringWithUTF8String: (char*) adMobIdVal];
    FREGetObjectAsUint32(argv[2], &adSizeVal);
    FREGetObjectAsUint32(argv[3], &posType);
    FREGetObjectAsUint32(argv[4], &positionX);
    FREGetObjectAsUint32(argv[5], &positionY);
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    Log([NSString stringWithFormat:@"Given AdMob Id: %@",adMobId]);
    Log([NSString stringWithFormat:@"Given AdSize type: %d",adSizeVal]);
    Log([NSString stringWithFormat:@"Given Position Type: %d",posType]);
    Log([NSString stringWithFormat:@"Given Absolute x Position: %d",positionX]);
    Log([NSString stringWithFormat:@"Given Absolute y Position: %d",positionY]);
    
    // Get the correct AdSize according to the one given
    GADAdSize adSize;
    switch (adSizeVal)
    {
        case 0: // Standard Banner
            adSize = kGADAdSizeBanner;
            break;
        case 1: // IAB Medium Rectangle
            adSize = kGADAdSizeMediumRectangle;
            break;
        case 2: // IAB Full-Size Banner
            adSize = kGADAdSizeFullBanner;
            break;
        case 3: // IAB Leaderboard
            adSize = kGADAdSizeLeaderboard;
            break;
        case 4: // Wide Skyscraper
            adSize = kGADAdSizeSkyscraper;
            break;
        case 5: // Smart Banner (Portrait) - Android Compatibility
        case 6: // Smart Banner (Portrait)
            adSize = kGADAdSizeSmartBannerPortrait;
            break;
        case 7: // Smart Banner (Landscape)
            adSize = kGADAdSizeSmartBannerLandscape;
            break;
        default: // Default (Standard Banner)
            adSize = kGADAdSizeBanner;
            break;
    }
    
    // Execute the Context function
    createBannerAbsolute(ctx, bannerId, adMobId, adSize, posType, positionX, positionY);
    
    // Return
    return NULL;
}

/**
 * Show a specific Banner
 *
 */
FREObject FREShowBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FREShowBanner");
    
    // Function Parameter
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    
    // Execute the Context function
    showBanner(bannerId);
    
    // Return
    return NULL;
}

/**
 * Hide a specific Banner
 *
 */
FREObject FREHideBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FREHideBanner");
    
    // Function Parameter
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    
    // Execute the Context function
    hideBanner(bannerId);
    
    // Return
    return NULL;
}

/**
 * Remove a specific Banner
 *
 */
FREObject FRERemoveBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRERemoveBanner");
    
    // Function Parameter
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    
    // Execute the Context function
    removeBanner(bannerId);
    
    // Return
    return NULL;
}

/**
 * Create the Interstitial
 *
 */
FREObject FRECreateInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRECreateInterstitial");
    
    // Function Parameter
    uint32_t interstitialIdlength = 0;
    const uint8_t *interstitialIdVal = NULL;
    NSString *interstitialId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &interstitialIdlength, &interstitialIdVal );
    interstitialId = [NSString stringWithUTF8String: (char*) interstitialIdVal];
    
    Log([NSString stringWithFormat:@"Given interstitial Id: %@",interstitialId]);
    
    // Execute the Context function
    createInterstitial(ctx, interstitialId);
    
    // Return
    return NULL;
}

/**
 * Remove the Interstitial
 *
 */
FREObject FRERemoveInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRERemoveInterstitial");
    
    // Execute the Context function
    removeInterstitial();
    
    // Return
    return NULL;
}

/**
 * Show the Interstitial
 *
 */
FREObject FREShowInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FREShowInterstitial");
    
    // Execute the Context function
    showInterstitial();
    
    // Return
    return NULL;
}

/**
 * Cache the Interstitial
 *
 */
FREObject FRECacheInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRECacheInterstitial");
    
    // Execute the Context function
    cacheInterstitial();
    
    // Return
    return NULL;
}

/**
 * Check if the Interstitial is ready to be visualize
 *
 */
FREObject FREIsInterstitialLoaded(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FREIsInterstitialLoaded");
    
    // Get the Returning Value
    uint32_t retValue = isInterstitialLoaded();
    
    Log([NSString stringWithFormat:@"Will return Value: %d",retValue]);
    
    // Define the returning FREObject
    FREObject result;
    // Create and Validate the returning result
    if ( FRENewObjectFromBool(retValue, &result ) == FRE_OK )
    {
        // Return the result
        return result;
    }
    
    Log(@"The returning value was not converted properly");
    // Return
    return NULL;
}

/**
 * Set Extension Operation Mode
 *
 */
FREObject FRESetMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Production Mode");
    // Define int for FREGetter
    uint32_t isProdMode;
    // Convert The Bool value
    if( FREGetObjectAsBool(argv[0], &isProdMode) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        if (isProdMode) mProdMode = YES;
        else mProdMode = NO;
    }
    Log([NSString stringWithFormat:@"Is Production Mode %@", NSStringFromBOOL(mProdMode)]);
    // Return
    return NULL;
}

/**
 * Set Extension Verbose Mode
 *
 */
FREObject FRESetVerbose(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Verbose Mode");
    // Define int for FREGetter
    uint32_t isVerbose;
    // Convert The Bool value
    if( FREGetObjectAsBool(argv[0], &isVerbose) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        if (isVerbose) mVerbose = YES;
        else mVerbose = NO;
    }
    Log([NSString stringWithFormat:@"Is Verbose Mode %@", NSStringFromBOOL(mVerbose)]);
    // Return
    return NULL;
}

/**
 * Set Test Device ID
 *
 */
FREObject FRESetTestDeviceId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Test Device ID");
    
    // Define retrieving paraeters
    uint32_t deviceIdlength = 0;
    const uint8_t *deviceIdVal = NULL;

    // Conver the NSString value
    FREGetObjectAsUTF8( argv[0], &deviceIdlength, &deviceIdVal );
    mTestDeviceID = [NSString stringWithUTF8String: (char*) deviceIdVal];
    
    // Log the result
    Log([NSString stringWithFormat:@"Given Test Device ID: %@",mTestDeviceID]);
    
    // Return
    return NULL;
}

/**
 * Set Targeting Gender
 *
 */
FREObject FRESetGender(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Gender");
    // Define int for FREGetter
    uint32_t genderVal;
    // Convert The int value
    if( FREGetObjectAsUint32(argv[0], &genderVal) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        mGender = genderVal;
    }
    Log([NSString stringWithFormat:@"Gender Set: %@", NSStringFromGender(mGender)]);
    // Return
    return NULL;
}

/**
 * Set Targeting Birth Year
 *
 */
FREObject FRESetBirthYear(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Birth Year");
    
    // Define int for FREGetter
    uint32_t yearVal;
    // Convert The int value
    if( FREGetObjectAsUint32(argv[0], &yearVal) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        mBirthYear = yearVal;
    }
    Log([NSString stringWithFormat:@"Birth Year Set: %u",mBirthYear]);
    // Return
    return NULL;
}

/**
 * Set Targeting Birth Month
 *
 */
FREObject FRESetBirthMonth(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Birth Month");
    // Define int for FREGetter
    uint32_t monthVal;
    // Convert The int value
    if( FREGetObjectAsUint32(argv[0], &monthVal) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        mBirthMonth = monthVal;
    }
    Log([NSString stringWithFormat:@"Birth Month Set: %u",mBirthMonth]);
    // Return
    return NULL;
}

/**
 * Set Targeting Birth Day
 *
 */
FREObject FRESetBirthDay(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Birth Day");
    // Define int for FREGetter
    uint32_t dayVal;
    // Convert The int value
    if( FREGetObjectAsUint32(argv[0], &dayVal) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        mBirthDay = dayVal;
    }
    Log([NSString stringWithFormat:@"Birth Day Set: %u",mBirthDay]);
    // Return
    return NULL;
}

/**
 * Set Targeting Tag For Child Directed Treatment
 *
 */
FREObject FRESetCDT(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Setting Tag For Child Directed Treatment");
    // Define int for FREGetter
    uint32_t isCDTVal;
    // Convert The Bool value
    if( FREGetObjectAsBool(argv[0], &isCDTVal) == FRE_OK)
    {
        // Update the Production Mode Accordengly
        if (isCDTVal) mIsCDT = YES;
        else mIsCDT = NO;
    }
    Log([NSString stringWithFormat:@"Is Tag For Child Directed Treatment: %@", NSStringFromBOOL(mIsCDT)]);
    // Return
    return NULL;
}

FREObject FREmoveBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"FREmoveBanner  ");
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    uint32_t positionX;
    uint32_t positionY;
    FREGetObjectAsUint32(argv[1], &positionX);
    FREGetObjectAsUint32(argv[2], &positionY);
    
    moveBanner(bannerId,positionX,positionY);
    return NULL;
}
FREObject FRErotateBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"FRErotateBanner  ");
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    double angle;
    FREGetObjectAsDouble(argv[1], &angle);
    
    rotateBanner(bannerId,angle);
    return NULL;
}
FREObject FREgetAdSize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"FREgetAdSize  ");
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    
    // Convert AS parameter to Native Parameter
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    
    return getBannerSize(bannerId);
}
FREObject FREgetScreenSize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
     Log(@"FREgetScreenSize  ");
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    FREObject resultObject;
    FREObject argvlist[2];
    FREObject widthObject;
    FREObject heightObject;
    FRENewObjectFromDouble(screenBound.size.width, &widthObject);
    FRENewObjectFromDouble(screenBound.size.height, &heightObject);
    argvlist[0]=widthObject;
    argvlist[1]=heightObject;
    FRENewObject((const uint8_t*)"com.admob.ScreenSize", 2, argvlist, &resultObject, NULL);
    return resultObject;
}


// =================================================================================================
//	Constructor / Deconstructors
// =================================================================================================

/**
 * ANE Context Initializer
 * The context initializer is called when the runtime creates the extension context instance.
 *
 * @param extData The extension client data provided to the FREInitializer function as extDataToSet.
 * @param ctxType Pointer to the contextType string (UTF8) as provided to the AS createExtensionContext call.
 * @param ctx The FREContext being initialized.
 * @param numFunctionsToSet The number of elements in the functionsToSet array.
 * @param functionsToSet A pointer to an array of FRENamedFunction elements.
 */
void AdMobAneContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    Log(@"Context Initializer - Setting Functions Names");
    *numFunctionsToTest = 22;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
	func[0].name = (const uint8_t*) BANNER_CREATE;
	func[0].functionData = NULL;
    func[0].function = &FRECreateBanner;
    
	func[1].name = (const uint8_t*) BANNER_CREATE_ABSOLUTE;
	func[1].functionData = NULL;
    func[1].function = &FRECreateBannerAbsolute;
    
	func[2].name = (const uint8_t*) BANNER_SHOW;
	func[2].functionData = NULL;
    func[2].function = &FREShowBanner;
    
	func[3].name = (const uint8_t*) BANNER_HIDE;
	func[3].functionData = NULL;
    func[3].function = &FREHideBanner;
    
	func[4].name = (const uint8_t*) BANNER_REMOVE;
	func[4].functionData = NULL;
    func[4].function = &FRERemoveBanner;
    
	func[5].name = (const uint8_t*) INTERSTITIAL_CREATE;
	func[5].functionData = NULL;
    func[5].function = &FRECreateInterstitial;
    
	func[6].name = (const uint8_t*) INTERSTITIAL_REMOVE;
	func[6].functionData = NULL;
    func[6].function = &FRERemoveInterstitial;
    
	func[7].name = (const uint8_t*) INTERSTITIAL_SHOW;
	func[7].functionData = NULL;
    func[7].function = &FREShowInterstitial;
    
	func[8].name = (const uint8_t*) INTERSTITIAL_CACHE;
	func[8].functionData = NULL;
    func[8].function = &FRECacheInterstitial;
    
	func[9].name = (const uint8_t*) INTERSTITIAL_IS_LOADED;
	func[9].functionData = NULL;
    func[9].function = &FREIsInterstitialLoaded;
    
	func[10].name = (const uint8_t*) SET_MODE;
	func[10].functionData = NULL;
    func[10].function = &FRESetMode;
    
	func[11].name = (const uint8_t*) SET_TEST_DEVICE_ID;
	func[11].functionData = NULL;
    func[11].function = &FRESetTestDeviceId;
    
	func[12].name = (const uint8_t*) SET_VERBOSE;
	func[12].functionData = NULL;
    func[12].function = &FRESetVerbose;
    
	func[13].name = (const uint8_t*) SET_GENDER;
	func[13].functionData = NULL;
    func[13].function = &FRESetGender;
    
	func[14].name = (const uint8_t*) SET_BIRTHYEAR;
	func[14].functionData = NULL;
    func[14].function = &FRESetBirthYear;
    
	func[15].name = (const uint8_t*) SET_BIRTHMONTH;
	func[15].functionData = NULL;
    func[15].function = &FRESetBirthMonth;
    
	func[16].name = (const uint8_t*) SET_BIRTHDAY;
	func[16].functionData = NULL;
    func[16].function = &FRESetBirthDay;
    
	func[17].name = (const uint8_t*) SET_CDT;
	func[17].functionData = NULL;
    func[17].function = &FRESetCDT;
    
    func[18].name = (const uint8_t*) Move_Banner;
    func[18].functionData = NULL;
    func[18].function = &FREmoveBanner;
    
    func[19].name = (const uint8_t*) Rotate_Banner;
    func[19].functionData = NULL;
    func[19].function = &FRErotateBanner;
    
    func[20].name = (const uint8_t*) Get_Ad_Size;
    func[20].functionData = NULL;
    func[20].function = &FREgetAdSize;
    
    func[21].name = (const uint8_t*) Get_Screen_Size;
    func[21].functionData = NULL;
    func[21].function = &FREgetScreenSize;
    
	*functionsToSet = func;
    
    Log(@"Context Initializer - Setting Context Proprierties");
    
    // AdMobAne Proprieties initialization
    mContext = ctx;
    mProdMode = false;
    mVerbose = false;
    mBannersMap = [[NSMutableDictionary alloc] init];
    
    // Targeting Proprieties initialization
    mGender = 0;
    mBirthYear = 0;
    mBirthMonth = 0;
    mBirthDay = 0;
    mIsCDT = false;
}

/**
 * ANE Context Finalizer
 * Called each time the ExtensionContext instance is disposed.
 *
 * @param ctx The FREContext being finalized.
 */
void AdMobAneContextFinalizer(FREContext ctx)
{
    Log(@"Context Finalizer - Cleaning up");
    // Clean everything we have
    for (NSString *key in mBannersMap) {
        removeBanner(key);
    };
    
    [mBannersMap removeAllObjects];
    [mBannersMap release];
    mBannersMap = NULL;
    mInterstitialAd = NULL;
    mContext = NULL;
    return;
}

/**
 * ANE Extension Initializer
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 */
void AdMobAneExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                            FREContextFinalizer* ctxFinalizerToSet)
{
    Log(@"Extension Initializer");
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AdMobAneContextInitializer;
    *ctxFinalizerToSet = &AdMobAneContextFinalizer;
}

/**
 * ANE Extension IInitializer
 * Called when the ANE is disposed in AS.
 *
 */
void AdMobAneExtFinalizer(void* extData)
{
    Log(@"Extension Finalizer");
    // Do Cleanup here.
    return;
}

// =================================================================================================
//	Logger Functions
// =================================================================================================

/**
 * Log a message
 *
 */
void Log(NSString *msg) {
    // Log the Message if in Verbose Mode
    if(mVerbose) NSLog(@"%@ %@",TAG,msg);
}