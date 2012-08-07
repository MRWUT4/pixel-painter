//
//  DOPixelPainterModel.h
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOConstants.h"

@interface DOPixelPainterModel : NSObject

@property(assign, nonatomic) unsigned int navigationStatus;
@property(assign, nonatomic) unsigned int applicationState;
@property(assign, nonatomic) UIImageView *drawingViewImage;
@property(assign, nonatomic) unsigned int subsite;
@property(assign, nonatomic) float hue;
@property(assign, nonatomic) float brightness;
@property(assign, nonatomic) float saturation;
@property(strong, nonatomic) UIColor *color;
@property(assign, nonatomic) BOOL initialized;
@property(assign, nonatomic) unsigned int width;
@property(assign, nonatomic) unsigned int height;

@end
