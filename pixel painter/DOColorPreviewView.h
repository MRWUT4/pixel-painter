//
//  DOColorPreviewView.h
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOColorPreviewView : UIImageView

@property (strong, nonatomic) UIColor *color; 

- (void)clear;

@end
