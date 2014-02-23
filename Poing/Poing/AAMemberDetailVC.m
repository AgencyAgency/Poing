//
//  AAMemberDetailVC.m
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAMemberDetailVC.h"
#import "AAMemberDetail.h"

@interface AAMemberDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (strong, nonatomic) NSArray *bios;
@end

@implementation AAMemberDetailVC

- (NSArray *)bios
{
    if (!_bios) {
        _bios = [AAMemberDetail bios];
    }
    return _bios;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.nameLabel.text = [AAMemberDetail nameForBioInBios:self.bios
                                                   atIndex:self.memberIndex];
    self.bioTextView.text = [AAMemberDetail descriptionForBioInBios:self.bios
                                                            atIndex:self.memberIndex];
}

@end
