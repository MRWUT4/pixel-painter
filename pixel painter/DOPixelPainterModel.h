//
//  DOPixelPainterModel.h
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOPixelPainterModel : NSObject

@property(assign, nonatomic) unsigned int navigationStatus;
@property(assign, nonatomic) unsigned int drawingState;
@property(assign, nonatomic) unsigned int subsite;
@property(assign, nonatomic) BOOL scrollEnabled;
@property(strong, nonatomic) UIColor *color;

@end
