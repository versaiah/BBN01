//
//  SearchTagView.h
//  Embrace
//
//  Created by Versaiah Fang on 8/11/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYTagView.h"
#import "UARTPeripheral.h"

@protocol SearchTagViewDelegate
- (void)tagAddAfterSearch:(NSString *)tagName major:(unsigned long)tagMajor minor:(unsigned long)tagMinor;
@end

@interface SearchTagView : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate,EYTagViewDelegate>

@property (nonatomic, strong) id <SearchTagViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet EYTagView *tagView;
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property tagRemote *tagRemotes;
@property NSInteger tagCount;
@property (nonatomic, copy) NSString *tagName;

@end
