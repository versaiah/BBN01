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

NSString *const KADDataPlist = @"tag.plist";

@implementation ViewController
@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;

NSArray     *tagCmdArray;
NSArray     *connectStatusArray;
NSInteger   tagNotify;
NSInteger   tagResp;
NSInteger   targetCmd;
NSInteger   sendCmdStatus;
NSInteger   timerCheck;
UILabel     *labConnectStatus;
NSTimer     *timer;
UIButton    *btnSetup;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sgh = screenSize.height / 2208;
    CGFloat sgw = screenSize.width / 1242;
    
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
                                            @"*GSI#",
                                            @"*GST#",
                                            @"*GBL#",
                                            @"*GSY#",
                                            @"*GNE#",
                                            @"*SSN-YYY-XXXXXX#",
                                            @"*SMA-YYY-XXXX#",
                                            @"*SMI-YYY-XXXX#",
                                            @"*SMF-YYY-XXXX#",
                                            @"*SEN-YYY-X#",
                                            @"*SEA-X#",
                                            @"*SSI-XXX#",
                                            @"*SST-XXX#",
                                            @"*SSS#",
                                            @"*STS#",
                                            @"*SSY-XXX#",
                                            @"*SNE-X#",
                                            @"*DET-YYY#",
                                            @"*DEA#",
                                            nil];
    connectStatusArray = [NSArray arrayWithObjects:@"IDLE", @"SCANNING", @"CONNECTING", @"CONNECTED", nil];

    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGMain"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    btnSetup = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetup addTarget:self action:@selector(BTNSetupClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSetup.frame = CGRectMake(30*sgw, 30*sgh, 150*sgw, 150*sgh);
    [btnSetup setBackgroundImage:[UIImage imageNamed:@"ImageBTNSetup"] forState:UIControlStateNormal];
    [btnSetup setShowsTouchWhenHighlighted:YES];
    btnSetup.userInteractionEnabled = FALSE;
    [self.view addSubview:btnSetup];
    
    _tagView = [[EYTagView alloc]initWithFrame:CGRectMake(86*sgw, 460*sgh, 1071*sgw, 604*sgh)];
    _tagView.delegate = self;
    _tagView.colorTag = COLORRGB(0xffffff);
    _tagView.colorTagBg = COLORRGB(0x007000);
    _tagView.colorTagBgDisable = COLORRGB(0x848484);
    _tagView.colorInput = COLORRGB(0x2ab44e);
    _tagView.colorInputBg = COLORRGB(0xffffff);
    _tagView.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView.backgroundColor = COLORRGB(0xffffff);
    _tagView.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView.viewMaxHeight = 604*sgh;
    _tagView.type = EYTagView_Type_Edit;
    [_tagView setUserInteractionEnabled:FALSE];
    _tagView.alpha = 0.5;
    
    [_tagView layoutTagviews];
    [self.view addSubview:_tagView];
    
    _tagView2 = [[EYTagView alloc]initWithFrame:CGRectMake(86*sgw, 1224*sgh, 1071*sgw, 604*sgh)];
    _tagView2.delegate = self;
    _tagView2.colorTag = COLORRGB(0xffffff);
    _tagView2.colorTagBg = COLORRGB(0x848484);
    _tagView2.colorTagBgDisconnect = COLORRGB(0x848484);
    _tagView2.colorInput = COLORRGB(0x2ab44e);
    _tagView2.colorInputBg = COLORRGB(0xffffff);
    _tagView2.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView2.backgroundColor = COLORRGB(0xffffff);
    _tagView2.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView2.viewMaxHeight = 604*sgh;
    _tagView2.type = EYTagView_Type_Edit_Only_Delete;
    [_tagView2 setUserInteractionEnabled:FALSE];
    _tagView2.alpha = 0.5;
    
    [_tagView2 layoutTagviews];
    [self.view addSubview:_tagView2];
    
    labConnectStatus = [[UILabel alloc] initWithFrame:CGRectMake(850*sgw, 360*sgh, 300*sgw, 46*sgh)];
    [labConnectStatus setFont:[UIFont boldSystemFontOfSize:12]];
    labConnectStatus.textColor = [UIColor whiteColor];
    labConnectStatus.text = connectStatusArray[self.state];
    labConnectStatus.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:labConnectStatus];
    
    _tagArray = [self loadDataFromFile];
    if (_tagArray != nil) {
        [self addTags];
    }
    _tagControll = [[tagController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (animated) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)heightDidChangedTagView:(EYTagView *)tagView
{
    //NSLog(@"heightDidChangedTagView");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        //NSLog(@"centralManagerDidUpdateState");
        [timer fire];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Find peripheral %@", peripheral.name);
    [self.cm stopScan];
    self.state = CONNECTING;
    /*
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"\n"];
    [nsmstring appendString:@"Peripheral Info:"];
    [nsmstring appendFormat:@"NAME: %@\n",peripheral.name];
    [nsmstring appendFormat:@"RSSI: %@\n",RSSI];
    
    [nsmstring appendFormat:@"adverisement:%@",advertisementData];
    NSLog(@"%@",nsmstring);
     */
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [self.cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Faild to Connect with peripheral %@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connect to peripheral %@", peripheral.name);
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
        sleep(1);
        self.state = CONNECTED;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Disconnect with peripheral %@", peripheral.name);
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
        self.state = IDLE;
        if (timer.isValid == NO) {
            timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
            [timer fire];
        } else {
            timer.fireDate = [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
        }
        [_tagView setUserInteractionEnabled:FALSE];
        _tagView.alpha = 0.5;
        [_tagView2 setUserInteractionEnabled:FALSE];
        _tagView2.alpha = 0.5;
        btnSetup.userInteractionEnabled = FALSE;
    }
}

- (void)scanTimeout:(NSTimer*)timer
{
    switch (self.state) {
        case IDLE:
            //NSLog(@"Started scan ...");
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
            //NSLog(@"ReCONNECTING ...");
            break;
        case CONNECTED:
            [self sendCmdToController:GET_FOUND Index:0];
            if (timerCheck == 4) {
                //[self tagCheck];
                timerCheck = 0;
            } else {
                timerCheck++;
            }
            break;
        default:
            break;
    }
    labConnectStatus.text = connectStatusArray[self.state];
}

- (void)tagCheck
{
    if (self.state == CONNECTED) {
        [self sendCmdToController:GET_TAG_COUNT Index:0];
    }
}

- (void)didReadyToGo
{
    [timer invalidate];
    //timer.fireDate = [NSDate dateWithTimeInterval:15 sinceDate:[NSDate date]];
    /*
    [self sendCmdToController:GET_TAG_COUNT Index:0];
    [self sendCmdToController:GET_ENABLE Index:0];
    [self sendCmdToController:GET_MAJOR Index:0];
    [self sendCmdToController:GET_MINOR Index:0];
    [self sendCmdToController:GET_MFG_DATA Index:0];
    [self sendCmdToController:GET_FOUND Index:0];
    */
    [self sendCmdToController:GET_SCAN_INTERVAL Index:0];
    [self sendCmdToController:GET_SCAN_TIMEOUT Index:0];
    [self sendCmdToController:GET_NOTIFICATION Index:0];
    //[self sendCmdToController:GET_FOUND Index:0];
    
    [_tagView setUserInteractionEnabled:TRUE];
    _tagView.alpha = 1.0;
    [_tagView2 setUserInteractionEnabled:TRUE];
    _tagView2.alpha = 1.0;
    btnSetup.userInteractionEnabled = TRUE;
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveData:(NSString *)string
{
    NSRange searchResult;
    NSString *tmp;
    unsigned long lonTmp;
    tagRemote *tagTmp;
    
    
    if (string == NULL) {
        //[self sendCmdToController:targetCmd Index:0];
        return;
    }
    
    searchResult = [string rangeOfString:@"MISSING"];
    if (searchResult.location != NSNotFound) {
        if (tagNotify == 0) {
            [self sendCmdToController:GET_FOUND Index:0];
            tagNotify = 9;
            NSLog(@"===%@===", string);
        }
        tagNotify--;
        return;
    }
    NSLog(@"===%@===", string);
    
    if ([string rangeOfString:@"*GFN-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        tagTmp = _tagArray[tagResp];
        tagTmp.found = [tmp integerValue];
        tagResp++;
        if (tagResp == MAX_TAGS) {
            [self reNewButtonStatus];
            tagResp = 0;
        }
    } else if ([string rangeOfString:@"*GMA-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    } else if ([string rangeOfString:@"*GMI-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    } else if ([string rangeOfString:@"*GMF-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    } else if ([string rangeOfString:@"*GTC-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 3)];
        NSInteger num = [tmp integerValue];
        if (_tagCount != num) {
            //[self setAllTagToController];
        }
    } else if ([string rangeOfString:@"*GEN-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    } else if ([string rangeOfString:@"*GSI-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 3)];
        _tagControll.interval = [tmp integerValue];
    } else if ([string rangeOfString:@"*GST-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 3)];
        _tagControll.timeout = [tmp integerValue];
    } else if ([string rangeOfString:@"*GNE-"].location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        _tagControll.NotifyEnable = [tmp integerValue];
    } else if ([string rangeOfString:@"*STS-"].location != NSNotFound) {
        searchResult = [string rangeOfString:@"OK"];
        if (searchResult.location == NSNotFound) {
            //[self sendCmdToController:targetCmd Index:0];
        }
    }
}

- (void)setAllTagToController
{
    for (tagRemote *tmp in _tagArray) {
        if (tmp.index != 0) {
            [self sendCmdToController:SET_MFG_ID Index:tmp.index];
            [self sendCmdToController:SET_MAJOR Index:tmp.index];
            [self sendCmdToController:SET_MINOR Index:tmp.index];
            [self sendCmdToController:SET_ENABLE Index:tmp.index];
        }
    }
}

- (void)sendCmdToController: (NSInteger)command Index:(NSUInteger)index
{
    NSString    *tmp1, *tmp2;
    tagRemote   *tagTmp;
    
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
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04lX", (unsigned long)tagTmp.major];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_MINOR:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04lX", (unsigned long)tagTmp.minor];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_MFG_ID:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04lX", (unsigned long)tagTmp.mfgID];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_ENABLE:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%1ld", (unsigned long)tagTmp.enable];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"X" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_ENABLE_ALL:
        case SET_NOTIFICATION:
            tmp2 = [NSString stringWithFormat: @"%1ld", (unsigned long)index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"X" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_SCAN_INTERVAL:
        case SET_SCAN_TIMEOUT:
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case GET_TAG_COUNT:
        case GET_SCAN_INTERVAL:
        case GET_SCAN_TIMEOUT:
        case GET_NOTIFICATION:
        case GET_BATTERY:
        case GET_SENSITIVITY:
        case SET_SCAN_START:
        case SET_SCAN_STOP:
        case DEL_ALL_TAG:
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_SENSITIVITY:
            break;
        case DEL_TAG:
            tmp2 = [NSString stringWithFormat: @"%03ld", (unsigned long)index + 1];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        default:
            break;
    }
    NSLog(@"%@", tmp1);
    usleep(100000);
    
}

- (void)reNewButtonStatus
{
    [_tagView setAllTagBackground:_tagArray];
}

- (void)addTags
{
    NSString *tmp;
    tagRemote *tagTmp;
    
    for (int i = 0; i < MAX_TAGS; i++) {
        tagTmp = _tagArray[i];
        if (tagTmp.index == 0) continue;

        tmp = [NSString stringWithFormat: @"%@\n            %03lu\n%04lX", tagTmp.name, (unsigned long)tagTmp.index, (unsigned long)tagTmp.minor];
        if (tagTmp.enable == 1) {
            [_tagView addTagToLastWithIndex:tmp index:tagTmp.index];
        } else {
            [_tagView2 addTagToLastWithIndex:tmp index:tagTmp.index];
        }
        _tagCount++;
    }
    if (_tagCount == MAX_TAGS) {
        _tagView.tfInput.hidden = TRUE;
    }
    [self reNewButtonStatus];
    [self saveDataToFile:_tagArray];
}

- (void)tagDidClicked:(NSInteger)index
{
    tagRemote *tagTmp = _tagArray[index-1];
    if (tagTmp.enable) {
        if (tagTmp.found) {
            ActiveInfoView *activeInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveInfoView"];
            activeInfoView.tagRemotes = tagTmp;
            activeInfoView.delegate = self;
            [self presentViewController:activeInfoView animated:YES completion:nil];
        } else {
            MissingInfoView *missingInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"MissingInfoView"];
            missingInfoView.tagRemotes = tagTmp;
            missingInfoView.delegate = self;
            [self presentViewController:missingInfoView animated:YES completion:nil];
        }
    } else {
        InactiveInfoView *inactiveInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"InactiveInfoView"];
        inactiveInfoView.tagRemotes = tagTmp;
        inactiveInfoView.delegate = self;
        [self presentViewController:inactiveInfoView animated:YES completion:nil];
    }
}

