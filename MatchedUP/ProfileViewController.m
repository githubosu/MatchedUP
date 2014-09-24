//
//  ProfileViewController.m
//  MatchedUP
//
//  Created by Thanh Trinh on 9/21/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statuslabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFFile *picturefile = self.photo[kPhotoPictureKey];
    [picturefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
        
    }];
    
    PFUser *user = self.photo[kPhotoUserKey];
    self.locationLabel.text = user[kUserProfileKey][kUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kUserProfileKey][kUserProfileAgeKey]];
    self.statuslabel.text = user[kUserProfileKey][kUserProfileRelationshipStatusKey];
    self.tagLineLabel.text = user[kUserTagLineKey];
    
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
