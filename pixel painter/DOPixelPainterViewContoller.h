//
//  DOPixelPainterViewContoller.h
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DOConstants.h"
#import "DONavigationView.h"
#import "DOPixelPainterModel.h"
#import "DOColorPickerView.h"
#import "DOFileSettingsView.h"
#import "DOSubviewManager.h"
#import "DOColorPreviewView.h"
#import "DODrawingView.h"
#import "GradientView.h"


@interface DOPixelPainterViewContoller : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) DOPixelPainterModel *model;

@property (strong, nonatomic) DOSubviewManager *subviewManager;

@property (strong, nonatomic) NSArray *subsiteButtonList;

@property (strong, nonatomic) NSArray *applicationButtonList;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet DONavigationView *navigationView;

@property (weak, nonatomic) IBOutlet UIImageView *folderView;

@property (weak, nonatomic) IBOutlet DOColorPickerView *colorPickerView;

@property (weak, nonatomic) IBOutlet DOFileSettingsView *fileSettingsView;

@property (strong, nonatomic) IBOutlet DOColorPreviewView *colorPreviewView;

@property (weak, nonatomic) IBOutlet DODrawingView *drawingView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *buttonMove;

@property (strong, nonatomic) IBOutlet UIButton *buttonFile;

@property (strong, nonatomic) IBOutlet UIButton *buttonColor;

@property (strong, nonatomic) IBOutlet UIButton *buttonPicker;

@property (weak, nonatomic) IBOutlet UIButton *buttonPen;

@property (strong, nonatomic) IBOutlet UIButton *buttonErase;

@property (strong, nonatomic) IBOutlet UIButton *buttonPosition;

@property (strong, nonatomic) IBOutlet UITextField *textFieldWidth;

@property (strong, nonatomic) IBOutlet UITextField *textFieldHeight;

- (IBAction)buttonFolderTouchUpInsideHandler:(id)sender;

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender;

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender;

- (IBAction)buttonMoveTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPickerTouchUpInsideHandler:(id)sender;

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender;

- (IBAction)buttonOpenTouchUpInsideHandler:(id)sender;

- (IBAction)buttonEraseTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPenTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPositionTouchUpInsideHandler:(id)sender;

- (IBAction)sliderHueTouchDragInsideHandler:(UISlider *)sender;

- (IBAction)sliderSaturationTouchDragInsideHandler:(UISlider *)sender;

- (IBAction)buttonNewTouchUpInsideHandler:(id)sender;

- (IBAction)sliderBrightnessDragInsideHandler:(UISlider *)sender;


- (IBAction)buttonResizeTouchUpInsideHandler:(id)sender;

- (IBAction)textSizeEditingDidBegin:(UITextField *)sender;


- (void)changeNavigationStatus:(NSNumber *)status withAnimation:(BOOL)animation;

- (void)openSubsite:(unsigned int)subsite;

- (void)switchDrawingState:(unsigned int)state;

- (void)unSelectButtonList:(NSArray *)list;

- (void)centerImageWithAnimation:(BOOL)animation;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

- (void)fillEmptySizeTextField:(UITextField *)sender withText:(NSString *)text andSize:(unsigned int)size;

@end