- (void)tagDisable:(NSInteger)index
{
    if (self.state != CONNECTED) return;
    
    tagRemote *tagTmp = _tagArray[index];
    
    tagTmp.enable = 0;
    [self sendCmdToController:SET_ENABLE Index:index];
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    _tagCount = 0;
    [self addTags];
}

- (void)tagEnable:(NSInteger)index
{
    if (self.state != CONNECTED) return;
    
    tagRemote *tagTmp = _tagArray[index];
    
    tagTmp.enable = 1;
    [self sendCmdToController:SET_ENABLE Index:index];
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    _tagCount = 0;
    [self addTags];
}

- (void)tagSearch
{
    SearchTagView *searchTagView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTagView"];
    searchTagView.tagArrayOrg = _tagArray;
    [self presentViewController:searchTagView animated:YES completion:nil];
}

- (void)tagAddAfterSearch:(tagRemote *)tagTarget
{
    if (self.state != CONNECTED) return;
    
    NSInteger index = [self checkEmptytags];
    
    tagRemote *tagTmp = [[tagRemote alloc] init];
    tagTmp.enable = 1;
    tagTmp.index = index + 1;
    tagTmp.major = tagTarget.major;
    tagTmp.mfgID = 0x5900;
    tagTmp.minor = tagTarget.minor;
    tagTmp.name = [[NSString alloc] initWithString:tagTarget.name];
    tagTmp.found = 0;
    
    [_tagArray replaceObjectAtIndex:index withObject:tagTmp];
    
    [self sendCmdToController:SET_MFG_ID Index:index];
    [self sendCmdToController:SET_MAJOR Index:index];
    [self sendCmdToController:SET_MINOR Index:index];
    [self sendCmdToController:SET_ENABLE Index:index];
    
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    _tagCount = 0;
    [self addTags];
}

