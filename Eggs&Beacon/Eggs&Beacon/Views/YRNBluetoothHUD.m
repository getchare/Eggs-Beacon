//
//  YRNBluetoothHUD.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 13/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "YRNBluetoothHUD.h"

static CGFloat const YRNHUDSize = 160.0f;
static CGFloat const YRNHUDRadius = 10.0f;

static CGFloat const YRNImageSize = 80.0f;
static CGFloat const YRNImageOffset = 30.0f;

static CGFloat const YRNLabelOffset = 110.0f;
static CGFloat const YRNLabelFontSize = 16.0f;

static NSTimeInterval const YRNAnimationDuration = 0.5f;

@interface YRNBluetoothHUD ()

@property (nonatomic, strong) UIToolbar *hudView;
@property (nonatomic, strong) UIView *animationBackgroundView;
@property (nonatomic, strong) UIImageView *bluetoothImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation YRNBluetoothHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:[self animationBackgroundView]];
        [self addSubview:[self label]];
        [self addSubview:[self bluetoothImageView]];
    }
    return self;
}

+ (instancetype)sharedHUD
{
    static YRNBluetoothHUD *_sharedHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGPoint center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds));
        _sharedHUD = [[self alloc] initWithFrame:CGRectMake(center.x - YRNHUDSize * 0.5f,
                                                            center.y - YRNHUDSize * 0.5f,
                                                            YRNHUDSize,
                                                            YRNHUDSize)];
    });
    return _sharedHUD;
}

- (UIToolbar *)hudView
{
    if(!_hudView)
    {
        _hudView = [[UIToolbar alloc] initWithFrame:[self bounds]];
        [_hudView setTranslucent:YES];
        [[_hudView layer] setCornerRadius:YRNHUDRadius];
        [[_hudView layer] setMasksToBounds
         :YES];
    }
    return _hudView;
}

- (UIView *)animationBackgroundView
{
    if (!_animationBackgroundView)
    {
        _animationBackgroundView = [[UIView alloc] initWithFrame:[self bounds]];
        [_animationBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [[_animationBackgroundView layer] setCornerRadius:YRNHUDRadius];
        [[_animationBackgroundView layer] setMasksToBounds:YES];
    }
    return _animationBackgroundView;
}

- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, YRNLabelOffset, YRNHUDSize, YRNHUDSize - YRNLabelOffset)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setFont:[UIFont boldSystemFontOfSize:YRNLabelFontSize]];
        [_label setText:@"Bluetooth OFF"];
    }
    return _label;
}

- (UIImageView *)bluetoothImageView
{
    if (!_bluetoothImageView)
    {
        _bluetoothImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, YRNImageSize, YRNImageSize)];
        [_bluetoothImageView setBackgroundColor:[UIColor clearColor]];
        [_bluetoothImageView setCenter:CGPointMake(CGRectGetMidX([self bounds]), YRNImageOffset + YRNImageSize * 0.5f)];
        [_bluetoothImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_bluetoothImageView setImage:[UIImage imageNamed:@"bluetooth"]];
    }
    return _bluetoothImageView;
}

+ (void)show
{
    if (![[self sharedHUD] superview])
    {
        [[self sharedHUD] setAlpha:0.0f];
        [[self sharedHUD] insertSubview:[[self sharedHUD] animationBackgroundView]
                                atIndex:0];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:[self sharedHUD]];
    }
    [UIView animateWithDuration:YRNAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [[self sharedHUD] setAlpha:1.0f];
                     }
                     completion:^(BOOL finished) {
                         if ([[self sharedHUD] alpha] == 1.0f) {
                             [[self sharedHUD] insertSubview:[[self sharedHUD] hudView]
                                                     atIndex:0];
                             [[[self sharedHUD] animationBackgroundView] removeFromSuperview];
                         }
                     }];
}

+ (void)hide
{
    if ([[self sharedHUD] superview])
    {
        [[self sharedHUD] insertSubview:[[self sharedHUD] animationBackgroundView]
                                atIndex:0];
        [[[self sharedHUD] hudView] removeFromSuperview];
        [UIView animateWithDuration:YRNAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [[self sharedHUD] setAlpha:0.0f];
                         }
                         completion:^(BOOL finished) {
                             if ([[self sharedHUD] alpha] == 0.0f)
                             {
                                 [[self sharedHUD] removeFromSuperview];
                             }
                         }];
    }
}

+ (BOOL)isVisible
{
    return [[self sharedHUD] alpha] == 0.0f;
}

@end
