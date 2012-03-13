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
#import "DOSubviewContainerView.h"
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

@property (strong, nonatomic) IBOutlet DONavigationView *navigationView;

@property (weak, nonatomic) IBOutlet UIImageView *folderView;

@property (weak, nonatomic) IBOutlet DOColorPickerView *colorPickerView;

@property (weak, nonatomic) IBOutlet DOFileSettingsView *fileSettingsView;

@property (strong, nonatomic) IBOutlet GradientView *gradientView;

@property (strong, nonatomic) IBOutlet DOColorPreviewView *colorPreviewView;

@property (weak, nonatomic) IBOutlet DODrawingView *drawingView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *buttonMove;

@property (strong, nonatomic) IBOutlet UIButton *buttonFile;

@property (strong, nonatomic) IBOutlet UIButton *buttonColor;

@property (strong, nonatomic) IBOutlet UIButton *buttonPicker;

@property (weak, nonatomic) IBOutlet UIButton *buttonPen;

- (IBAction)buttonFolderTouchUpInsideHandler:(id)sender;

- (IBAction)buttonSubviewTouchUpInsideHandler:(id)sender;

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender;

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender;

- (IBAction)buttonMoveTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPickerTouchUpInsideHandler:(id)sender;

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPullTouchUpInsideHandler:(id)sender;

- (IBAction)buttonEraseTouchUpInsideHandler:(id)sender;

- (IBAction)buttonPenTouchUpInsideHandler:(id)sender;

- (void)changeApplicationState:(unsigned int)state;

- (void)changeNavigationStatus:(NSNumber *)status;

- (void)openSubsite:(unsigned int)subsite;

- (void)switchDrawingState:(unsigned int)state;

- (void)unSelectButtonList:(NSArray *)list;

@end
