//
//  InactiveInfoView.m
//  Embrace
//
//  Created by Versaiah Fang on 8/9/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "InactiveInfoView.h"

@interface InactiveInfoView ()

@end

@implementation InactiveInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sgh = screenSize.height / 2208;
    CGFloat sgw = screenSize.width / 1242;
    _viewFont = [UIFont boldSystemFontOfSize:16];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGInactive"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(BTNBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(30*sgw, 30*sgh, 150*sgw, 150*sgh);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"ImageBTNLeftArrow"] forState:UIControlStateNormal];
    [btnBack setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnBack];
    
    NSString *strTitle = [NSString stringWithFormat: @"TAG %03lu  -  %@", (unsigned long)_tagRemotes.index, [_tagRemotes.name uppercaseString]];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(116*sgw, 350*sgh, 1013*sgw, 60*sgh)];
    [labTitle setFont:_viewFont];
    labTitle.textColor = [UIColor whiteColor];
    labTitle.text = strTitle;
    [self.view addSubview:labTitle];
    
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(139*sgw, 530*sgh, 216*sgw, 60*sgh)];
    [labName setFont:_viewFont];
    labName.text = @"Name :";
    [self.view addSubview:labName];
    
    NSString *strName = [NSString stringWithString:_tagRemotes.name];
    
    _tfName = [[NoMenuTextField alloc] initWithFrame:CGRectMake(355*sgw, 515*sgh, 528*sgw, 100*sgh)];
    [_tfName setFont:[UIFont systemFontOfSize:14]];
    _tfName.text = strName;
    _tfName.delegate = self;
    _tfName.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfName];
    
    NSString *strActive = @"Active :  No";
    
    UILabel *labActive = [[UILabel alloc] initWithFrame:CGRectMake(139*sgw, 650*sgh, 600*sgw, 60*sgh)];
    [labActive setFont:_viewFont];
    labActive.text = strActive;
    [self.view addSubview:labActive];
    
    NSString *strStatus = @"Status :  N/A";
    
    UILabel *labStatus = [[UILabel alloc] initWithFrame:CGRectMake(139*sgw, 770*sgh, 600*sgw, 60*sgh)];
    [labStatus setFont:_viewFont];
    labStatus.text = strStatus;
    [self.view addSubview:labStatus];
    
    UIButton *btnRename = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRename addTarget:self action:@selector(BtnRenameClick:) forControlEvents:UIControlEventTouchUpInside];
    btnRename.frame = CGRectMake(109*sgw, 900*sgh, 332*sgw, 143*sgh);
    btnRename.backgroundColor = COLORRGB(0x030303);
    [btnRename.titleLabel setFont:_viewFont];
    [btnRename setTitle:@"RENAME" forState:UIControlStateNormal];
    [btnRename setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnRename];
    
    UIButton *btnEnable = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEnable addTarget:self action:@selector(BtnEnableClick:) forControlEvents:UIControlEventTouchUpInside];
    btnEnable.frame = CGRectMake(459*sgw, 900*sgh, 332*sgw, 143*sgh);
    btnEnable.backgroundColor = COLORRGB(0x020246);
    [btnEnable.titleLabel setFont:_viewFont];
    [btnEnable setTitle:@"ENABLE" forState:UIControlStateNormal];
    [btnEnable setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnEnable];
    
    UIButton *btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRemove addTarget:self action:@selector(BtnRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    btnRemove.frame = CGRectMake(805*sgw, 900*sgh, 332*sgw, 143*sgh);
    btnRemove.backgroundColor = COLORRGB(0x390203);
    [btnRemove.titleLabel setFont:_viewFont];
    [btnRemove setTitle:@"REMOVE" forState:UIControlStateNormal];
    [btnRemove setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnRemove];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BtnRenameClick:(UIButton *)sender
{
    [_tfName resignFirstResponder];
    if (_tfName.text.length != 0) {
        _tagRemotes.name = _tfName.text;
        [self.delegate tagRename:_tagRemotes.index-1];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        _tfName.text = _tagRemotes.name;
    }
}

- (IBAction)BtnEnableClick:(UIButton *)sender
{
    [self.delegate tagEnable:_tagRemotes.index-1];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BtnRemoveClick:(UIButton *)sender
{
    [self.delegate tagRemove:_tagRemotes.index-1];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12)
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text.length == 0) {
        textField.text = _tagRemotes.name;
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
