//
//  LoginViewController.m
//  ToDoList
//
//  Created by Khiet Ly on 27/9/18.
//  Copyright © 2018 Khiet Ly. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;
@interface LoginViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *email;
    @property (weak, nonatomic) IBOutlet UITextField *password;
    @property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

@end

@implementation LoginViewController
    -(BOOL)validation{
        NSString *strEmailID = [_email.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        NSString *strPassword = [_password.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
        
        if (strEmailID.length <= 0){
            [self.notificationLabel setText: @"Please enter email address"];
            return NO;
        }
        else if (strPassword.length <= 0){
            [self.notificationLabel setText: @"Please enter password"];
            return NO;
        }
        else if ([self validateEmailAddress:strEmailID] == NO){
            [self.notificationLabel setText: @"Please enter valid email address"];
            return NO;
        }
        return YES;
    }
    -(BOOL)validateEmailAddress:(NSString *)checkString
    {
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }
- (IBAction)LoginButton:(id)sender {
   if ([self validation]) {
        [[FIRAuth auth] signInWithEmail:_email.text
                               password:_password.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 //failed
                                 if (error){
                                     [self.notificationLabel setText:error.localizedDescription];
                                     NSLog(@"Error %@", error.localizedDescription);
                                     
                                     
                                 } else {
                                     NSLog(@"User %@", authResult.user);
                                     
                                     //login successfully change page
                                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainView"];
                                     [self presentViewController:vc animated:YES completion:nil];
                                 }
                             }];
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
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

@end
