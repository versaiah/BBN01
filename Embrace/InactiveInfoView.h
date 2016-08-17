//
//  InactiveInfoView.h
//  Embrace
//
//  Created by Versaiah Fang on 8/9/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYTagView.h"
#import "tagRemote.h"
#import "NoMenuTextField.h"

@protocol InactiveInfoViewDelegate
- (void)tagEnable:(NSInteger)index;
- (void)tagRemove:(NSInteger)index;
- (void)tagRename:(NSInteger)index;
@end

@interface InactiveInfoView : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) id<InactiveInfoViewDelegate> delegate;
@property tagRemote *tagRemotes;
@property NoMenuTextField *tfName;

@end