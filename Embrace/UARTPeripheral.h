//
//  UARTPeripheral.h
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTING,
    CONNECTED,
} ConnectionState;

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
    SET_MFG_ID,
    SET_ENABLE,
    SET_ENABLE_ALL,
    SET_SCAN_INTERVAL,
    SET_SCAN_TIMEOUT,
    SET_SCAN_START,
    SET_SCAN_STOP,
    SET_SENSITIVITY,
    SET_NOTIFICATION,
    DEL_TAG,
    DEL_ALL_TAG
} tagCmdType;

@protocol UARTPeripheralDelegate
- (void) didReceiveData:(NSString *) string;
@optional
- (void) didReadyToGo;
- (void) didReadHardwareRevisionString:(NSString *) string;
@end


@interface UARTPeripheral : NSObject <CBPeripheralDelegate>
@property CBPeripheral *peripheral;
@property id<UARTPeripheralDelegate> delegate;

+ (CBUUID *) uartServiceUUID;

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate;

- (void) writeString:(NSString *) string;

- (void) didConnect;
- (void) didDisconnect;
@end
