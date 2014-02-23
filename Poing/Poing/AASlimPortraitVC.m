//
//  AASlimPortraitVC.m
//  Poing
//
//  Created by Kyle Oba on 2/23/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AASlimPortraitVC.h"
#import "AAMemberDetail.h"

@interface AASlimPortraitVC ()

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end

@implementation AASlimPortraitVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self configureView];
}

- (void)configureView
{
    NSArray *bios = [AAMemberDetail bios];
    self.navigationItem.title = [AAMemberDetail nameForBioInBios:bios
                                                         atIndex:self.bioIndex];
    self.descriptionTextView.text = [AAMemberDetail descriptionForBioInBios:bios
                                                                    atIndex:self.bioIndex];
    
    NSString *imageName = [NSString stringWithFormat:@"portrait%lu", (unsigned long)self.bioIndex];
    self.portraitImageView.image = [UIImage imageNamed:imageName];
}


@end
