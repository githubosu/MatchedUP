//
//  Constants.m
//  MatchedUP
//
//  Created by Thanh Trinh on 9/20/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - User Class

NSString *const  kUserTagLineKey                = @"tagLine";
NSString *const  kUserProfileKey                = @"profile";
NSString *const  kUserProfileNameKey            = @"name";
NSString *const  kUserProfileFirstNameKey       = @"firstName";
NSString *const  kUserProfileLocationKey        = @"location";
NSString *const  kUserProfileGenderKey          = @"gender";
NSString *const  kUserProfileBirthdayKey        = @"birthday";
NSString *const  kUserProfileInterestedInKey    = @"interestedIn";
NSString *const  kUserProfilePictureURL         = @"pictureURL";
NSString *const  kUserProfileAgeKey             = @"age";
NSString *const  kUserProfileRelationshipStatusKey = @"relationshipStatus";

#pragma mark - Photo Class

NSString *const kPhotoClassKey                  = @"Photo";
NSString *const kPhotoUserKey                   = @"user";
NSString *const kPhotoPictureKey                = @"image";

#pragma mark - Actvity Class

NSString *const  kActivityClassKey              = @"Activity";
NSString *const  kActivityTypeKey               = @"type";
NSString *const  kActivityFromUserKey           = @"fromUser";
NSString *const  kActivityToUserKey             = @"toUser";
NSString *const  kActivityPhotoKey              = @"photo";
NSString *const  kActivityTypeLikeKey           = @"like";
NSString *const  kActivityTypeDislikeKey        = @"dislike";


#pragma mark - Settings

NSString *const  kMenEnableKey                  = @"men";
NSString *const  kWomenEnableKey                = @"women";
NSString *const  kSingleEnableKey               = @"single";
NSString *const  kAgeMaxKey                     = @"ageMax";

@end
