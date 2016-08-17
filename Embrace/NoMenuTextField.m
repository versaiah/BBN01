//
//  NoMenuTextField.m
//  Embrace
//
//  Created by Versaiah Fang on 8/17/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "NoMenuTextField.h"

@implementation NoMenuTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end