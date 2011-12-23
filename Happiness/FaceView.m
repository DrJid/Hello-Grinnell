//
//  FaceView.m
//  Happiness
//
//  Created by Maijid  Moujaled on 11/25/11.
//  Copyright (c) 2011 Grinnell College. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90

-(CGFloat)scale
{
    //I don't want this to be 0. 
    if (!_scale) {
        return DEFAULT_SCALE;
    }
    else return _scale;
}

-(void)setScale:(CGFloat)scale
{
    //This is very commonly done within the setters of views. 
    if (_scale != scale) {
        _scale = scale;
    
    //If somebody sets my scale, i get to redraw! So i do this in the setter. 
    [self setNeedsDisplay];
    }
}

//this is to implement a handler. We're gonna implement the pinch handler here. 
-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    //Along as the pinch has ended or at the last point of the pinch to end, 
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        self.scale *= gesture.scale;
        
        //But here we set the gesture scale to one all the time. So there's not continuous implementation of the scale. Cool way to have a stateless recognizer. 
        gesture.scale = 1;
    }
}

- (void)setup
{
        self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}
//It stubbed out initwithframe but we would also want to to call awakefromnib since that is what is called during storyboarding. 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // we're going to fix the view here so that any initialization is actually recalling the draw rect and not stretching the variables. 
        [self setup];

    }
    return self;
}


//Since we're going to draw 3 circles, let's get a subrouting that draws a circle to make our job easier. duhh!
- (void)drawCircleAtPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    //Remember with subroutines, we need to push the context, do stuff to it and then pop it later on. 
    UIGraphicsPushContext(context);
    
    //We begin the path
    CGContextBeginPath(context);
    
    //Add an arc. 
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //The first thing you do in any drawing is to first get the context. Need it to call any of the Coregraphics code methods. without it, we can't draw crap. 
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Draw the face (circle);
    //Let'start by getting the midpoint of the face. 
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/ 2;
    
    //Set the size of the head depending on the shorter distance. 
    CGFloat size = self.bounds.size.width /2 ;
    if (self.bounds.size.height < self.bounds.size.width) {
        size = self.bounds.size.height;
    }
    
    //This is just to scale it down so it doesn't draw the head on the edges. 
    size *= self.scale;
    
    //set line width and line colour stuff. 
    CGContextSetLineWidth(context, 5.0);
    [[UIColor purpleColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    //Draw the eyes (2 circles);
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    // No nose
    
    //Draw the mouth -- This is done with some bezea curves... whatever that is. 
    
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    //We set the float smile to what the smileforfaceview datasource returns. 
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
    
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    
    CGContextStrokePath(context);
    
}


@end
