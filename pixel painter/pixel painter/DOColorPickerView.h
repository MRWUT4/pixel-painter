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

@interface DOColorPickerView : UIViewController

 
@property (strong, nonatomic) IBOutlet UIImageView *colorMapViewImage;
@property (strong, nonatomic) IBOutlet UIView *colorMapView;
@property (strong, nonatomic) IBOutlet UIImageView *colorPicker;
@property (strong, nonatomic) IBOutlet UISlider *sliderHue;
@property (strong, nonatomic) IBOutlet UISlider *sliderSaturation;
@property (strong, nonatomic) IBOutlet UISlider *sliderBrightness;
@property (strong, nonatomic) IBOutlet UITextField *textHue;
@property (strong, nonatomic) IBOutlet UITextField *textSaturation;
@property (strong, nonatomic) IBOutlet UITextField *textBrightness;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGPoint touchPosition;

- (void)pickColorAtTouches:(NSSet *)touches;
- (void)hideColorPicker;

@end