- (void)tagRemove:(NSInteger)index
{
    if (self.state != CONNECTED) return;
    
    tagRemote *tagTmp = _tagArray[index];
    
    NSString *tmp = [NSString stringWithFormat: @"%@\n            %03lu\n%04lX", tagTmp.name,(unsigned long)tagTmp.index, (unsigned long)tagTmp.minor];
    if (tagTmp.enable == 1) {
        [_tagView removeTag:tmp];
    } else {
        [_tagView2 removeTag:tmp];
    }
    
    tagTmp.enable = 0;
    tagTmp.index = 0;
    tagTmp.major = 0;
    tagTmp.mfgID = 0;
    tagTmp.minor = 0;
    tagTmp.found = 0;
    
    [_tagArray replaceObjectAtIndex:index withObject:tagTmp];
    
    [self sendCmdToController:DEL_TAG Index:index];
    _tagCount--;
    if (_tagCount < MAX_TAGS) {
        _tagView.tfInput.hidden = FALSE;
    }
    [self saveDataToFile:_tagArray];
}

- (void)tagRename:(NSInteger)index
{
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    _tagCount = 0;
    [self addTags];
}

- (NSInteger)checkEmptytags
{
    tagRemote *tagTmp;
    
    for (int i = 0; i < MAX_TAGS; i++) {
        tagTmp = _tagArray[i];
  
        if ((tagTmp.index == 0) && (tagTmp.mfgID == 0)) {
            return i;
        }
    }
    
    return -1;
}

