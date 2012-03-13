//
//  DOColorPickerView.h
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"
#import "UIImageView-ColorUtils.h"
#import "DOConstants.h"
#import "DOColorMapView.h"

@interface DOColorPickerView : UIView

@property (strong, nonatomic) GradientView *gradientView;
@property (strong, nonatomic) DOColorMapView *colorMapView;
@property (strong, nonatomic) UIImageView *colorMapViewImage; 
@property (strong, nonatomic) UIImageView *colorPicker;
@property (strong, nonatomic) UIImageView *colorPickerHorizontal;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGPoint touchPosition;

- (void)pickColorAtTouches:(NSSet *)touches;
- (void)hideBothColorPickers;
- (void)hideColorPickerAndResetColorPickerHorizontal;

@end
