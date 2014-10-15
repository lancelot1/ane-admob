//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobBanner.m
//  AdMobAne
//
//  Copyright (c) 2011-2015 lancelot Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AdMobAne.h"
#import "AdMobBanner.h"
#import "AdMobEvents.h"

@implementation AdMobBanner

// AdMob Banner Constants
const uint8_t POS_RELATIVE = 0;
const uint8_t POS_ABSOLUTE = 1;

// AdMob Banner Propriety
@synthesize context;
@synthesize viewFrame;
@synthesize adMobRequest;
@synthesize bannerId;
@synthesize adMobId;
@synthesize adMobSize;
@synthesize positionType;
@synthesize relPosition;
@synthesize absPositionX;
@synthesize absPositionY;

// =================================================================================================
//	Admob Delegate Events
// =================================================================================================

/**
 * Ad View Did Receive Ad Event Listener
 *
 */
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    Log(@"Event adViewDidReceiveAd");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_LOADED, (uint8_t*)[bannerId UTF8String]);
}

/**
 * Did Fail To Receive Ad With Error Event Listener
 *
 */
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error;
{
    Log(@"Event didFailToReceiveAdWithError");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    Log([NSString stringWithFormat:@"Error Details: %@",error]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_FAILED_TO_LOAD, (uint8_t*)[bannerId UTF8String]);
}

/**
 * Ad View Will Present Screen Event Listener
 *
 */
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView;
{
    Log(@"Event adViewWillPresentScreen");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_AD_OPENED, (uint8_t*)[bannerId UTF8String]);
}

/**
 * Ad View Did Dismiss Screen Event Listener
 *
 */
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView;
{
    Log(@"Event adViewDidDismissScreen");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_AD_CLOSED, (uint8_t*)[bannerId UTF8String]);
}

/**
 * Ad View Will Dismiss Screen Event Listener
 *
 */
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView;
{
    Log(@"Event adViewWillDismissScreen");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    /*
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_AD_CLOSED, (uint8_t*)[bannerId UTF8String]);
    */
}

/**
 * Ad View Did Receive Ad Event Listener
 *
 */
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView;
{
    Log(@"Event adViewWillLeaveApplication");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_LEFT_APPLICATION, (uint8_t*)[bannerId UTF8String]);
}

// =================================================================================================
//	Private Functions
// =================================================================================================

/**
 * Get The Banner Anchor Point in Relative coordinates
 *
 */
- (CGPoint) getRelativePoint
{
    // Get the Current Screen Size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    // Define the Coordinates
    uint16_t relativeX = 0;
    uint16_t relativeY = 0;
    
    // Update the Coordinates according to the given Anchor
    switch (relPosition)
    {
        case 1: // Top Left Alignment
            relativeX = 0;
            relativeY = 0;
            break;
        case 2: // Top Center Alignment
            relativeX = (screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width)/2;
            relativeY = 0;
            break;
        case 3: // Top Right Alignment
            relativeX = screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width;
            relativeY = 0;
            break;
        case 4: // Middle Left Alignment
            relativeX = 0;
            relativeY = (screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height)/2;
            break;
        case 5: // Middle Center Alignment
            relativeX = (screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width)/2;
            relativeY = (screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height)/2;
            break;
        case 6: // Middle Right Alignment
            relativeX = screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width;
            relativeY = (screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height)/2;
            break;
        case 7: // Bottom Left Alignment
            relativeX = 0;
            relativeY = screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height;
            break;
        case 8: // Bottom Center Alignment
            relativeX = (screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width)/2;
            relativeY = screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height;
            break;
        case 9: // Bottom Right Alignment
            relativeX = screenWidth - CGSizeFromGADAdSize(*(adMobSize)).width;
            relativeY = screenHeight - CGSizeFromGADAdSize(*(adMobSize)).height;
            break;
        default: // Default (Top Left Alignment)
            relativeX = 0;
            relativeY = 0;
            break;
    }
    Log([NSString stringWithFormat:@"Relative Point Resolved = x:%u y:%u ",relativeX,relativeY]);

    // Return the relative coordinates
    return CGPointMake(relativeX,relativeY);
}

/**
 * Get The Banner Anchor Point in Absolute coordinates
 *
 */
- (CGPoint) getAbsolutePoint
{
    Log([NSString stringWithFormat:@"Absolute Point = x:%u y:%u ",absPositionX,absPositionY]);
    // Return the poit based on the gien coordinates
    return CGPointMake(absPositionX,absPositionY);
}

/**
 * Build the Banner
 *
 */
- (void) buildBanner
{
    Log(@"buildBanner");
    
    // Initialize the GADBannerView
    mBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,0.0,viewFrame.size.width,viewFrame.size.height)];
    
    // Set the banner unit Id
    mBannerView.adUnitID = adMobId;
    
    // Update Banner root view controller (returning point)
    mBannerView.rootViewController = self;
    // Set Banner delegate
    mBannerView.delegate = self;
    // Ad the Banner to the view
    [self.view addSubview:mBannerView];
    
    // Load the Banner Request
    [mBannerView loadRequest:adMobRequest];
    [self hide];
}

// =================================================================================================
//	Public Functions
// =================================================================================================

/**
 * Create the Banner
 *
 */
