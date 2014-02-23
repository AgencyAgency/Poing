//
//  AASlimTeamTVC.m
//  Poing
//
//  Created by Kyle Oba on 2/23/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AASlimTeamTVC.h"
#import "AAMemberDetail.h"
#import "AASlimPortraitCell.h"
#import "AASlimPortraitVC.h"

@interface AASlimTeamTVC ()
@property (nonatomic, strong) NSArray *bios;
@end

@implementation AASlimTeamTVC

- (NSArray *)bios
{
    if (!_bios) {
        _bios = [AAMemberDetail bios];
    }
    return _bios;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)closeButtonPressed:(UIBarButtonItem *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissSlimTeamVC:)]) {
        [self.delegate didDismissSlimTeamVC:self];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Profile Name Cell";
    AASlimPortraitCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    [self configureCell:cell row:indexPath.row];
    
    return cell;
}

- (void)configureCell:(AASlimPortraitCell *)cell row:(NSUInteger)row
{
    NSString *imageName = [NSString stringWithFormat:@"portrait%lu", (unsigned long)row];
    cell.portraitImageView.image = [UIImage imageNamed:imageName];
    
    cell.portraitLabel.text = [AAMemberDetail nameForBioInBios:self.bios atIndex:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Slim Potrait"]) {
        AASlimPortraitVC *portraitVC = (AASlimPortraitVC *)segue.destinationViewController;
        NSUInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        portraitVC.bioIndex = selectedRow;
    }
}

@end
