//
//  ArcProgressView.m
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import "ArcProgressView.h"

@implementation ArcProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 5;
        self.progressBackgroundColor = [UIColor grayColor];
        self.progressColor = [UIColor redColor];
//        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath * backgroundPath = [UIBezierPath bezierPath];
    [backgroundPath addArcWithCenter:center radius:rect.size.width/2-self.lineWidth/2 startAngle:M_PI-M_PI/6 endAngle:M_PI/6 clockwise:YES];
    backgroundPath.lineWidth = self.lineWidth;
    [self.progressColor setStroke];
    [backgroundPath stroke];
    
    UIBezierPath * strokePath = [UIBezierPath bezierPath];
    strokePath.lineWidth = self.lineWidth;
    [self.progressBackgroundColor setStroke];
    strokePath.lineCapStyle = kCGLineCapButt;
    strokePath.lineJoinStyle = kCGLineJoinBevel;
    [strokePath addArcWithCenter:center radius:rect.size.width/2-self.lineWidth/2 startAngle:M_PI/6 endAngle:M_PI/6-M_PI*_progress clockwise:NO];
    [strokePath stroke];
    
}

@end