- (IBAction)BTNSetupClick:(UIButton *)sender
{
    SetupSettingsView *setupSettingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SetupSettingsView"];
    setupSettingsView.delegate = self;
    setupSettingsView.tagControll = [[tagController alloc] init];
    setupSettingsView.tagControll.interval = _tagControll.interval;
    setupSettingsView.tagControll.timeout = _tagControll.timeout;
    setupSettingsView.tagControll.NotifyEnable = _tagControll.NotifyEnable;
    [self presentViewController:setupSettingsView animated:YES completion:nil];
}

- (void)setController:(NSInteger)interval timeout:(NSInteger)timeout notify:(NSInteger)notify
{
    if (self.state != CONNECTED) return;
    _tagControll.interval = interval;
    _tagControll.timeout = timeout;
    _tagControll.NotifyEnable = notify;
    
    [self sendCmdToController:SET_SCAN_INTERVAL Index:interval];
    [self sendCmdToController:SET_SCAN_TIMEOUT Index:timeout];
    [self sendCmdToController:SET_NOTIFICATION Index:notify];
}

- (void)saveDataToFile:(NSArray *)tagArray
{
    NSString *filePath = [self filePathOfDocument:KADDataPlist];
    [NSKeyedArchiver archiveRootObject:tagArray toFile:filePath];
}

- (NSMutableArray *)loadDataFromFile
{
    NSMutableArray *arrayTmp;
    tagRemote *tagTmp;
    
    NSString *filePath = [self filePathOfDocument:KADDataPlist];
    arrayTmp = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (arrayTmp == nil) {
        arrayTmp = [[NSMutableArray alloc]init];
        for (int i = 0; i < MAX_TAGS; ++i) {
            tagTmp = [[tagRemote alloc] init];
            [arrayTmp addObject:tagTmp];
        }
    } else {
        for (int i = 0; i < MAX_TAGS; ++i) {
            tagTmp = arrayTmp[i];
            tagTmp.found = 0;
        }
    }
    return arrayTmp;
}

- (NSString *)filePathOfDocument:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:filename];
}

@end
