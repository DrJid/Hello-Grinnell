//
//  HappinessViewController.m
//  Happiness
//
//  Created by Maijid  Moujaled on 11/25/11.
//  Copyright (c) 2011 Grinnell College. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

//Create a private property for our custom newly created faceview. 
//Since faceview is privately implemented. We set the delegate also in private. instead of the headerfile. 
@interface HappinessViewController() <FaceViewDataSource>
@property (nonatomic, weak) IBOutlet FaceView *faceview;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceview = _faceview;


//Whenever our model is changed, we need to update our custome faceview screen. We'll do this by saying setNeedsDisplay function on our view to redraw it. remember we never call drawrect directly. This is the regular setter method. which is called whenever our model is changed. i.e happiness is changed. 
- (void) setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceview setNeedsDisplay];
}

//We add this recognizer to the outlet setter for the faceview. 
- (void) setFaceview:(FaceView *)faceview
{
    _faceview = faceview;
    //the target is the object that is going to handle this gesture when it happens which is. self.faceview. Since hte view is going to handle it. 
    [self.faceview addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceview action:@selector(pinch:)]];
//the target here is not going to be the faceview because it can't do model stuff. It's the controller
    [self.faceview addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];

    self.faceview.dataSource = self;
}

-(void)handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    
    
    
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        //We still want the gesture to be happening in the views coordinate system here. So this method translates the pan gesture into the faceview's coordinates. 
        CGPoint translation = [gesture translationInView:self.faceview];
        self.happiness -= translation.y / 2;
        
        //Set the translation so it's not cumulative but it resets all the time. 
        [gesture setTranslation:CGPointZero inView:self.faceview];
        
  
    }
}

- (float)smileForFaceView:(FaceView *)sender
{
    return (self.happiness - 50) / 50.0;
}


//Suport rotation to any orientation
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
