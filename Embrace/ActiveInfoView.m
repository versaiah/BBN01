//
//  ActiveInfoView.m
//  Embrace
//
//  Created by Versaiah Fang on 8/9/16.
//  Copyright © 2016 Versaiah Fang. All rights reserved.
//

#import "ActiveInfoView.h"

@interface ActiveInfoView ()

@end

@implementation ActiveInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat sg = screenSize.height / 2208;
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageBGActive"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(BTNBackClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(5, 2, 180 * sg, 180 * sg);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"ImageBTNLeftArrow"] forState:UIControlStateNormal];
    [btnBack setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnBack];
    
    NSString *strTitle = [NSString stringWithFormat: @"TAG %03d  -  %@", _tagRemotes.index, [_tagRemotes.name uppercaseString]];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 300, 40)];
    [labTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labTitle.textColor = [UIColor whiteColor];
    labTitle.text = strTitle;
    [self.view addSubview:labTitle];
    
    NSString *strName = [NSString stringWithFormat: @"Name : %@", _tagRemotes.name];
    
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, 300, 40)];
    [labName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labName.text = strName;
    [self.view addSubview:labName];
    
    NSString *strActive = [NSString stringWithFormat: @"Active : Yes"];
    
    UILabel *labActive = [[UILabel alloc] initWithFrame:CGRectMake(35, 125, 300, 40)];
    [labActive setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];    labActive.text = strActive;
    [self.view addSubview:labActive];
    
    NSString *strStatus = [NSString stringWithFormat: @"Status : OK"];
    
    UILabel *labStatus = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, 300, 40)];
    [labStatus setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    labStatus.text = strStatus;
    [self.view addSubview:labStatus];
    
    UIButton *btnRename = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRename addTarget:self action:@selector(BtnRenameClick:) forControlEvents:UIControlEventTouchUpInside];
    btnRename.frame = CGRectMake(30, 190, 400 * sg, 150 * sg);
    btnRename.backgroundColor = COLORRGB(0x030303);
    [btnRename setTitle:@"RENAME" forState:UIControlStateNormal];
    [btnRename setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnRename];
    
    UIButton *btnDisable = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDisable addTarget:self action:@selector(BtnDisableClick:) forControlEvents:UIControlEventTouchUpInside];
    btnDisable.frame = CGRectMake(btnRename.frame.origin.x + btnRename.frame.size.width + 5, 190, 400 * sg, 150 * sg);
    btnDisable.backgroundColor = COLORRGB(0x6D6D6D);
    [btnDisable setTitle:@"DISABLE" forState:UIControlStateNormal];
    [btnDisable setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnDisable];
    
    UIButton *btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRemove addTarget:self action:@selector(BtnRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    btnRemove.frame = CGRectMake(btnDisable.frame.origin.x + btnDisable.frame.size.width + 5, 190, 400 * sg, 150 * sg);
    btnRemove.backgroundColor = COLORRGB(0x390203);
    [btnRemove setTitle:@"REMOVE" forState:UIControlStateNormal];
    [btnRemove setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:btnRemove];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BTNBackClick:(UIButton *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)BtnRenameClick:(UIButton *)sender
{
  
}

- (void)BtnDisableClick:(UIButton *)sender
{
    [self.delegate tagDisable:_tagRemotes.index];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)BtnRemoveClick:(UIButton *)sender
{
    [self.delegate tagRemove:_tagRemotes.index];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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
