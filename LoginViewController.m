//
//  LoginViewController.m
//  yunyi
//
//  Created by 梁庆杰 on 15/4/20.
//  Copyright (c) 2015年 梁庆杰. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "MainAppViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "IQKeyboardManager.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "User.h"




@interface LoginViewController ()<ASIHTTPRequestDelegate>

@end

@implementation LoginViewController{
    MBProgressHUD *HUD;
    NSString *reqURL;
}

-(User *)loadlocalData{
    User *u = [[User alloc] init];
    
    //1)获取托管对象上下文（相当于数据库操作）
    NSManagedObjectContext *context = [appDelegate managedObjectContext];//备注3
    //2)创建NSFetchRequest对象（相当于数据库中的SQL语句）
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //3)创建查询实体（相当于数据库中要查询的表）
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    //设置查询实体
    [request setEntity:entityDescription];
    /*
    //4)创建排序描述符,ascending：是否升序（相当于数据库中排序设置）。此处仅为演示，本实例不需要排序
    NSSortDescriptor *sortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO];
    NSArray *sortDiscriptos = [[NSArray alloc] initWithObjects:sortDiscriptor, nil];
    [request setSortDescriptors:sortDiscriptos];
    //5)创建查询谓词（相当于数据库中查询条件） 此处仅为演示，本实例不需要查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(serverIp like %@)",@"192"];
    [request setPredicate:pred];
     */
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects == nil){
        NSLog(@"There has a error!");
        //做错误处理
    }else{
        if([objects count]>0){
            NSManagedObject *oneObject = [objects objectAtIndex:0];
            
            u.nickname=[oneObject valueForKey:@"nickname"];
            u.realname=[oneObject valueForKey:@"realname"];
            u.userid=[oneObject valueForKey:@"userid"];
            
            NSLog([oneObject valueForKey:@"realname"]);
            NSLog([oneObject valueForKey:@"nickname"]);
            NSLog([oneObject valueForKey:@"userid"]);
            
                 }
    }
    return  u;

}

-(void)savelocalData:(User *) User{
    
    //创建托管对象上下文
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSManagedObject *user = nil;
    NSError *error;
    NSArray *objets = [context executeFetchRequest:request error:&error];
    if(objets==nil){
        NSLog(@"There has a error!");
        //做错误处理
    }
    if([objets count]>0){
        //非第一次，更新数据
        NSLog(@"更新操作");
        user = [objets objectAtIndex:0];
    }else{
        NSLog(@"插入操作");
        //第一次保存，插入新数据
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
    [user setValue:User.realname forKeyPath:@"realname"];
    [user setValue:User.nickname forKeyPath:@"nickname"];
    [user setValue:User.userid forKeyPath:@"userid"];
    [context save:&error];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获取App代理
    appDelegate = [[UIApplication sharedApplication] delegate];
    //订阅通知
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
    
   
    
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    [leftVC.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.75, [UIScreen mainScreen].bounds.size.height)];
    [QHSliderViewController sharedSliderController].LeftVC = leftVC;
    RightViewController *rightVC = [[RightViewController alloc] init];
    [QHSliderViewController sharedSliderController].RightVC = rightVC;
    [QHSliderViewController sharedSliderController].finishShowRight = ^()
    {
        [rightVC headPhotoAnimation];
    };
    [QHSliderViewController sharedSliderController].MainVC = [[MainAppViewController alloc] init];
    
    _mainvc = [[UINavigationController alloc] initWithRootViewController:[QHSliderViewController sharedSliderController]];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //	HUD.delegate = self;
    HUD.labelText = @"登录中...";
    
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    
   



}


#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    @try
    {
        //NSLog(request.responseString);
        
        
        
        
    NSDictionary *jsonDict = [request.responseString  JSONValue];
        
        
        NSDictionary *jsonoObj = [request.responseString JSONValue];
        NSDictionary *dateobj=[jsonoObj objectForKey:@"data"];
        NSString *realname=[dateobj objectForKey:@"realname"];
         NSString *nickname=[dateobj objectForKey:@"nickname"];
        NSString *userid=[dateobj objectForKey:@"id"];
        //NSLog(@"realname:%@",realname);
        //NSLog(@"result:%@",[jsonoObj objectForKey:@"result"]);
        NSString* result=[jsonoObj objectForKey:@"result"];
        
        
        User *u =[[User alloc] init];
        u.nickname=nickname;
        u.userid=userid;
        u.realname=realname;
        //[self savelocalData:u];
        [self loadlocalData];
        
        
        //更新时间
        NSString *updateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
        
        
       
        if ([result intValue]==0) {
             [self goToMainView];
        } else {
            UIAlertView * alert =
            [[UIAlertView alloc]
             initWithTitle:@"错误"
             message: [[NSString alloc] initWithFormat:@"帐号或密码错误！"]
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"OK", nil];
            [alert show];

        }
     //   NSLog(@"jsonstr:%@", jsonoObj);
      // NSDictionary *jsonoSubObj = [jsonoObj objectForKey:@"data"];
      //  NSString *realname = [jsonoSubObj objectForKey:@"realname"];
       // NSLog(@"realname:%@", realname );
      
   
   
        
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        UIAlertView * alert =
        [[UIAlertView alloc]
         initWithTitle:@"错误"
         message: [[NSString alloc] initWithFormat:@"%@",e]
         delegate:self
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil];
        [alert show];
       
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.passwordTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Login:(id)sender {
    // MBProgressHUD后台新建子线程执行任务
   // [HUD showWhileExecuting:@selector(loginUser) onTarget:self withObject:nil animated:YES];
    [self loginWithUsername:_usernameTF.text Password:_passwordTF.text];
}

// 子线程中
-(void) loginUser {
    // 显示进度条
    sleep(5);
    
    // 返回主线程执行
   [self  performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
    
    // 返回主线程执行
   // [self  performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
}

// 服务器交互进行用户名，密码认证

-(BOOL)loginWithUsername:(NSString *)username Password:(NSString *)password {
   // movieURL=@"http://yunyi.sudocn.com:91/site/apiuser/auth?nickname=%@&password=%@";
    reqURL=[NSString stringWithFormat:@"%@/site/apiuser/auth?nickname=%@&password=%@", RootUrl ,username,password];
    NSLog(reqURL);
    
    //请求类
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:reqURL]];
    
    //
    request.delegate = self;
    //异步发送请求
    [request startAsynchronous];
    
    return true;
}

-(void) goToMainView {
//[self performSegueWithIdentifier:@"GoToMainViewSegue" sender:self];
    
    [self presentViewController:_mainvc animated:true completion:^{}];
    //从UIViewController返回上一个UIViewController
    //[self dismissViewControllerAnimated:true completion:^{}];
    
    
}


@end
