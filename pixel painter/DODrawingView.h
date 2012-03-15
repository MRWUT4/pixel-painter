//
//  DODrawingView.h
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DODrawingView : UIView

@property(strong, nonatomic) UIColor *color;

@property (nonatomic, assign) CGPoint touchPosition;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) unsigned int mode;

- (void)drawAtTouches:(NSSet*)touches;
- (void)clearAtTouches:(NSSet*)touches;
- (void)pickColorAtTouches:(NSSet*)touches;
- (void)modeAction:(NSSet *)touches;
- (void)clearCompleteView;
- (void)clearViewFrame:(NSValue *)rectangle;

@end
