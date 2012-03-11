//
//  DOPixelPainterModel.h
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


static float const NAVIGATION_ANIMATION_TIME = .4;

typedef enum navigation 
{
    NAVIGATION_STATUS_CLOSED = 0,
    NAVIGATION_POSITION_CLOSED = -352,

    NAVIGATION_STATUS_NAVIGATION = 1,
    NAVIGATION_POSITION_NAVIGATION = -288,

    NAVIGATION_STATUS_SUBVIEW = 2,
    NAVIGATION_POSITION_SUBVIEW = 0,
} Navigation;

typedef enum subsite
{
    SUBSITE_FILE = 0,
    SUBSITE_COLORPICKER = 1,
} Subsite;

typedef enum drawingState
{
    STATE_DRAWING = 0,
    STATE_PICKING = 1,
} DrawingState;


@interface DOPixelPainterModel : NSObject

@property(assign, nonatomic) unsigned int navigationStatus;
@property(assign, nonatomic) unsigned int drawingState;
@property(assign, nonatomic) unsigned int subsite;
@property(assign, nonatomic) BOOL scrollEnabled;
@property(strong, nonatomic) UIColor *color;

@end
