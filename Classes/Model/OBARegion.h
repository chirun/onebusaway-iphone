//
//  OBARegion.h
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/12/13.
//
//

//#import <CoreData/CoreData.h>

@interface OBARegion : NSManagedObject<NSCoding>
{
}

@property (nonatomic, retain) NSString * siriBaseUrl;
@property (nonatomic, retain) NSString * obaVersionInfo;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSArray * bounds;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * obaBaseUrl;
@property (nonatomic, retain) NSString * regionName;

@property (nonatomic, retain) NSString * supportsSiriRealtimeApis;
@property (nonatomic, retain) NSString * supportsObaRealtimeApis;
@property (nonatomic, retain) NSString * supportsObaDiscoveryApis;
@property (nonatomic, retain) NSString * active;
@property (nonatomic, retain) NSString * id_number;

@end