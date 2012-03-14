//
//  DOColorPickerView.h
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-HSVAdditions.h"
#import "UIImageView-ColorUtils.h"
#import "DOConstants.h"

@interface DOColorPickerView : UIView

@property (strong, nonatomic) UIView *colorMapView;
@property (strong, nonatomic) UIImageView *colorMapViewImage; 
@property (strong, nonatomic) UIImageView *colorPicker;
@property (strong, nonatomic) UISlider *sliderHue;
@property (strong, nonatomic) UISlider *sliderBrightness;
@property (strong, nonatomic) UISlider *sliderSaturation;

@property (strong, nonatomic) UITextView *textHue;
@property (strong, nonatomic) UITextView *textBrightness;
@property (strong, nonatomic) UITextView *textSaturation;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGPoint touchPosition;

- (void)pickColorAtTouches:(NSSet *)touches;
- (void)hideColorPicker;

@end
