//
//  tagRemote.h
//  Embrace
//
//  Created by Versaiah Fang on 8/15/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tagRemote : NSObject <NSCoding>
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, assign) NSUInteger    serial;
@property (nonatomic, assign) NSUInteger    mfgID;
@property (nonatomic, assign) NSUInteger    lastSeen;
@property (nonatomic, assign) NSUInteger    major;
@property (nonatomic, assign) NSUInteger    minor;
@property (nonatomic, assign) NSUInteger    enable;
@property (nonatomic, assign) NSUInteger    found;
@property (nonatomic, assign) NSUInteger    index;
@end

@interface tagController : NSObject
@property (nonatomic, assign) NSUInteger    timeout;
@property (nonatomic, assign) NSUInteger    interval;
@property (nonatomic, assign) NSUInteger    NotifyEnable;
@end

