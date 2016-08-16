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
NSInteger   tagNotify;
NSInteger   tagResp;
NSInteger   targetCmd;
NSInteger   sendCmdStatus;
NSTimer     *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                                            @"*SEA-X#",
                                            @"*SSI-XX#",
                                            @"*SST-XXX#",
                                            @"*SSS#",
                                            @"*STS#",
                                            @"*SSY-XXX#",
                                            @"*SNE-X#",
                                            @"*DET-YYY#",
                                            nil];

    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGMain"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    _tagView = [[EYTagView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + 33,
                                                          self.view.bounds.origin.y + 98,
                                                          self.view.bounds.size.width - 55,
                                                          self.view.bounds.size.height - 100)];
    _tagView.delegate = self;
    _tagView.colorTag = COLORRGB(0xffffff);
    _tagView.colorTagBg = COLORRGB(0x007000);
    _tagView.colorTagBgDisable = COLORRGB(0x848484);
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
    _tagView2.colorTagBgDisconnect = COLORRGB(0x848484);
    _tagView2.colorInput = COLORRGB(0x2ab44e);
    _tagView2.colorInputBg = COLORRGB(0xffffff);
    _tagView2.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView2.backgroundColor = COLORRGB(0xffffff);
    _tagView2.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView2.viewMaxHeight = self.view.bounds.size.height - 100;
    _tagView2.type = EYTagView_Type_Edit_Only_Delete;
    
    [_tagView2 layoutTagviews];
    [self.view addSubview:_tagView2];
    
    _tagArray = [self loadDataFromFile];
    if (_tagArray != nil) {
        [self addTags];
    }
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
    [self sendCmdToController:GET_TAG_COUNT Index:0];
    [self sendCmdToController:GET_ENABLE Index:0];
    [self sendCmdToController:GET_MAJOR Index:0];
    [self sendCmdToController:GET_MINOR Index:0];
    [self sendCmdToController:GET_MFG_DATA Index:0];
    [self sendCmdToController:GET_FOUND Index:0];
}

