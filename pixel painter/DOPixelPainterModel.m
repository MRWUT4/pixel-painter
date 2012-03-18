//
//  DOPixelPainterModel.m
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterModel.h"


@implementation DOPixelPainterModel

@synthesize navigationStatus = _navigationStatus;
@synthesize color = _color;
@synthesize subsite = _subsite;
@synthesize applicationState = _applicationState;
@synthesize hue = _hue;
@synthesize brightness = _brightness;
@synthesize saturation = _saturation;
@synthesize initialized = _initialized;
@synthesize width = _width;
@synthesize height = _height;

- (void)setNavigationStatus:(unsigned int)navigationStatus
{
    _navigationStatus = navigationStatus > 2 ? 2 : navigationStatus;
}

@end
