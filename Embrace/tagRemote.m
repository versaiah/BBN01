//
//  tagRemote.m
//  Embrace
//
//  Created by Versaiah Fang on 8/15/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "tagRemote.h"

NSString *const KADtagName = @"name";
NSString *const KADtagSerial  = @"serial";
NSString *const KADtagMfgID  = @"mfgID";
NSString *const KADtagLastSeen  = @"lastSeen";
NSString *const KADtagMajor  = @"major";
NSString *const KADtagMinor  = @"minor";
NSString *const KADtagEnable  = @"enable";
NSString *const KADtagFound  = @"found";
NSString *const KADtagIndex  = @"index";

@implementation tagRemote

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:KADtagName];
        _serial = [coder decodeIntegerForKey:KADtagSerial];
        _mfgID = [coder decodeIntegerForKey:KADtagMfgID];
        _lastSeen = [coder decodeIntegerForKey:KADtagLastSeen];
        _major = [coder decodeIntegerForKey:KADtagMajor];
        _minor = [coder decodeIntegerForKey:KADtagMinor];
        _enable = [coder decodeIntegerForKey:KADtagEnable];
        _found = [coder decodeIntegerForKey:KADtagFound];
        _index = [coder decodeIntegerForKey:KADtagIndex];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    if ([coder isKindOfClass:[NSKeyedArchiver class]]) {
        [coder encodeObject:_name forKey:KADtagName];
        [coder encodeInteger:_serial forKey:KADtagSerial];
        [coder encodeInteger:_mfgID forKey:KADtagMfgID];
        [coder encodeInteger:_lastSeen forKey:KADtagLastSeen];
        [coder encodeInteger:_major forKey:KADtagMajor];
        [coder encodeInteger:_minor forKey:KADtagMinor];
        [coder encodeInteger:_enable forKey:KADtagEnable];
        [coder encodeInteger:_found forKey:KADtagFound];
        [coder encodeInteger:_index forKey:KADtagIndex];
    } else {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"Only supports NSKeyedArchiver coders"];
    }
}

@end

@implementation tagController

@end