- (void)didReceiveData:(NSString *)string
{
    NSRange searchResult;
    NSString *tmp;
    unsigned long lonTmp;
    tagRemote *tagTmp;
    
    NSLog(@"===%@===", string);
    if (string == NULL) {
        //[self sendCmdToController:targetCmd Index:0];
        return;
    }
    
    searchResult = [string rangeOfString:@"MISSING"];
    if (searchResult.location != NSNotFound) {
        if (tagNotify == 0) {
            [self sendCmdToController:GET_FOUND Index:0];
            tagNotify = 9;
        }
        tagNotify--;
    }
    
    searchResult = [string rangeOfString:@"*GFN-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        tagTmp = _tagArray[tagResp];
        tagTmp.found = [tmp integerValue];
        tagResp++;
        if (tagResp == MAX_TAGS) {
            [self reNewButtonStatus];
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GMA-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        //_tagRemotes[tagResp].major = lonTmp;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GMI-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        //_tagRemotes[tagResp].minor = lonTmp;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            //[self reNewButtonStatus];
            tagResp = 0;
            //[_tagView removeAllTags];
            //[_tagView2 removeAllTags];
            //[self addTags];
        }
    }
    
    searchResult = [string rangeOfString:@"*GMF-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 4)];
        lonTmp = strtoul([tmp UTF8String],0,16);
        //_tagRemotes[tagResp].mfgID = lonTmp;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*GEN-"];
    if (searchResult.location != NSNotFound) {
        tmp = [string substringWithRange:NSMakeRange(5, 1)];
        //_tagRemotes[tagResp].enable = [tmp integerValue];
        //_tagRemotes[tagResp].index = tagResp + 1;
        tagResp++;
        if (tagResp == MAX_TAGS) {
            tagResp = 0;
        }
    }
    
    searchResult = [string rangeOfString:@"*STS-"];
    if (searchResult.location != NSNotFound) {
        searchResult = [string rangeOfString:@"OK"];
        if (searchResult.location == NSNotFound) {
            //[self sendCmdToController:targetCmd Index:0];
        }
    }
}

- (void)sendCmdToController: (NSInteger)command Index:(NSInteger)index
{
    NSString *tmp1, *tmp2;
    tagRemote *tagTmp;
    
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
            tmp2 = [NSString stringWithFormat: @"%03d", tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04X", tagTmp.major];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_MINOR:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03d", tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04X", tagTmp.minor];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_MFG_ID:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03d", tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%04X", tagTmp.mfgID];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"XXXX" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_ENABLE:
            tagTmp =  _tagArray[index];
            tmp2 = [NSString stringWithFormat: @"%03d", tagTmp.index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            tmp2 = [NSString stringWithFormat: @"%1d", tagTmp.enable];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"X" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case SET_ENABLE_ALL:
            tmp2 = [NSString stringWithFormat: @"%1d", index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"X" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
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
        case DEL_TAG:
            tmp2 = [NSString stringWithFormat: @"%03d", index];
            tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"YYY" withString:tmp2];
            [self.currentPeripheral writeString:tmp1];
            break;
        case DEL_ALL_TAG:
            break;
            
        default:
            break;
    }
    NSLog(@"%@", tmp1);
    usleep(10000);
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

        tmp = [NSString stringWithFormat: @"%@\n            %03d\n%04X", tagTmp.name, tagTmp.index, tagTmp.minor];
        if (tagTmp.enable == 1) {
            [_tagView addTagToLastWithIndex:tmp index:tagTmp.index];
        } else {
            [_tagView2 addTagToLastWithIndex:tmp index:tagTmp.index];
        }
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
    tagRemote *tagTmp = _tagArray[index-1];
    
    tagTmp.enable = 0;
    [self sendCmdToController:SET_ENABLE Index:index-1];
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    [self addTags];
}

- (void)tagEnable:(NSInteger)index
{
    tagRemote *tagTmp = _tagArray[index-1];
    
    tagTmp.enable = 1;
    [self sendCmdToController:SET_ENABLE Index:index-1];
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    [self addTags];
}

- (void)tagSearch
{
    SearchTagView *searchTagView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTagView"];
    searchTagView.delegate = self;
    [self presentViewController:searchTagView animated:YES completion:nil];
}

- (void)tagAddAfterSearch:(tagRemote *)tagTarget
{
    NSInteger index = [self checkEmptytags];
    
    tagRemote *tagTmp = [[tagRemote alloc] init];
    tagTmp.enable = 1;
    tagTmp.index = index + 1;
    tagTmp.major = tagTarget.major;
    tagTmp.mfgID = 0x5900;
    tagTmp.minor = tagTarget.minor;
    tagTmp.name = [[NSString alloc] initWithString:tagTarget.name];
    tagTmp.found = 0;
    _tagCount++;
    
    [_tagArray replaceObjectAtIndex:index withObject:tagTmp];
    
    [self sendCmdToController:SET_MFG_ID Index:index];
    [self sendCmdToController:SET_MAJOR Index:index];
    [self sendCmdToController:SET_MINOR Index:index];
    [self sendCmdToController:SET_ENABLE Index:index];
    
    [_tagView removeAllTags];
    [_tagView2 removeAllTags];
    [self addTags];
}

- (void)tagRemove:(NSInteger)index
{
    NSString *tmp;
    
    tagRemote *tagTmp = _tagArray[index-1];
    
    tmp = [NSString stringWithFormat: @"%@\n            %03d\n%04X", tagTmp.name,tagTmp.index, tagTmp.minor];
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
    
    [_tagArray replaceObjectAtIndex:index-1 withObject:tagTmp];
    
    [self sendCmdToController:DEL_TAG Index:index-1];
    _tagCount--;
    if (_tagCount < MAX_TAGS) {
        _tagView.tfInput.hidden = FALSE;
    }
    [self saveDataToFile:_tagArray];
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
