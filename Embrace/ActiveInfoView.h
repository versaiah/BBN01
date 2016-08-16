//
//  ActiveInfoView.h
//  Embrace
//
//  Created by Versaiah Fang on 8/9/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYTagView.h"
#import "tagRemote.h"

@protocol ActiveInfoViewDelegate
- (void)tagDisable:(NSInteger)index;
- (void)tagRemove:(NSInteger)index;
@end

@interface ActiveInfoView : UIViewController
@property (nonatomic, strong) id <ActiveInfoViewDelegate> delegate;
@property tagRemote *tagRemotes;

@end
