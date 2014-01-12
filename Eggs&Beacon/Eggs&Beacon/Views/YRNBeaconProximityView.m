//
//  YRNBeaconProximityView.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

static CGFloat const YRNIPhoneWidth = 15.0f;
static CGFloat const YRNIPhoneHeight = 25.0f;
static CGFloat const YRNBeaconCircleRadius = 6.0f;

static CGFloat const YRNImmediateAlpha = 1.0f;
static CGFloat const YRNNearAlpha = 0.5f;
static CGFloat const YRNFarAlpha = 0.2f;

#import "YRNBeaconProximityView.h"

@implementation YRNBeaconProximityView

@synthesize tintColor = _tintColor;
@synthesize beaconColor = _beaconColor;
@synthesize iPhoneColor = _iPhoneColor;

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    _proximity = CLProximityUnknown;
}

- (void)setProximity:(CLProximity)proximity
{
    if (_proximity != proximity) {
        _proximity = proximity;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat step = rect.size.width * 0.2f;
    CGPoint center = CGPointMake(step * 0.65f, CGRectGetMidY(rect));
    
    // Draw immediate circle
    [[[self tintColor] colorWithAlphaComponent:YRNImmediateAlpha] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(center.x - step,
                                                   center.y - step,
                                                   step * 2.0f,
                                                   step * 2.0f));
    
    // Draw near circle
    [[[self tintColor] colorWithAlphaComponent:YRNNearAlpha] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(center.x - step * 2.0f,
                                                   center.y - step * 2.0f,
                                                   step * 4.0f,
                                                   step * 4.0f));
    
    // Draw far circle
    [[[self tintColor] colorWithAlphaComponent:YRNFarAlpha] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(center.x - step * 3.0f,
                                                   center.y - step * 3.0f,
                                                   step * 6.0f,
                                                   step * 6.0f));
    
    // Draw iPhone
    [[self iPhoneColor] setFill];
    CGContextFillRect(context, CGRectMake(center.x - YRNIPhoneWidth * 0.5f,
                                          center.y - YRNIPhoneHeight * 0.5f,
                                          YRNIPhoneWidth,
                                          YRNIPhoneHeight));
    
    // Draw beacon
    CGPoint beaconCenter = CGPointZero;
    [[self beaconColor] setFill];
    switch ([self proximity]) {
        case CLProximityImmediate:
        {
            beaconCenter = CGPointMake(center.x + step * 0.5f, center.y);
        }
            break;
        case CLProximityNear:
        {
            beaconCenter = CGPointMake(center.x + step * 1.5f, center.y);
        }
            break;
        case CLProximityFar:
        {
            beaconCenter = CGPointMake(center.x + step * 2.5f, center.y);
        }
            break;
        case CLProximityUnknown:
        {
            beaconCenter = CGPointMake(center.x + step * 3.5f, center.y);
            [[[UIColor redColor] colorWithAlphaComponent:0.5f] setFill];
        }
            break;
        default:
            break;
    }
    CGContextFillEllipseInRect(context, CGRectMake(beaconCenter.x - YRNBeaconCircleRadius,
                                                   beaconCenter.y - YRNBeaconCircleRadius,
                                                   YRNBeaconCircleRadius * 2.0f,
                                                   YRNBeaconCircleRadius * 2.0f));
}

#pragma mark - Colors

- (UIColor *)tintColor
{
    if (!_tintColor) {
        _tintColor = [UIColor blackColor];
    }
    return _tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)beaconColor
{
    if (!_beaconColor) {
        _beaconColor = [UIColor greenColor];
    }
    return _beaconColor;
}

- (void)setBeaconColor:(UIColor *)beaconColor
{
    if (![_beaconColor isEqual:beaconColor]) {
        _beaconColor = beaconColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)iPhoneColor
{
    if (!_iPhoneColor) {
        _iPhoneColor = [UIColor whiteColor];
    }
    return _iPhoneColor;
}

- (void)setIPhoneColor:(UIColor *)iPhoneColor
{
    if (![_iPhoneColor isEqual:iPhoneColor]) {
        _iPhoneColor = iPhoneColor;
        [self setNeedsDisplay];
    }
}

@end
