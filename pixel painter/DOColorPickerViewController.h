//
//  DOColorPickerViewController.h
//  pixel painter
//
//  Created by David Ochmann on 05.08.12.
//
//

#import <UIKit/UIKit.h>
#import "DOPixelPainterModel.h"
#import "UIColor-HSVAdditions.h"
#import "UIImageView-ColorUtils.h"
#import "DOConstants.h"

@interface DOColorPickerViewController : UIViewController

@property (strong, nonatomic) DOPixelPainterModel *model;

@property (strong, nonatomic) IBOutlet UIView *colorMapView;
@property (strong, nonatomic) IBOutlet UIImageView *colorMapViewImage;
@property (strong, nonatomic) IBOutlet UIImageView *colorPicker;
@property (strong, nonatomic) IBOutlet UISlider *sliderHue;
@property (strong, nonatomic) IBOutlet UISlider *sliderSaturation;
@property (strong, nonatomic) IBOutlet UISlider *sliderBrightness;
@property (strong, nonatomic) IBOutlet UITextField *textHue;
@property (strong, nonatomic) IBOutlet UITextField *textSaturation;
@property (strong, nonatomic) IBOutlet UITextField *textBrightness;

- (IBAction)sliderHueTouchDragInsideHandler:(UISlider *)sender;

- (IBAction)sliderSaturationTouchDragInsideHandler:(UISlider *)sender;

- (IBAction)sliderBrightnessDragInsideHandler:(UISlider *)sender;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGPoint touchPosition;

- (void)pickColorAtTouches:(NSSet *)touches;
- (void)hideColorPicker;

@end
