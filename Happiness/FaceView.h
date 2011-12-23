//
//  FaceView.h
//  Happiness
//
//  Created by Maijid  Moujaled on 11/25/11.
//  Copyright (c) 2011 Grinnell College. All rights reserved.
//

#import <UIKit/UIKit.h>

//Using forward reference. tells the compiler there's a class called faceview. 
@class FaceView;

//Call it datasource if it's the source of the data. 
@protocol FaceViewDataSource 

//I'm passing myself alongs. Just so they can ask us some questions if we want. Anytime you use a delegate. pass yourself along as a sender. 
- (float)smileForFaceView:(FaceView *)sender;

@end

@interface FaceView : UIView

//This property is going to be how zoomed in i am. It is public. 
@property (nonatomic) CGFloat scale;


//We need to add a recognizer to our view to actually recognize the view. but we'll let the controller add that recognizer! 
//We'll make our pinch here public so that anyone who uses our view will know that we implement this pinch handler in case they want to use it. Anyone using faceview will know oh look. Faceview does pinch, i'm gonna add a pinch recognizer. 
-(void)pinch:(UIPinchGestureRecognizer *)gesture;


//We have this datasource because if someone wants to control themselves as the smiley, they are going to set themselves as the datasource. And they would have to implement the protocol and it's requiried. This is how we would hook it up. 
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;
@end
