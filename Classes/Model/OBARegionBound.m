//
//  OBARegionBound.m
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/12/13.
//
//

#import "OBARegionBound.h"

static NSString * kLatKey = @"lat";
static NSString * kLatSpanKey = @"latSpan";
static NSString * kLonKey = @"lon";
static NSString * kLonSpanKey = @"lonSpan";

@implementation OBARegionBound

@dynamic lat;
@dynamic latSpan;
@dynamic lon;
@dynamic lonSpan;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.lat forKey:kLatKey];
    [encoder encodeObject:self.lon forKey:kLonKey];
    [encoder encodeObject:self.latSpan forKey:kLatSpanKey];
    [encoder encodeObject:self.lonSpan forKey:kLonSpanKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.lat = [decoder decodeObjectForKey:kLatKey];
    self.lon = [decoder decodeObjectForKey:kLonKey];
    self.latSpan = [decoder decodeObjectForKey:kLatSpanKey];
    self.lonSpan = [decoder decodeObjectForKey:kLonSpanKey];
    
    return self;
}

@end
