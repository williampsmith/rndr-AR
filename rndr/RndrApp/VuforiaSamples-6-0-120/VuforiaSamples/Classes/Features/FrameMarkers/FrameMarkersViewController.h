/*===============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.
===============================================================================*/

#import <UIKit/UIKit.h>
#import "FrameMarkersEAGLView.h"
#import "SampleApplicationSession.h"
#import "SampleAppMenuViewController.h"
#import <Vuforia/DataSet.h>

@interface FrameMarkersViewController : UIViewController <SampleApplicationControl, SampleAppMenuDelegate> {
    
    // menu options
    BOOL continuousAutofocusEnabled;
    BOOL flashEnabled;
    BOOL frontCameraEnabled;
}

@property (nonatomic, strong) FrameMarkersEAGLView* eaglView;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;
@property (nonatomic, strong) SampleApplicationSession * vapp;

@property (nonatomic, readwrite) BOOL showingMenu;

@end
