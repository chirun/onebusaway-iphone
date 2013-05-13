//
//  OBARegionBound.h
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/12/13.
//
//

//#import <CoreData/CoreData.h>

@interface OBARegionBound : NSManagedObject<NSCoding>
{
}

@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * latSpan;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * lonSpan;

@end
