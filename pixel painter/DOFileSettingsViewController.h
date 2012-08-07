//
//  DOFileSettingsViewController.h
//  pixel painter
//
//  Created by David Ochmann on 06.08.12.
//
//

#import <UIKit/UIKit.h>
#import "DOConstants.h"
#import "DODrawingView.h"
#import "DOPixelPainterModel.h"

@interface DOFileSettingsViewController : UIViewController

@property (strong, nonatomic) DOPixelPainterModel *model;

@property (strong, nonatomic) DODrawingView *drawingView;

@property (strong, nonatomic) id imagePickerDelegate;

@property (strong, nonatomic) IBOutlet UITextField *textFieldWidth;

@property (strong, nonatomic) IBOutlet UITextField *textFieldHeight;

- (IBAction)buttonNewTouchUpInsideHandler:(id)sender;

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender;

- (IBAction)buttonOpenTouchUpInsideHandler:(id)sender;

- (IBAction)buttonResizeTouchUpInsideHandler:(id)sender;

//- (IBAction)textSizeEditingDidBegin:(UITextField *)sender;

 
@end
