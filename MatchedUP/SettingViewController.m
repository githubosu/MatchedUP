//
//  SettingViewController.m
//  MatchedUP
//
//  Created by Thanh Trinh on 9/21/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import "SettingViewController.h"
#import "Constants.h"
#import "MatchedUP-Prefix.pch"

@interface SettingViewController ()

@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UILabel *agelabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMenEnableKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kWomenEnableKey];
    self.singleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kSingleEnableKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.agelabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
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



#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
    
}

#pragma mark - Helper

- (void)valueChanged:(id)sender
{
    if (sender == self.ageSlider) {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.ageSlider.value forKey:kAgeMaxKey];
        self.agelabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
    }
    else if (sender == self.menSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMenEnableKey];
        
    }
    else if (sender == self.womenSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kWomenEnableKey];
        
    }
    else if (sender == self.singleSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.singleSwitch forKey:kSingleEnableKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}





@end
