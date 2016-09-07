//
//  AddTagView.m
//  Embrace
//
//  Created by Versaiah Fang on 8/17/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "AddTagView.h"

@interface AddTagView ()

@end

@implementation AddTagView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sgh = screenSize.height / 2208;
    CGFloat sgw = screenSize.width / 1242;
    _viewFont = [UIFont boldSystemFontOfSize:16];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGAddTag"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(BTNBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(30*sgw, 30*sgh, 150*sgw, 150*sgh);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"ImageBTNLeftArrow"] forState:UIControlStateNormal];
    [btnBack setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnBack];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd addTarget:self action:@selector(BTNAddClick:) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.frame = CGRectMake(783*sgw, 920*sgh, 335*sgw, 144*sgh);
    btnAdd.backgroundColor = COLORRGB(0x000000);
    btnAdd.layer.cornerRadius = 3;
    [btnAdd.titleLabel setFont:_viewFont];
    [btnAdd setTitle:@"ADD" forState:UIControlStateNormal];
    [btnAdd setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnAdd];
    
    UIButton *btnTag = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTag.frame = CGRectMake(476*sgw, 502*sgh, 290*sgw, 220*sgh);
    [btnTag.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btnTag.backgroundColor = COLORRGB(0x0432FF);
    btnTag.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTag.layer.cornerRadius = 3;
    NSString *tmp = [NSString stringWithFormat: @"New\n                \n%04lX", (unsigned long)_tagRemotes.minor];
    [btnTag setTitle:tmp forState:UIControlStateNormal];
    btnTag.enabled = FALSE;
    [self.view addSubview:btnTag];
    
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(130*sgw, 790*sgh, 210*sgw, 60*sgh)];
    [labName setFont: _viewFont];
    labName.text = @"Name :";
    [self.view addSubview:labName];
    
    UILabel *labCode = [[UILabel alloc] initWithFrame:CGRectMake(130*sgw, 900*sgh, 210*sgw, 60*sgh)];
    [labCode setFont: _viewFont];
    labCode.text = @"Code :";
    [self.view addSubview:labCode];
    
    _tfName = [[NoMenuTextField alloc] initWithFrame:CGRectMake(360*sgw, 775*sgh, 400*sgw, 100*sgh)];
    [_tfName setFont:[UIFont systemFontOfSize:14]];
    _tfName.text = @"New";
    _tfName.delegate = self;
    _tfName.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfName];
    
    _tfCode = [[NoMenuTextField alloc] initWithFrame:CGRectMake(360*sgw, 885*sgh, 400*sgw, 100*sgh)];
    [_tfCode setFont:[UIFont systemFontOfSize:14]];
    _tfCode.delegate = self;
    _tfCode.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfCode];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tagAuth
{
    if (_tfCode.text.length == 4) {
        NSUInteger tmp;
        NSString *stmp, *strTmp;
        tmp = (_tagRemotes.minor * _tagRemotes.major) ^ _tagRemotes.mfgID;
        tmp = tmp & 0xffff;
        strTmp = [NSString stringWithFormat:@"%lX", (unsigned long)tmp];
        stmp = _tfCode.text;
        if (![strTmp  compare:stmp]) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)BTNAddClick:(UIButton *)sender
{
    [_tfName resignFirstResponder];
    [_tfCode resignFirstResponder];
    if ((_tfName.text.length != 0) && ([self tagAuth])) {
        _tagRemotes.name = _tfName.text;
        ViewController *vc = (ViewController *)self.presentingViewController.presentingViewController;
        [vc tagAddAfterSearch:_tagRemotes];
         [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    } else {
        _tfName.text = _tagRemotes.name;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12)
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_tfName.text.length == 0) {
        _tfName.text = _tagRemotes.name;
    }
    [textField resignFirstResponder];
    return false;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
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
