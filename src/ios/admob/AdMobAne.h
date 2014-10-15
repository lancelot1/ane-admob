//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobAne.h
//  AdMobAne
//
//  Copyright (c) 2011-2015 lancelot Inc. All rights reserved.
//

// Visible Function
void Log(NSString *msg);
void clearInterstitialInstance();

// Visible Parameters
BOOL mIsInterstitialLoaded;

// Object Converters
static inline NSString* NSStringFromBOOL(BOOL aBool) {
    return aBool? @"Yes" : @"No";
}

static inline NSString* NSStringFromGender(uint8_t aGender) {
    if (aGender == 1) return @"Male";
    if (aGender == 2) return @"Female";
    return @"Unknown";
}
