//
//  ViewController.m
//  Embrace
//
//  Created by Versaiah Fang on 7/28/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;

NSArray     *tagCmdArray;
NSInteger   tagNotify;
NSInteger   tagResp;
NSInteger   targetCmd;
NSInteger   sendCmdStatus;
NSTimer     *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
    
    tagCmdArray = [NSArray arrayWithObjects:@"*GTC#",
                                            @"*GSN-YYY#",
                                            @"*GMA-YYY#",
                                            @"*GMI-YYY#",
                                            @"*GMF-YYY#",
                                            @"*GEN-YYY#",
                                            @"*GFN-YYY#",
                                            @"*GLS-YYY#",
                                            @"*GBL#",
                                            @"*GSY#",
                                            @"*SSN-YYY-XXXXXX#",
                                            @"*SMA-YYY-XXXX#",
                                            @"*SMI-YYY-XXXX#",
                                            @"*SMF-YYY-XXXX#",
                                            @"*SEN-YYY-X#",
                                            @"*SSI-XX#",
                                            @"*SST-XXX#",
                                            @"*SSS#",
                                            @"*STS#",
                                            @"*SSY-XXX#",
                                            @"*SNE-X#",
                                            @"*DET-YYY#",
                                            nil];

    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageMainBG"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];

    _tagRemotes = malloc(sizeof(tagRemote) * MAX_TAGS);
    _tagRemotes[0].name = @"Notebook";
    _tagRemotes[1].name = @"Laptop";
    _tagRemotes[2].name = @"Pen Case";
    _tagRemotes[3].name = @"Watch";
    _tagRemotes[4].name = @"Book";
    
    _tagView = [[EYTagView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + 33,
                                                          self.view.bounds.origin.y + 98,
                                                          self.view.bounds.size.width - 55,
                                                          self.view.bounds.size.height - 100)];
    _tagView.delegate = self;
    _tagView.colorTag = COLORRGB(0xffffff);
    _tagView.colorTagBg = COLORRGB(0x007000);
    _tagView.colorInput = COLORRGB(0x2ab44e);
    _tagView.colorInputBg = COLORRGB(0xffffff);
    _tagView.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView.backgroundColor = COLORRGB(0xffffff);
    _tagView.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView.viewMaxHeight = self.view.bounds.size.height - 100;
    _tagView.type = EYTagView_Type_Edit;
    
    [_tagView layoutTagviews];
    [self.view addSubview:_tagView];
    
    _tagView2 = [[EYTagView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + 33,
                                                           self.view.bounds.origin.y + 260,
                                                           self.view.bounds.size.width - 55,
                                                           self.view.bounds.size.height - 100)];
    _tagView2.delegate = self;
    _tagView2.colorTag = COLORRGB(0xffffff);
    _tagView2.colorTagBg = COLORRGB(0x848484);
    _tagView2.colorInput = COLORRGB(0x2ab44e);
    _tagView2.colorInputBg = COLORRGB(0xffffff);
    _tagView2.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView2.backgroundColor = COLORRGB(0xffffff);
    _tagView2.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView2.viewMaxHeight = self.view.bounds.size.height - 100;
    _tagView2.type = EYTagView_Type_Edit_Only_Delete;
    
    [_tagView2 layoutTagviews];
    [self.view addSubview:_tagView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)heightDidChangedTagView:(EYTagView *)tagView
{
    NSLog(@"heightDidChangedTagView");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManagerDidUpdateState");
        [timer fire];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [self.cm stopScan];
    self.state = CONNECTING;
    
    /*
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"\n"];
    [nsmstring appendString:@"Peripheral Info:"];
    [nsmstring appendFormat:@"NAME: %@\n",peripheral.name];
    [nsmstring appendFormat:@"RSSI: %@\n",RSSI];
    
    [nsmstring appendFormat:@"adverisement:%@",advertisementData];
    NSLog(@"%@",nsmstring);*/

    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [self.cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
        self.state = CONNECTED;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
        self.state = IDLE;
        if (timer.isValid == NO) {
            timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
            [timer fire];
        }
    }
}

