//
//  SignupViewController.m
//  ToDoList
//
//  Created by Khiet Ly on 27/9/18.
//  Copyright © 2018 Khiet Ly. All rights reserved.
//

#import "SignupViewController.h"
@import Firebase;
@interface SignupViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *email;
    @property (weak, nonatomic) IBOutlet UITextField *password;
    @property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

@end

@implementation SignupViewController
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
    
    //validating the email address
-(BOOL)validateEmailAddress:(NSString *)checkString
    {
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Signup:(id)sender {
    if ([self validation]) {
        if ([self validation]) {
            [[FIRAuth auth] createUserWithEmail:_email.text password:_password.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion:NULL];
                
                
            }];
        }
    
    
    }
    
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
