//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobInterstitial.h
//  AdMobAne
//
//  Copyright (c) 2011-2015 lancelot Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "FlashRuntimeExtensions.h"

/**
 * NativeAds AdHolder Header Definitions
 */
@interface AdMobInterstitial : UIViewController <GADInterstitialDelegate> {
    GADInterstitial *mInterstitialView;
}

// AdMob Interstitial Propriety
@property (nonatomic,assign) FREContext context;
@property (nonatomic,assign) GADRequest *adMobRequest;
@property (nonatomic,retain) NSString *adMobId;

// AdMob Interstitial Expose Methods
- (void) create;
- (void) remove;
- (void) cache;
- (BOOL) isInterstitialLoaded;
- (void) show;

@end