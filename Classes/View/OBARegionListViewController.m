//
//  OBARegionListViewController.m
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/15/13.
//
//

#import "OBARegionListViewController.h"
#import "OBARegionV2.h"

typedef enum {
	OBASectionTypeNone,
	OBASectionTypeRegions,
	OBASectionTypeNoRegions,
} OBASectionType;


@interface OBARegionListViewController (Private)

- (OBASectionType) sectionTypeForSection:(NSUInteger)section;

- (UITableViewCell*) regionsCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView;
- (UITableViewCell*) noRegionsCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView;

- (void) didSelectActionsRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void) didSelectRegionRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end

@implementation OBARegionListViewController

- (id) initWithApplicationContext:(OBAApplicationContext*)appContext {
	if( self = [super initWithApplicationContext:appContext] ) {
		self.refreshable = FALSE;
		self.showUpdateTime = FALSE;
	}
	return self;
}

-(void) viewDidLoad {
	self.refreshable = FALSE;
	self.showUpdateTime = FALSE;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationItem.title = NSLocalizedString(@"Select Region",@"self.navigationItem.title");
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteNetworkRequest) name:OBAApplicationDidCompleteNetworkRequestNotification object:nil];
	
    _locationTimedOut = FALSE;
	OBALocationManager * lm = _appContext.locationManager;
	[lm addDelegate:self];
	[lm startUpdatingLocation];
    
    _locationTimer = [[NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timeOutLocation) userInfo:(self) repeats:NO] retain];
    [[NSRunLoop mainRunLoop] addTimer:_locationTimer forMode:NSRunLoopCommonModes];
    
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OBAApplicationDidCompleteNetworkRequestNotification object:nil];
    
	[_appContext.locationManager stopUpdatingLocation];
	[_appContext.locationManager removeDelegate:self];
}


- (void)dealloc {
	[_regions release];
    [_mostRecentLocation release];
    if (_locationTimer != nil) {
        [_locationTimer release];
    }
    [super dealloc];
}

- (BOOL) isLoading {
	return _regions == nil || (_mostRecentLocation == nil && !_locationTimedOut);
}

- (id<OBAModelServiceRequest>) handleRefresh {
	return [_appContext.modelService requestRegions:self withContext:nil];
}

- (void) handleData:(id)obj context:(id)context {
    OBAListWithRangeAndReferencesV2 * list = obj;
	_regions = [[NSMutableArray alloc] initWithArray:list.values];
    [self sortRegionsByLocation];
}

- (void) sortRegionsByLocation {
    if (![self isLoading]) {
        [_regions sortUsingComparator:^(id obj1, id obj2) {
            OBARegionV2 *region1 = (OBARegionV2*) obj1;
            OBARegionV2 *region2 = (OBARegionV2*) obj2;
            
            CLLocationDistance distance1 = [region1 distanceFromLocation:_mostRecentLocation];
            CLLocationDistance distance2 = [region2 distanceFromLocation:_mostRecentLocation];
            
            if (distance1 > distance2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if (distance1 < distance2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
        [self.tableView reloadData];
    }
}

- (void) timeOutLocation:(NSTimer*)theTimer {
    _locationTimedOut = TRUE;
    [self sortRegionsByLocation];
}

#pragma mark OBALocationManagerDelegate Methods

- (void) locationManager:(OBALocationManager *)manager didUpdateLocation:(CLLocation *)location {
    OBALocationManager * lm = _appContext.locationManager;
	CLLocation * newLocation = lm.currentLocation;
	_mostRecentLocation = [NSObject releaseOld:_mostRecentLocation retainNew:newLocation];
    [_locationTimer invalidate];
    [self sortRegionsByLocation];
}

- (void) locationManager:(OBALocationManager *)manager didFailWithError:(NSError*)error {
	if( [error domain] == kCLErrorDomain && [error code] == kCLErrorDenied ) {
		[self showLocationServicesAlert];
	}
    [_locationTimer invalidate];
    _locationTimedOut = TRUE;
    [self sortRegionsByLocation];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	if( [self isLoading] )
		return [super numberOfSectionsInTableView:tableView];
    
	if ([_regions count] == 0)
		return 1;
	else
		return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if( [self isLoading] )
		return [super tableView:tableView numberOfRowsInSection:section];
	
	OBASectionType sectionType = [self sectionTypeForSection:section];
	
	switch( sectionType ) {
		case OBASectionTypeRegions:
			return [_regions count];
		case OBASectionTypeNoRegions:
			return 1;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if( [self isLoading] )
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	OBASectionType sectionType = [self sectionTypeForSection:indexPath.section];
	
	switch (sectionType) {
		case OBASectionTypeRegions:
			return [self regionsCellForRowAtIndexPath:indexPath tableView:tableView];
		case OBASectionTypeNoRegions:
			return [self noRegionsCellForRowAtIndexPath:indexPath tableView:tableView];
		default:
			break;
	}
	
	return [UITableViewCell getOrCreateCellForTableView:tableView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if( [self isLoading] ) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
		return;
	}
	
	OBASectionType sectionType = [self sectionTypeForSection:indexPath.section];
	
	switch (sectionType) {
		case OBASectionTypeRegions:
			[self didSelectRegionRowAtIndexPath:indexPath tableView:tableView];
			break;
			
		default:
			break;
	}
	
}

- (void) didCompleteNetworkRequest {
	_hideFutureNetworkErrors = FALSE;
}

- (void) showLocationServicesAlert {
	
	if (! [_appContext.modelDao hideFutureLocationWarnings]) {
		[_appContext.modelDao setHideFutureLocationWarnings:TRUE];
		
		UIAlertView * view = [[UIAlertView alloc] init];
		view.title = NSLocalizedString(@"Location Services Disabled",@"view.title");
		view.message = NSLocalizedString(@"Location Services are disabled for this app.  Some location-aware functionality will be missing.",@"view.message");
		[view addButtonWithTitle:NSLocalizedString(@"Dismiss",@"view addButtonWithTitle")];
		view.cancelButtonIndex = 0;
		[view show];
		[view release];
	}
}

@end

@implementation OBARegionListViewController (Private)


- (OBASectionType) sectionTypeForSection:(NSUInteger)section {
	
	if( [_regions count] == 0 ) {
		if( section == 0 )
			return OBASectionTypeNoRegions;
	}
	else {
		if( section == 0 )
			return OBASectionTypeRegions;
	}
	
	return OBASectionTypeNone;
}

- (UITableViewCell*) regionsCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView {
    
	OBARegionV2 * region = [_regions objectAtIndex:indexPath.row];
	
	UITableViewCell * cell = [UITableViewCell getOrCreateCellForTableView:tableView];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.text = region.regionName;
	return cell;
}

- (UITableViewCell*) noRegionsCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView {
	UITableViewCell * cell = [UITableViewCell getOrCreateCellForTableView:tableView];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.text = NSLocalizedString(@"No regions found",@"cell.textLabel.text");
	return cell;
}

- (void) didSelectActionsRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
	//OBANavigationTarget * target = [OBASearch getNavigationTargetForSearchAgenciesWithCoverage];
	//[_appContext navigateToTarget:target];
}

- (void) didSelectRegionRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
	OBARegionV2 * region = [_regions objectAtIndex:indexPath.row];
	//[[UIApplication sharedApplication] openURL: [NSURL URLWithString: agency.url]];
}


@end
