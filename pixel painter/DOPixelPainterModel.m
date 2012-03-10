//
//  DOPixelPainterModel.m
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterModel.h"


@implementation DOPixelPainterModel

NSString * const SUBSITE_FILE = @"SUBSITE_FILE";
NSString * const SUBSITE_COLORPICKER = @"SUBSITE_COLORPICKER";

@synthesize navigationStatus = _navigationStatus;
@synthesize color = _color;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize subsite = _subsite;

- (void)setNavigationStatus:(unsigned int)navigationStatus
{
    _navigationStatus = navigationStatus > 2 ? 2 : navigationStatus;
}

@end
