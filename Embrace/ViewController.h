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



typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTING,
    CONNECTED,
} ConnectionState;

typedef enum
{
    LOGGING,
    RX,
    TX,
} ConsoleDataType;

typedef enum
{
    GET_TAG_COUNT = 0,
    GET_SERIAL,
    GET_MAJOR,
    GET_MINOR,
    GET_MFG_DATA,
    GET_ENABLE,
    GET_FOUND,
    GET_LAST_SEEN,
    GET_BATTERY,
    GET_SENSITIVITY,
    SET_SERIAL,
    SET_MAJOR,
    SET_MINOR,
    SET_MFG_DATA,
    SET_ENABLE,
    SET_SCAN_INTERVAL,
    SET_SCAN_TIMEOUT,
    SET_SCAN_START,
    SET_SCAN_STOP,
    SET_SENSITIVITY,
    SET_NOTIFICATION,
    DEL_TAG,
} tagCmdType;

@interface ViewController : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate,EYTagViewDelegate>

@property (strong, nonatomic) IBOutlet EYTagView *tagView;
@property (strong, nonatomic) IBOutlet EYTagView *tagView2;
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property (nonatomic) EYTagView_Type type;
@property tagRemote *tagRemotes;

@end

