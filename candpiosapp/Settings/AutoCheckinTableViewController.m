//
//  AutoCheckinTableViewController.m
//  candpiosapp
//
//  Created by Emmanuel Crouvisier on 5/8/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "AutoCheckinTableViewController.h"
#import "CPVenue.h"
#import "AutoCheckinCell.h"
#import "FlurryAnalytics.h"

@interface AutoCheckinTableViewController ()
@property (nonatomic, strong) NSMutableArray *placesArray;
@end

@implementation AutoCheckinTableViewController

@synthesize globalCheckinSwitch = _globalCheckinSwitch;
@synthesize placesArray = _placesArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // If automaticCheckins is disabled, hide the table view unless changed
    BOOL automaticCheckins = [CPUserDefaultsHandler automaticCheckins];
        
    self.globalCheckinSwitch.on = automaticCheckins;

    if (automaticCheckins) {    
        [self setupPlacesArray];
    }
}

- (void)viewDidUnload
{
    [self setGlobalCheckinSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setupPlacesArray {
    if (!self.placesArray) {
        self.placesArray = [[NSMutableArray alloc] init];
    }
    
    NSArray *pastVenues = [CPUserDefaultsHandler pastVenues];
    
    for (NSData *encodedObject in pastVenues) {
        CPVenue *venue = (CPVenue *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        
        if (venue && venue.name) {
            [self.placesArray addObject:venue];
        }
    }
   
    NSArray *sortedArray;
    
    sortedArray = [self.placesArray sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [(CPVenue *)a name];
        NSString *second = [(CPVenue *)b name];
        return [first compare:second];
    }];
    
    self.placesArray = [sortedArray mutableCopy];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
//{
//    // create the parent view that will hold header Label
//	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)];
//	
//	// create the button object
//	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//	headerLabel.backgroundColor = tableView.backgroundColor;
//	headerLabel.opaque = YES;
//	headerLabel.textColor = [UIColor whiteColor];
//	headerLabel.font = [UIFont boldSystemFontOfSize:14];
//	headerLabel.frame = CGRectMake(20.0, 0.0, self.view.bounds.size.width - 40, 44.0);
//    
//	headerLabel.text = @"Choose the venues:";
//	[customView addSubview:headerLabel];
//    
//	return customView;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return 44.0;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.placesArray.count > 0) {
        return 1;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.placesArray.count > 0) {
        return self.placesArray.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AutoCheckinCell";
    AutoCheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    CPVenue *venue = [self.placesArray objectAtIndex:indexPath.row];
    
    if (venue) {
        cell.venueName.text = venue.name;
        cell.venueAddress.text = venue.address;
        cell.venue = venue;
        
        cell.venueSwitch.on = venue.autoCheckin;
    }
    
    return cell;
}

- (IBAction)globalCheckinChanged:(UISwitch *)sender {
    // Store the choice in NSUserDefaults
    [CPUserDefaultsHandler setAutomaticCheckins:sender.on];
    
    if (!sender.on) {
        // Disable auto checkins
        
        for (CPVenue *venue in self.placesArray) {
            [CPAppDelegate stopMonitoringVenue:venue];
        }
        
        [self.placesArray removeAllObjects];

        // Clear out all currently monitored regions in order to stop using geofencing altogether
        for (CLRegion *reg in [[CPAppDelegate locationManager] monitoredRegions]) {
            [[CPAppDelegate locationManager] stopMonitoringForRegion:reg];
        }
        
        [FlurryAnalytics logEvent:@"automaticCheckinsDisabled"];
    }
    else {
        [self setupPlacesArray];
        
        // Iterate over all past venues to start monitoring those with autoCheckin enabled        
        for (CPVenue *venue in self.placesArray) {
            NSLog(@"auto: %i, venue: %@", venue.autoCheckin, venue.name);
            if (venue.autoCheckin) {
                [CPAppDelegate startMonitoringVenue:venue];
            }
        }

        [FlurryAnalytics logEvent:@"automaticCheckinsEnabled"];
    }
    
    [self.tableView reloadData];
}

@end
