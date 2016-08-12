//
//  SearchTagView.m
//  Embrace
//
//  Created by Versaiah Fang on 8/11/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "SearchTagView.h"

@interface SearchTagView ()

@end

@implementation SearchTagView

NSTimer *timerSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    timerSearch = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sg = screenSize.height / 2208;
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGSearch"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(BTNBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(5, 2, 180 * sg, 180 * sg);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"ImageBTNLeftArrow"] forState:UIControlStateNormal];
    [btnBack setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnBack];
    
    NSString *strSearch = @"Looking for tags...";
    
    UILabel *labSearch = [[UILabel alloc] initWithFrame:CGRectMake(85, 95, 200, 30)];
    [labSearch setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labSearch.text = strSearch;
    [self.view addSubview:labSearch];
    /*
    NSString *strFound = @"Tags found:";
    
    UILabel *labFound = [[UILabel alloc] initWithFrame:CGRectMake(110, 115, 100, 30)];
    [labFound setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labFound.text = strFound;
    [self.view addSubview:labFound];
    */
    NSString *strSelect = @"Select a Tag to Add";
    
    UILabel *labSelect = [[UILabel alloc] initWithFrame:CGRectMake(90, 200, 200, 30)];
    [labSelect setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labSelect.text = strSelect;
    [self.view addSubview:labSelect];
    
    _tagView = [[EYTagView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + 33,
                                                          self.view.bounds.origin.y + 98,
                                                          self.view.bounds.size.width - 55,
                                                          self.view.bounds.size.height - 100)];
    _tagView.delegate = self;
    _tagView.colorTag = COLORRGB(0xffffff);
    _tagView.colorTagBg = COLORRGB(0x0432FF);
    _tagView.colorTagBgDisconnect = COLORRGB(0x0432FF);
    _tagView.colorTagBgDisable = COLORRGB(0x0432FF);
    _tagView.colorInput = COLORRGB(0x2ab44e);
    _tagView.colorInputBg = COLORRGB(0xffffff);
    _tagView.colorInputPlaceholder = COLORRGB(0x2ab44e);
    _tagView.backgroundColor = COLORRGB(0xffffff);
    _tagView.colorInputBoard = COLORRGB(0x2ab44e);
    _tagView.viewMaxHeight = self.view.bounds.size.height - 100;
    _tagView.type = EYTagView_Type_Edit;
    _tagView.tfInput.hidden = TRUE;
    _tagView.hidden = TRUE;
    
    [_tagView layoutTagviews];
    [self.view addSubview:_tagView];

    
    _tagRemotes = malloc(sizeof(tagRemote) * MAX_TAGS);
    memset(_tagRemotes, 0, sizeof(tagRemote) * MAX_TAGS);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)heightDidChangedTagView:(EYTagView *)tagView
{
    //NSLog(@"heightDidChangedTagView");
}

- (void)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManagerDidUpdateState");
        [timerSearch fire];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSData *advData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
    if (advData != nil) {
        unsigned char *digest = (unsigned char *)[advData bytes];
        NSString *strTmp = [NSString stringWithFormat:@"%02X%02X", digest[0], digest[1]];
        if (strTmp != nil) {
            unsigned long lonTmp = strtoul([strTmp UTF8String],0,16);
            if ((lonTmp == 0x5900) && (_tagCount < MAX_TAGS)) {
                _tagRemotes[_tagCount].mfgID = lonTmp;
                strTmp = [NSString stringWithFormat:@"%02X%02X", digest[20], digest[21]];
                _tagRemotes[_tagCount].major = strtoul([strTmp UTF8String],0,16);
                strTmp = [NSString stringWithFormat:@"%02X%02X", digest[22], digest[23]];
                _tagRemotes[_tagCount].minor = strtoul([strTmp UTF8String],0,16);
                _tagRemotes[_tagCount].index = _tagCount + 1;
                _tagCount++;
            }
        }
    }
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
        if (timerSearch.isValid == NO) {
            timerSearch = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanTimeout:) userInfo:nil repeats:YES];
            [timerSearch fire];
        }
    }
}

- (void)scanTimeout:(NSTimer*)timer
{
    switch (self.state) {
        case IDLE:
            [self.cm scanForPeripheralsWithServices:nil options:nil];
            self.state = SCANNING;
            break;
        case SCANNING:
            self.state = IDLE;
            [self.cm stopScan];
            [timer invalidate];
            [self addTags];
        default:
            break;
    }
}

- (void)didReceiveData:(NSString *)string
{
    NSLog(@"===%@===", string);
}

- (void)addTags
{
    NSString *tmp;
    
    for (int i = 0; i < _tagCount; i++) {
        tmp = [NSString stringWithFormat: @"New\n                \n%04lX", _tagRemotes[i].minor];
        [_tagView addTagToLastWithIndex:tmp index:_tagRemotes[i].index];
    }
     _tagView.hidden = FALSE;
}

- (void)tagDidClicked:(NSInteger)index
{
    [self.delegate tagAddAfterSearch:&_tagRemotes[index-1]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
