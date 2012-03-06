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
@synthesize scale = _scale;

- (void)setNavigationStatus:(unsigned int)navigationStatus
{
    _navigationStatus = navigationStatus > 2 ? 2 : navigationStatus;
}

- (void)setScale:(int)scale
{
    _scale = scale == 0 ? 1 : scale;
}

-(int)scale
{
    _scale = _scale == 0 ? 1 : _scale;
    return _scale;
}

@end
