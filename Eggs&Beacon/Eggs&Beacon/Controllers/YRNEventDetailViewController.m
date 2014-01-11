//
//  YRNEventDetailViewController.m
//  Eggs&Beacon
//
//  Created by Marco on 09/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "YRNEventDetailViewController.h"

@interface YRNEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UITextView *eventTextView;

@end

@implementation YRNEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self eventImageView] setImage:[UIImage imageNamed:[self imageName]]];
    [[self eventTitle] setText:[self eventName]];
    [[self eventTextView] setText:[self eventText]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
