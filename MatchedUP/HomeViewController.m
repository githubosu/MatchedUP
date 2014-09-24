//
//  HomeViewController.m
//  MatchedUP
//
//  Created by Thanh Trinh on 9/21/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import "HomeViewController.h"
#import "MatchedUP-Prefix.pch"
#import "TestUser.h"
#import "ProfileViewController.h"
#import "MatchViewController.h"

@interface HomeViewController () <MatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;


@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[TestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    }
    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"]){
        MatchViewController *matchVC = segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.delegate = self;
    }
    
}


#pragma mark - IBActions

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
}
- (IBAction)settingBarbuttonItemPressed:(UIBarButtonItem *)sender
{
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}


#pragma mark - Helper Methods

-(void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"%@", error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForLike whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
        [queryForLike whereKey:kActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForDislike whereKey:kActivityTypeKey equalTo:kActivityTypeDislikeKey];
        [queryForDislike whereKey:kActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.activities = [objects mutableCopy];
                
                if ([self.activities count] == 0) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                }
                else {
                    PFObject *activity = self.activities[0];
                    
                    if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeLikeKey]) {
                        self.isDislikedByCurrentUser = NO;
                        self.isLikedByCurrentUser = YES;
                    }
                    else if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeDislikeKey]) {
                        self.isDislikedByCurrentUser = YES;
                        self.isLikedByCurrentUser = NO;
                    }
                    else {
                        //Some other type of activity
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
                self.infoButton.enabled = YES;
            }
        }];
                                        
    }
}

-(void)updateView
{
    self.firstNameLabel.text = self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat: @"%@", self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kUserProfileKey][kUserTagLineKey];
}

-(void)setUpNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check Back Later for More People@" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeLikeKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.isLikedByCurrentUser = YES;
            self.isDislikedByCurrentUser = NO;
            [self.activities addObject:likeActivity];
            [self checkForPhotoUserLikes];
            [self setUpNextPhoto];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [dislikeActivity setObject:kActivityTypeDislikeKey forKey:kActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.isLikedByCurrentUser = NO;
            self.isDislikedByCurrentUser = YES;
            [self.activities addObject:dislikeActivity];
            [self setUpNextPhoto];
        }
        else {
            NSLog(@"%@",error);
        }
    }];
}

-(void)checkLike
{
    if (self.isLikedByCurrentUser) {
        [self setUpNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities){
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
    }
}

-(void)checkDislike
{
    if (self.isDislikedByCurrentUser) {
        [self setUpNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
    }
}

- (void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityFromUserKey containedIn:self.photo[kPhotoUserKey]];
    [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityTypeLikeKey equalTo:kActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom
{
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[kPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.photo[kPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[kPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
}


#pragma mark - MatchViewController Delegate

- (void) presentMatchesViewcontroller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}












@end
