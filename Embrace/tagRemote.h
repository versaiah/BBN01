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
@property (nonatomic, assign) NSInteger    serial;
@property (nonatomic, assign) NSInteger    mfgID;
@property (nonatomic, assign) NSInteger    lastSeen;
@property (nonatomic, assign) NSInteger    major;
@property (nonatomic, assign) NSInteger    minor;
@property (nonatomic, assign) NSInteger    enable;
@property (nonatomic, assign) NSInteger    found;
@property (nonatomic, assign) NSInteger    index;
@end