- (void) create
{
    Log(@"Banner create");
    Log([NSString stringWithFormat:@"bannerId: %@",bannerId]);
    Log([NSString stringWithFormat:@"self.bannerId: %@",self.bannerId]);
    Log([NSString stringWithFormat:@"positionType: %d",positionType]);
    Log([NSString stringWithFormat:@"self.positionType: %d",self.positionType]);
    Log([NSString stringWithFormat:@"relPosition: %d",relPosition]);
    Log([NSString stringWithFormat:@"self.relPosition: %d",self.relPosition]);
    Log([NSString stringWithFormat:@"absPositionX: %d",absPositionX]);
    Log([NSString stringWithFormat:@"self.absPositionX: %d",self.absPositionX]);
    Log([NSString stringWithFormat:@"absPositionY: %d",absPositionY]);
    Log([NSString stringWithFormat:@"self.absPositionY: %d",self.absPositionY]);
    
    // Do not process if the banner was already created
    if(mBannerView) return;
    
    // Get the banner position coordinates According to the position Type
    CGPoint anchorPoint;
    if(positionType == POS_ABSOLUTE){
        anchorPoint = [self getAbsolutePoint];
    }else{
        anchorPoint = [self getRelativePoint];
    }
    
    // Create and set view Frame
    CGSize size = CGSizeFromGADAdSize(*(adMobSize));
    viewFrame = CGRectMake(anchorPoint.x,anchorPoint.y,size.width,size.height);
    self.view.frame = viewFrame;
    
    // Initialize the view
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
    [win addSubview:self.view];
    // Disable touches for the view
    self.view.userInteractionEnabled = NO;
    // Hide the banner by default
    mBannerView.hidden = YES;
    
    Log(@"Creation Completed");
}

/**
 * Remove the Banner
 *
 */
- (void) remove
{
    Log(@"remove");
    // Check if the banner is available
    if(mBannerView)
    {
        Log(@"removing");
        [self.view removeFromSuperview];
        // Clear all instances and proprierties
        mBannerView = nil;
        context = NULL;
        adMobRequest = NULL;
        bannerId = NULL;
        adMobId = NULL;
        adMobSize = NULL;
        positionType = 0;
        absPositionX = 0;
        absPositionY = 0;
    }
}

/**
 * Show the Banner
 *
 */
- (void) show
{
    Log(@"show");
    // Check if the banner is available
    if(mBannerView)
    {
        Log(@"showing");
        // Show the banner
        mBannerView.hidden = NO;
        // Enable view touches
        self.view.userInteractionEnabled = YES;
    }
}

/**
 * Hide the Banner
 *
 */
- (void) hide
{
    Log(@"hide");
    // Check if the banner is available
    if(mBannerView)
    {
        Log(@"hiding");
        // Hide the banner
        mBannerView.hidden = YES;
        // Disable view touches
        self.view.userInteractionEnabled = NO;
    }
}


- (void) moveBanner:(uint32_t) positionX withPositionY:(uint32_t) positionY{
    CGRect frame=mBannerView.frame;
    frame.origin.x=positionX;
    frame.origin.y=positionY;
    mBannerView.frame=frame;
}
- (void) rotateBanner:(double) angle{
    mBannerView.bounds=CGRectMake(0, 0, mBannerView.frame.size.width, mBannerView.frame.size.height);
    mBannerView.transform=CGAffineTransformMakeRotation(angle);
}
- (FREObject) getBannerSize{
    CGRect screenBound = mBannerView.frame;
    FREObject resultObject;
    FREObject argvlist[2];
    FREObject widthObject;
    FREObject heightObject;
    FRENewObjectFromDouble(screenBound.size.width, &widthObject);
    FRENewObjectFromDouble(screenBound.size.height, &heightObject);
    argvlist[0]=widthObject;
    argvlist[1]=heightObject;
    FRENewObject((const uint8_t*)"com.admob.AdSize", 2, argvlist, &resultObject, NULL);
    return resultObject;
}
// =================================================================================================
//	Constructor / Deconstructors
// =================================================================================================

/**
 * Orientation Change Observer
 * TO BE IMPLEMENTED
 */
/*
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            // Manage Portrait state
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            // Manage Landscape state
            break;
            
        default:
            break;
    };
}
*/

/**
 * View Did Load
 * Executed when the view has been loaded in memory
 * Initialize everything which need to be show. (For Example our banner)
 *
 */
- (void)viewDidLoad
{
    Log(@"viewDidLoad");
    
    [super viewDidLoad];
    // Build the Banner
    [self buildBanner];
    
    // TODO: Implement Orientation Aware for dinamically redraw the banner
    // according to Orientation changes
    /*
     if(autoOrientate){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(orientationChanged:)
        name:UIDeviceOrientationDidChangeNotification
        object:[UIDevice currentDevice]];
     }
    */
}

/**
 * Did Receive Memory Warning
 * Executed when the OS send a memory usage alert.
 * Use it for remove unecessary memory usage.
 *
 */
- (void)didReceiveMemoryWarning
{
    Log(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/**
 * View Did Unload
 * Executed when the view has been unloaded from memory
 *
 */
- (void)viewDidUnload
{
    Log(@"viewDidUnload");
    [super viewDidUnload];
    mBannerView.delegate = nil;
    mBannerView = nil;
    context = NULL;
    adMobRequest = NULL;
    bannerId = NULL;
    adMobId = NULL;
    adMobSize = NULL;
    positionType = 0;
    absPositionX = 0;
    absPositionY = 0;
}

/**
 * Dealloc Function
 * Deallocate all the current instances
 *
 */
- (void)dealloc
{
    Log(@"dealloc");
    [super dealloc];
    
    mBannerView = nil;
    context = NULL;
    adMobRequest = NULL;
    bannerId = NULL;
    adMobId = NULL;
    adMobSize = NULL;
    positionType = 0;
    absPositionX = 0;
    absPositionY = 0;
}

@end
