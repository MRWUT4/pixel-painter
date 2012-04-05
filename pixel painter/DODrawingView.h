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
@property(strong, nonatomic) UIColor *fillPickColor;

@property (nonatomic, assign) CGPoint touchDown;
@property (nonatomic, assign) CGPoint touchPosition;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) unsigned int mode;

- (void)drawAtPosition:(CGPoint)position;
- (void)clearAtPosition;
- (void)pickColorAtPosition;
- (void)moveImageToPosition;
- (void)fillImageAtPositionLeft:(CGPoint)position;
- (void)fillImageAtPositionRight:(CGPoint)position;


- (BOOL)positionIsInBounds:(CGPoint)position;

- (void)modeAction:(NSSet *)touches;
- (void)clearCompleteView;
- (void)clearViewFrame:(NSValue *)rectangle;

- (void)changeDrawingViewSize:(NSValue *)rectangle;
- (void)cropCurrentDisposition;

@end
