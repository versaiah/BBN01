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
#import "tagRemote.h"
#import "AddTagView.h"

@interface SearchTagView : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate, EYTagViewDelegate>

@property (strong, nonatomic) IBOutlet EYTagView *tagView;
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property NSMutableArray *tagArrayOrg;
@property NSMutableArray *tagArrayNew;

@end
