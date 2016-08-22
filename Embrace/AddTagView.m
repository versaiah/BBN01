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
    btnBack.frame = CGRectMake(5, 2, 180*sgw, 180*sgh);
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
    btnTag.frame = CGRectMake(120, 100, 80, 54);
    [btnTag.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btnTag.backgroundColor = COLORRGB(0x0432FF);
    btnTag.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTag.layer.cornerRadius = 3;
    NSString *tmp = [NSString stringWithFormat: @"New\n                \n%04lX", (unsigned long)_tagRemotes.minor];
    [btnTag setTitle:tmp forState:UIControlStateNormal];
    btnTag.enabled = FALSE;
    [self.view addSubview:btnTag];
    
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, 60, 40)];
    [labName setFont: _viewFont];
    labName.text = @"Name :";
    [self.view addSubview:labName];
    
    _tfName = [[NoMenuTextField alloc] initWithFrame:CGRectMake(95, 159, 120, 24)];
    [_tfName setFont: _viewFont];
    _tfName.text = @"New";
    _tfName.delegate = self;
    _tfName.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BTNAddClick:(UIButton *)sender
{
    [_tfName resignFirstResponder];
    if (_tfName.text.length != 0) {
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
    if (range.location >= 16)
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
