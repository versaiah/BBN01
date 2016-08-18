//
//  AddTagView.h
//  Embrace
//
//  Created by Versaiah Fang on 8/17/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYTagView.h"
#import "tagRemote.h"
#import "NoMenuTextField.h"
#import "ViewController.h"

@interface AddTagView : UIViewController <UITextFieldDelegate>
@property tagRemote *tagRemotes;
@property NoMenuTextField *tfName;

@end
