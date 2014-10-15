//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobInterstitial.m
//  AdMobAne
//
//  Copyright (c) 2011-2015 lancelot Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "AdMobAne.h"
#import "AdMobInterstitial.h"
#import "AdMobEvents.h"

@implementation AdMobInterstitial

// AdMob Banner Constants
const NSString *INTER_ID = @"InterstitialAd";

// AdMob Interstitial Propriety
@synthesize context;
@synthesize adMobRequest;
@synthesize adMobId;

// =================================================================================================
//	Admob Delegate Events
// =================================================================================================

/**
 * Interstitial Did Receive Ad Event Listener
 *
 */
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    Log(@"Event interstitialDidReceiveAd");
    
    // Update Interstitial load state
    mIsInterstitialLoaded = YES;
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_LOADED, (uint8_t*)[INTER_ID UTF8String]);
}

/**
 * Did Fail To Receive Interstitial With Error Event Listener
 *
 */
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error;
{
    Log(@"Event didFailToReceiveAdWithError");
    Log([NSString stringWithFormat:@"Error Details: %@",error]);
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_FAILED_TO_LOAD, (uint8_t*)[INTER_ID UTF8String]);
    // Clear the Interstitial from memory
    [self clearInterstitial];
}

/**
 * Interstitial Will Present Screen Event Listener
 *
 */
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialWillPresentScreen");
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_AD_OPENED, (uint8_t*)[INTER_ID UTF8String]);
}

/**
 * Interstitial Will Dismiss Screen Event Listener
 *
 */
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialWillDismissScreen");
    /*
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_AD_CLOSED, (uint8_t*)[INTER_ID UTF8String]);
    */
}

/**
 * Interstitial Did Dismiss Screen Event Listener
 *
 */
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialDidDismissScreen");
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_AD_CLOSED, (uint8_t*)[INTER_ID UTF8String]);
    // Clear the Interstitial from memory
    [self clearInterstitial];
}

/**
 * Interstitial Will Leave Application Event Listener
 *
 */
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialWillLeaveApplication");
    
    // Dispatch the Event
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_LEFT_APPLICATION, (uint8_t*)[INTER_ID UTF8String]);
}

// =================================================================================================
//	Private Functions
// =================================================================================================

/**
 * Clear the Interstitial
 *
 */
- (void) clearInterstitial
{
    Log(@"clearInterstitial");
    // Clear the Interstitial from memory
    [self.view removeFromSuperview];
    self.view = nil;
    mInterstitialView = nil;
    context = NULL;
    adMobRequest = NULL;
    adMobId = NULL;
    // Clear its Instance
    clearInterstitialInstance();
}

/**
 * Build the Interstitial
 *
 */
- (void) buildInterstitial
{
    Log(@"buildInterstitial");
    
    // Build the Interstitial
    mInterstitialView = [[GADInterstitial alloc] init];
    // Set Banner delegate
    mInterstitialView.delegate = self;
    mInterstitialView.adUnitID = adMobId;
    // Update Load state and start loading the request
    mIsInterstitialLoaded = NO;
    Log(@"isLoaded set to: NO");
    [mInterstitialView loadRequest:adMobRequest];
    Log(@"Creation Completed");
}

// =================================================================================================
//	Public Functions
// =================================================================================================

/**
 * Create the Interstitial
 *
 */
- (void) create
{
    Log(@"Create Interstitial");
    
    // Do not process if the banner was already created
    if(mInterstitialView) return;
    
    Log(@"Creating.....");
    // Initialize the view
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
    [win addSubview:self.view];
    // Disable view touches
    self.view.userInteractionEnabled =NO;
}

/**
 * Remove the Banner
 *
 */
- (void) remove
{
    Log(@"remove");
    // Check if the banner is available
    if(mIsInterstitialLoaded)
    {
        Log(@"removing");
        // Clear the Interstitial from memory
        [self clearInterstitial];
    }
}

/**
 * Cache the Interstitial
 *
 */
- (void) cache
{
    Log(@"Cache Interstitial (unsupported in iOS, Please use create)");
    // Nothing really... Can't cache it
    //mIsInterstitialLoaded = NO;
    //Log(@"isLoaded set to: NO");
    // Set Banner delegate
    //mInterstitialView.delegate = self;
    //[mInterstitialView loadRequest:adMobRequest];
}

/**
 * Check the Interstitial Load State
 *
 */
- (BOOL) isInterstitialLoaded
{
    Log(@"isInterstitialLoaded");
    // return the current load state
    return mIsInterstitialLoaded;
}

/**
 * Show the Interstitial
 *
 */
- (void) show
{
    Log(@"Show Interstitial");

    // Show the Interstitial
    // Enable view Touches
    self.view.userInteractionEnabled =YES;
    // Show the Interstitial
    [mInterstitialView presentFromRootViewController:self];
}

// =================================================================================================
//	Constructor / Deconstructors
// =================================================================================================

/**
 * View Did Load
 * Executed when the view has been loaded in memory
 * Initialize everything which need to be show. (For Example our Interstitial)
 *
 */
- (void)viewDidLoad
{
    Log(@"interstitial viewDidLoad");
    [super viewDidLoad];
    // Build the Banner
    [self buildInterstitial];
}

/**
 * Did Receive Memory Warning
 * Executed when the OS send a memory usage alert.
 * Use it for remove unecessary memory usage.
 *
 */
- (void)didReceiveMemoryWarning
{
    Log(@"interstitial didReceiveMemoryWarning");
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
    Log(@"interstitial viewDidUnload");
    [super viewDidUnload];
    mInterstitialView.delegate = nil;
    mInterstitialView = nil;
    context = NULL;
    adMobRequest = NULL;
    adMobId = NULL;
}

/**
 * Dealloc Function
 * Deallocate all the current instances
 *
 */
- (void)dealloc
{
    Log(@"interstitial dealloc");
    [super dealloc];
    /*
    //[self.view removeFromSuperview];
    if(self.view) self.view = nil;
    mInterstitialView = nil;
    context = NULL;
    adMobRequest = NULL;
    adMobId = NULL;
    */
}

@end
