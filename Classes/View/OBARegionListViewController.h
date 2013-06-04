//
//  OBARegionListViewController.h
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/15/13.
//
//

#import "OBAApplicationContext.h"
#import "OBARequestDrivenTableViewController.h"

@class OBARequestDrivenTableViewController;

@interface OBARegionListViewController : OBARequestDrivenTableViewController<OBALocationManagerDelegate> {
    NSMutableArray * _regions;
    NSMutableArray * _nearbyRegions;
    
    CLLocation * _mostRecentLocation;
    BOOL _hideFutureNetworkErrors;
    BOOL _locationTimedOut;
    NSTimer *_locationTimer;
}

- (id) initWithApplicationContext:(OBAApplicationContext*)appContext;
- (void) sortRegionsByLocation;
- (void) sortRegionsByName;
- (void) timeOutLocation:(NSTimer*)theTimer;
- (void) showLocationServicesAlert;

@end
