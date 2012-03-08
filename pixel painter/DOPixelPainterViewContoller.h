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


@interface DOPixelPainterViewContoller : UIViewController <UIScrollViewDelegate>


@property (strong, nonatomic) DOPixelPainterModel *model;

@property (strong, nonatomic) DOSubviewManager *subviewManager;

@property (strong, nonatomic) IBOutlet DONavigationView *navigationView;

@property (weak, nonatomic) IBOutlet UIImageView *folderView;

@property (weak, nonatomic) IBOutlet DOColorPickerView *colorPickerView;

@property (weak, nonatomic) IBOutlet DOFileSettingsView *fileSettingsView;

@property (strong, nonatomic) IBOutlet GradientView *gradientView;

@property (strong, nonatomic) IBOutlet DOColorPreviewView *colorPreviewView;

@property (weak, nonatomic) IBOutlet DODrawingView *drawingView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *buttonMove;

- (IBAction)buttonFolderTouchUpInsideHandler:(id)sender;

- (IBAction)buttonSubviewTouchUpInsideHandler:(id)sender;

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender;

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender;

- (IBAction)buttonMoveTouchUpInsideHandler:(id)sender;

- (void)changeNavigationStatus:(NSNumber *)status;

@end
