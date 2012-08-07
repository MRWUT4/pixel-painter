//
//  DOFileSettingsViewController.m
//  pixel painter
//
//  Created by David Ochmann on 06.08.12.
//
//

#import "DOFileSettingsViewController.h"

@interface DOFileSettingsViewController ()

@end


@implementation DOFileSettingsViewController

@synthesize model = _model;
@synthesize imagePickerDelegate = _imagePickerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*
 * IBACTIONS
 */

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender
{
    UIImageView *drawingViewImage = self.model.drawingViewImage;
    
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(drawingViewImage.image.CGImage, drawingViewImage.bounds)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *imagePNG = [UIImage imageWithData:imageData];
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect([imagePNG CGImage], drawingViewImage.bounds);
    UIImage *finalImage = [UIImage imageWithCGImage:croppedImage];
    
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
}

- (IBAction)buttonOpenTouchUpInsideHandler:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
   
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.model.width = originalImage.size.width;
    self.model.height = originalImage.size.height;
    
    [self.model.drawingViewImage setImage: originalImage];
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)buttonNewTouchUpInsideHandler:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NEW FILE"
                                                        message:@"Are you sure you want to clear your current image?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES",
                              nil];
    
    alertView.tag = ALERTVIEW_CLEARDRAWINGVIEW;
    [alertView show];
}

/* IBACTIONS TEXTFIELD SIZE */

- (IBAction)buttonResizeTouchUpInsideHandler:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RESIZE"
                                                        message:@"\n\n\n"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES",
                              nil];
    
    alertView.tag = ALERTVIEW_RESIZE;
    
    
    UITextField *fieldWidth = [[UITextField alloc] initWithFrame:CGRectMake(20, 49, 245, 25)];
    UITextField *fieldHeight = [[UITextField alloc] initWithFrame:CGRectMake(20, 81, 245, 25)];
    
    NSArray *fieldList = [[NSArray alloc] initWithObjects:fieldWidth, fieldHeight, nil];
    UITextField *field;
    
    for(uint i = 0; i < fieldList.count; i++)
    {
        field = [fieldList objectAtIndex:i];
        
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.backgroundColor = [UIColor whiteColor];
        
        [field addTarget:self action:@selector(textSizeEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        
        [alertView addSubview:field];
    }
    
    [fieldWidth addTarget:self action:@selector(textSizeWidthEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [fieldHeight addTarget:self action:@selector(textSizeHeightEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    fieldWidth.text = [NSString stringWithFormat:FIELD_RESIZE_WIDTH_TEXT, self.model.width];
    fieldWidth.tag = ALERTVIEW_RESIZE_FIELD_WIDTH_TAG;
    
    fieldHeight.text = [NSString stringWithFormat:FIELD_RESIZE_HEIGHT_TEXT, self.model.height];
    fieldHeight.tag = ALERTVIEW_RESIZE_FIELD_HEIGHT_TAG;
    
    [alertView show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    CGRect alertViewFrame = alertView.frame;
    alertViewFrame.size.height = 190;
    
    if(alertView.tag == ALERTVIEW_RESIZE)
        alertView.frame = alertViewFrame;
}


- (IBAction)textSizeEditingDidBegin:(UITextField *)sender
{
    sender.text = @"";
}

- (IBAction)textSizeWidthEditingDidEnd:(UITextField *)sender
{
    [self fillEmptySizeTextField:sender withText:FIELD_RESIZE_WIDTH_TEXT andSize:self.model.width];
}

- (IBAction)textSizeHeightEditingDidEnd:(UITextField *)sender
{
    [self fillEmptySizeTextField:sender withText:FIELD_RESIZE_HEIGHT_TEXT andSize:self.model.height];
}

- (void)fillEmptySizeTextField:(UITextField *)sender withText:(NSString *)text andSize:(unsigned int)size
{
    if([sender.text isEqualToString:@""] || [sender.text isEqualToString:@"0"])
        sender.text = [NSString stringWithFormat:text, size];
}



/*
 * ALERTVIEW CLICK HANDLER
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case ALERTVIEW_CLEARDRAWINGVIEW:
            if(buttonIndex == 1) [self.drawingView clearCompleteView];
            break;
            
        case ALERTVIEW_RESIZE:
            if(buttonIndex == 1)
            {
                self.model.width = [(NSString *)[[((UITextField *)[alertView viewWithTag:ALERTVIEW_RESIZE_FIELD_WIDTH_TAG]).text componentsSeparatedByString:@" "] objectAtIndex:0] intValue];
                
                self.model.height = [(NSString *)[[((UITextField *)[alertView viewWithTag:ALERTVIEW_RESIZE_FIELD_HEIGHT_TAG]).text componentsSeparatedByString:@" "] objectAtIndex:0] intValue];
            }
            break;
    }
}

@end
