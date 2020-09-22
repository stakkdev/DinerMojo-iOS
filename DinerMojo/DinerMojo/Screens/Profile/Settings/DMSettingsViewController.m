//
//  DMSettingsViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMSettingsViewController.h"
#import "DMStartViewController.h"

@interface DMSettingsViewController ()

@end

@implementation DMSettingsViewController
- (IBAction)deleteAccount:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete my account" message:@"You will lose all points, your user profile and will need to create a new account to use DinerMojo." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will permanently delete your account and points." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteUserAccount];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        
        [alertController addAction:ok];
        [alertController addAction:cancel];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    [self.buildLabel setText:[NSString stringWithFormat:@"Build %@ (%@)", version, build]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

}

#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    //Edit profile
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"ShowEditProfile" sender:nil];
    }
    
    //Notifications
    if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"ShowNotificationSettings" sender:nil];
    }
    
    //Change password
    if (indexPath.section == 2)
    {
        [self performSegueWithIdentifier:@"ShowChangePassword" sender:nil];
    }
    
    //Tutorial
    if (indexPath.section == 3)
    {
        //[self performSegueWithIdentifier:@"tutorialSettingsSegue" sender:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DMWelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"welcomeViewController"];
        
        [welcomeViewController setDelegate:self];
        
        [welcomeViewController setWelcomeViewControllerPresentationStyle:DMWelcomeViewControllerPresentationStyleFromPopup];
        
        [welcomeViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:welcomeViewController animated:YES completion:nil];
    }
    
    //Terms
    if (indexPath.section == 4)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dinermojo.com/terms"]];
    }
    
    //Privacy Policy
    if (indexPath.section == 5)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dinermojo.com/privacy"]];
    }
    
    //Logout
    if (indexPath.section == 6)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self logOut];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:logout];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)deleteUserAccount
{
    [self.view.window setUserInteractionEnabled:NO];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setColor:[UIColor blackColor]];
    [indicator setFrame:self.view.frame];
    [indicator setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    [[self userRequest] deleteUserWithCompletionBlock:^(NSError *error, id results) {
        
        if (error)
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"We can't delete your account at this time, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            [self.view.window setUserInteractionEnabled:YES];

        }
        
        else
        {
        
            [self.view.window setUserInteractionEnabled:YES];

            [self logOut];
            
        }
        
        [self.view.window setUserInteractionEnabled:YES];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }];

}

#pragma mark - UITableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    

    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.accessoryView = nil;
    [cell.textLabel setFont:[UIFont settingsTableViewCellFont]];
    [cell.textLabel setTextColor:[UIColor settingsDarkGrayTextColor]];;
    [cell setBackgroundColor:[UIColor settingsLightGrayCellColor]];

    if (indexPath.section == 0)
    {
        [cell.textLabel setText:@"Edit profile"];
    }
    
    if (indexPath.section == 1)
    {
        [cell.textLabel setText:@"Notifications"];
    }
    
    if (indexPath.section == 2)
    {
        [cell.textLabel setText:@"Change password"];
        
    }
    
    if (indexPath.section == 3)
    {
        [cell.textLabel setText:@"Take tour"];
    }
    
    if (indexPath.section == 4)
    {
        [cell.textLabel setText:@"Terms"];
    }
    
    if (indexPath.section == 5)
    {
        [cell.textLabel setText:@"Privacy Policy"];
    }
    
    if (indexPath.section == 6)
    {
        [cell.textLabel setText:@"Logout"];
        cell.backgroundColor = [UIColor settingsDarkGrayCellColor];
        cell.textLabel.textColor = [UIColor whiteColor];

    }
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];

    if (section == 2)
    {
        DMUserRequest *request = [DMUserRequest new];
        if ([[request currentUser] facebook_id].length != 0)
        {
            return 0;
        }
    }
    
    return 7;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        DMUserRequest *request = [DMUserRequest new];
        if ([[request currentUser] facebook_id].length != 0)
        {
            return 0;
        }
    }
    
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

# pragma mark - DMWelcomeViewControllerDelegate

- (void)closeButtonPressedWelcomeViewController:(DMWelcomeViewController *)welcomeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logOut
{
   
    [[self userRequest] logout];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"landingNavigationController"];
    
    [self setRootViewController:destinationViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