- (void)scanTimeout:(NSTimer*)timer
{
    switch (self.state) {
        case IDLE:
            NSLog(@"Started scan ...");
            [self.cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
            self.state = SCANNING;
            break;
        case SCANNING:
            //[self.cm stopScan];
            //[self.cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
            //NSLog(@"ReStarted scan ...");
            break;
        case CONNECTING:
            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
            [self.cm connectPeripheral:self.currentPeripheral.peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
            NSLog(@"ReCONNECTING ...");
            break;
        case CONNECTED:
            [timer invalidate];
            timer = nil;
            break;
        default:
            break;
    }
}

- (void)didReadyToGo
{
    [self sendCmdToController:GET_ENABLE];
    [self sendCmdToController:GET_MAJOR];
    [self sendCmdToController:GET_MINOR];
    [self sendCmdToController:GET_MFG_DATA];
    [self sendCmdToController:GET_FOUND];
}

- (void)didReceiveData:(NSString *)string
{
    NSRange searchResult;
    NSString *tmp;
    unsigned long red;
    
    NSLog(@"===%@===", string);
    if (string == NULL) {
        [self sendCmdToController:targetCmd];
        return;
    }
    
    searchResult = [string rangeOfString:@"MISSING"];
    if (searchResult.location != NSNotFound) {
        if (tagNotify == 0) {
            [self sendCmdToController:GET_FOUND];
            tagNotify = 9;
        }
        tagNotify--;
    }
    
    searchResult = [string rangeOfString:@"*GFN-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        _tagRemotes[tagResp].found = [tmp integerValue];
        tagResp++;
        if (tagResp == MAX_TAGS) {
            [self reNewButtonStatus];
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GMA-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        red = strtoul([tmp UTF8String],0,16);
        _tagRemotes[tagResp].major = red;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            //[self reNewButtonStatus];
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GMI-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        red = strtoul([tmp UTF8String],0,16);
        _tagRemotes[tagResp].minor = red;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            //[self reNewButtonStatus];
            tagResp = 0;
            [self addTags];
        }
    }
    
    searchResult = [string rangeOfString:@"*GMF-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        red = strtoul([tmp UTF8String],0,16);
        _tagRemotes[tagResp].minor = red;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            //[self reNewButtonStatus];
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GEN-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        _tagRemotes[tagResp].enable = [tmp integerValue];
        tagResp++;
        _tagRemotes[tagResp].index = tagResp;
        if (tagResp == MAX_TAGS) {
            //[self reNewButtonStatus];
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*STS-"];
    if (searchResult.location != NSNotFound) {
        searchResult = [string rangeOfString:@"OK"];
        if (searchResult.location == NSNotFound) {
            [self sendCmdToController:targetCmd];
        }
    }
}

- (void)sendCmdToController: (int)command
{
    NSString *tmp1, *tmp2;
    
    targetCmd = command;
    tmp1 = tagCmdArray[command];
    
    switch (command) {
        case GET_SERIAL:
            
            break;
        case GET_MAJOR:
            for (int i = 0; i < MAX_TAGS; i++) {
                tmp1 = tagCmdArray[GET_MAJOR];
                tmp2 = [NSString stringWithFormat: @"%03d", i + 1];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
                [self.currentPeripheral writeString:tmp1];
            }
            break;
        case GET_MINOR:
            for (int i = 0; i < MAX_TAGS; i++) {
                tmp1 = tagCmdArray[GET_MINOR];
                tmp2 = [NSString stringWithFormat: @"%03d", i + 1];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
                [self.currentPeripheral writeString:tmp1];
            }
            break;
        case GET_MFG_DATA:
            for (int i = 0; i < MAX_TAGS; i++) {
                tmp1 = tagCmdArray[GET_MFG_DATA];
                tmp2 = [NSString stringWithFormat: @"%03d", i + 1];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
                [self.currentPeripheral writeString:tmp1];
            }
            break;
        case GET_ENABLE:
            for (int i = 0; i < MAX_TAGS; i++) {
                tmp1 = tagCmdArray[GET_ENABLE];
                tmp2 = [NSString stringWithFormat: @"%03d", i + 1];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
                [self.currentPeripheral writeString:tmp1];
            }
            break;
        case GET_FOUND:
            for (int i = 0; i < MAX_TAGS; i++) {
                tmp1 = tagCmdArray[GET_FOUND];
                tmp2 = [NSString stringWithFormat: @"%03d", i + 1];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
                [self.currentPeripheral writeString:tmp1];
            }
            break;
        case GET_LAST_SEEN:
            
            break;
        case SET_SERIAL:
            
            break;
        case SET_MAJOR:
            
            break;
        case SET_MINOR:
            
            break;
        case SET_MFG_DATA:
            
            break;
        case SET_ENABLE:
            
            break;
        case SET_SCAN_INTERVAL:
            
            break;
        case SET_SCAN_TIMEOUT:
            
            break;
        case GET_TAG_COUNT:
        case GET_BATTERY:
        case GET_SENSITIVITY:
        case SET_SCAN_START:
        case SET_SCAN_STOP:
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_SENSITIVITY:
            
            break;
        case SET_NOTIFICATION:
            
            break;
            
        default:
            break;
    }
    NSLog(@"%@", tmp1);
}

- (void)reNewButtonStatus
{
    int index[MAX_TAGS];
    
    for (int i = 0; i < MAX_TAGS; i++) {
        index[i] = _tagRemotes[i].found;
    }
    [_tagView setAllTagBackground:_tagRemotes];
}

- (void)addTags
{
    NSString *tmp;
    
    for (int i = 0; i < MAX_TAGS; i++) {
        tmp = [NSString stringWithFormat: @"%@\n            %03d\n%04lX", _tagRemotes[i].name, i, _tagRemotes[i].minor];
        if (_tagRemotes[i].enable == 1) {
            [_tagView addTagToLast:tmp];
        } else {
            [_tagView2 addTagToLast:tmp];
        }
    }
}

- (void)tagDidPressing:(NSInteger)index
{
    //[self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
}

@end
