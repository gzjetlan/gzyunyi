//
//  LoginViewController.h
//  yunyi
//
//  Created by 梁庆杰 on 15/4/20.
//  Copyright (c) 2015年 梁庆杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"


@interface LoginViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property(strong,nonatomic) UINavigationController *mainvc;
@property (strong, nonatomic) IBOutlet UILabel *usernameLB;
@property (strong, nonatomic) IBOutlet UILabel *passwordLB;
@property (nonatomic, strong) NSMutableArray *resultArray;

- (IBAction)Login:(id)sender;
-(void)savelocalData:(User *) user ;
-(void)loadlocalData;

@end
