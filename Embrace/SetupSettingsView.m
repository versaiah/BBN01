//
//  SetupSettingsView.m
//  Embrace
//
//  Created by Versaiah Fang on 8/18/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "SetupSettingsView.h"

@interface SetupSettingsView ()

@end

@implementation SetupSettingsView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sgh = screenSize.height / 2208;
    CGFloat sgw = screenSize.width / 1242;
    _viewFont = [UIFont boldSystemFontOfSize:16];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGSettings"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(BTNBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(5, 2, 180*sgw, 180*sgh);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"ImageBTNLeftArrow"] forState:UIControlStateNormal];
    [btnBack setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnBack];
    
    UILabel *labInterval = [[UILabel alloc] initWithFrame:CGRectMake(135*sgw, 540*sgh, 920*sgw, 60*sgh)];
    [labInterval setFont:_viewFont];
    labInterval.text = @"Scan Interval :              seconds";
    [self.view addSubview:labInterval];
    
    UILabel *labTimeout = [[UILabel alloc] initWithFrame:CGRectMake(135*sgw, 650*sgh, 920*sgw, 60*sgh)];
    [labTimeout setFont:_viewFont];
    labTimeout.text = @"Scan Timeout :              seconds";
    [self.view addSubview:labTimeout];
    
    UILabel *labNotify = [[UILabel alloc] initWithFrame:CGRectMake(135*sgw, 760*sgh, 450*sgw, 60*sgh)];
    [labNotify setFont:_viewFont];
    labNotify.text = @"Notifications :";
    [self.view addSubview:labNotify];
    
    _tfInterval = [[NoMenuTextField alloc] initWithFrame:CGRectMake(600*sgw, 535*sgh, 140*sgw, 80*sgh)];
    _tfInterval.keyboardType = UIKeyboardTypeNumberPad;
    [_tfInterval setFont:[UIFont systemFontOfSize:12]];
    _tfInterval.delegate = self;
    _tfInterval.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.interval];
    _tfInterval.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfInterval];
    
    _tfTimeout = [[NoMenuTextField alloc] initWithFrame:CGRectMake(620*sgw, 645*sgh, 140*sgw, 80*sgh)];
    _tfTimeout.keyboardType = UIKeyboardTypeNumberPad;
    [_tfTimeout setFont:[UIFont systemFontOfSize:12]];
    _tfTimeout.delegate = self;
    _tfTimeout.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.timeout];
    _tfTimeout.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfTimeout];
    
    _btnNotifyEnable = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnNotifyEnable addTarget:self action:@selector(BTNNotifyEnableClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnNotifyEnable.frame = CGRectMake(600*sgw, 750*sgh, 250*sgw, 80*sgh);
    _btnNotifyEnable.backgroundColor = COLORRGB(0x040746);
    _btnNotifyEnable.layer.cornerRadius = 3;
    [_btnNotifyEnable.titleLabel setFont:_viewFont];
    [_btnNotifyEnable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_tagControll.NotifyEnable == 1) {
        [_btnNotifyEnable setTitle:@"Enable" forState:UIControlStateNormal];
    } else {
        [_btnNotifyEnable setTitle:@"Disable" forState:UIControlStateNormal];
    }
    
    [_btnNotifyEnable setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:_btnNotifyEnable];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave addTarget:self action:@selector(BTNSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSave.frame = CGRectMake(783*sgw, 920*sgh, 335*sgw, 144*sgh);
    btnSave.backgroundColor = COLORRGB(0x000000);
    btnSave.layer.cornerRadius = 3;
    [btnSave.titleLabel setFont:_viewFont];
    [btnSave setTitle:@"SAVE" forState:UIControlStateNormal];
    [btnSave setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnSave];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BTNSaveClick:(UIButton *)sender
{
    NSString *tmp1, *tmp2;
    BOOL    shouldReturn;
    
    tmp1 = _tfInterval.text;
    tmp2 = _tfTimeout.text;
    shouldReturn = FALSE;
    
    if ((_tfInterval.text.length == 0) || (0 == [tmp1 integerValue])) {
        _tfInterval.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.interval];
        shouldReturn = TRUE;
    }
    if ((_tfTimeout.text.length == 0) || (0 == [tmp2 integerValue])) {
        _tfTimeout.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.timeout];
        shouldReturn = TRUE;
    }
    
    if (shouldReturn == TRUE) return;
    
    _tagControll.interval = [tmp1 integerValue];
    _tagControll.timeout =  [tmp2 integerValue];
    
    tmp1 = [(UIButton *)_btnNotifyEnable currentTitle];
    if ([tmp1 isEqualToString:@"Enable"]) {
        _tagControll.NotifyEnable = 1;
    } else {
        _tagControll.NotifyEnable = 0;
    }
    
    [self.delegate setController:_tagControll.interval timeout:_tagControll.timeout notify:_tagControll.NotifyEnable];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BTNNotifyEnableClick:(UIButton *)sender
{
    NSString *title = [(UIButton *)sender currentTitle];
    if ([title isEqualToString:@"Enable"]) {
        [(UIButton *)sender setTitle:@"Disable" forState:UIControlStateNormal];
    } else {
        [(UIButton *)sender setTitle:@"Enable" forState:UIControlStateNormal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 3)
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (_tfInterval.text.length == 0) {
        _tfTimeout.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.interval];
    } else if (_tfTimeout.text.length == 0) {
        _tfTimeout.text = [NSString stringWithFormat:@"%lu", (unsigned long)_tagControll.timeout];
    }
    
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
