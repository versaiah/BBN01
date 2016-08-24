//
//  ViewController.h
//  Embrace
//
//  Created by Versaiah Fang on 7/28/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYTagView.h"
#import "UARTPeripheral.h"
#import "tagRemote.h"
#import "ActiveInfoView.h"
#import "InActiveInfoView.h"
#import "MissingInfoView.h"
#import "SearchTagView.h"
#import "AddTagView.h"
#import "SetupSettingsView.h"

#define MAX_TAGS            5
#define SCAN_TIMEOUT        5
#define REQUEST_INTERVAL    10

@interface ViewController : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate,EYTagViewDelegate, ActiveInfoViewDelegate, MissingInfoViewDelegate, InactiveInfoViewDelegate, SetupSettingsViewDelegate>;

@property (strong, nonatomic) IBOutlet EYTagView *tagView;
@property (strong, nonatomic) IBOutlet EYTagView *tagView2;
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property NSMutableArray *tagArray;
@property NSInteger tagCount;
@property tagController *tagControll;
@property (nonatomic, strong) UIFont* fontSize;

- (void)tagAddAfterSearch:(tagRemote *)tagTarget;

@end

