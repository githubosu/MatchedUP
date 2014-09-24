//
//  MatchViewController.h
//  MatchedUP
//
//  Created by Thanh Trinh on 9/21/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MatchViewControllerDelegate <NSObject>

-(void)presentMatchesViewcontroller;

@end
@interface MatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;
@property (weak) id <MatchViewControllerDelegate> delegate;



@end
