//
//  SetupSettingsView.h
//  Embrace
//
//  Created by Versaiah Fang on 8/18/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoMenuTextField.h"
#import "EYTagView.h"

@protocol SetupSettingsViewDelegate
- (void)setController:(NSInteger)interval timeout:(NSInteger)timeout notify:(NSInteger)notify;
@end

@interface SetupSettingsView : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) id <SetupSettingsViewDelegate> delegate;
@property (nonatomic, strong) UIFont *viewFont;
@property (nonatomic, strong) NoMenuTextField *tfInterval;
@property (nonatomic, strong) NoMenuTextField *tfTimeout;
@property UIButton *btnNotifyEnable;
@property tagController *tagControll;

@end
