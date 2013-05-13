//
//  OBARegion.m
//  org.onebusaway.iphone
//
//  Created by chaya3 on 5/12/13.
//
//

#import "OBARegion.h"

static NSString * kSiriBaseUrl = @"siriBaseUrl";
static NSString * kObaVersionInfo = @"obaVersionInfo";
static NSString * kSupportsSiriRealtimeApis = @"supportsSiriRealtimeApis";
static NSString * kLanguage = @"language";
static NSString * kSupportsObaRealtimeApis = @"supportsObaRealtimeApis";
static NSString * kBounds = @"bounds";
static NSString * kSupportsObaDiscoveryApis = @"supportsObaDiscoveryApis";
static NSString * kContactEmail = @"contactEmail";
static NSString * kActive = @"active";
static NSString * kObaBaseUrl = @"obaBaseUrl";
static NSString * kId_number = @"id_number";
static NSString * kRegionName = @"regionName";

@implementation OBARegion

@dynamic siriBaseUrl;
@dynamic obaVersionInfo;
@dynamic supportsSiriRealtimeApis;
@dynamic language;
@dynamic supportsObaRealtimeApis;
@dynamic bounds;
@dynamic supportsObaDiscoveryApis;
@dynamic contactEmail;
@dynamic active;
@dynamic obaBaseUrl;
@dynamic id_number;
@dynamic regionName;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.siriBaseUrl forKey:kSiriBaseUrl];
    [encoder encodeObject:self.obaVersionInfo forKey:kObaVersionInfo];
    [encoder encodeObject:self.supportsSiriRealtimeApis forKey:kSupportsSiriRealtimeApis];
    [encoder encodeObject:self.language forKey:kLanguage];
    [encoder encodeObject:self.supportsObaRealtimeApis forKey:kSupportsObaRealtimeApis];
    [encoder encodeObject:self.bounds forKey:kBounds];
    [encoder encodeObject:self.supportsObaDiscoveryApis forKey:kSupportsObaDiscoveryApis];
    [encoder encodeObject:self.contactEmail forKey:kContactEmail];
    [encoder encodeObject:self.active forKey:kActive];
    [encoder encodeObject:self.obaBaseUrl forKey:kObaBaseUrl];
    [encoder encodeObject:self.id_number forKey:kId_number];
    [encoder encodeObject:self.regionName forKey:kRegionName];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.siriBaseUrl = [decoder decodeObjectForKey:kSiriBaseUrl];
    self.obaVersionInfo = [decoder decodeObjectForKey:kObaVersionInfo];
    self.supportsSiriRealtimeApis = [decoder decodeObjectForKey:kSupportsSiriRealtimeApis];
    self.language = [decoder decodeObjectForKey:kLanguage];
    self.supportsObaRealtimeApis = [decoder decodeObjectForKey:kSupportsObaRealtimeApis];
    self.bounds = [decoder decodeObjectForKey:kBounds];
    self.supportsObaRealtimeApis = [decoder decodeObjectForKey:kSupportsObaRealtimeApis];
    self.contactEmail = [decoder decodeObjectForKey:kContactEmail];
    self.active = [decoder decodeObjectForKey:kActive];
    self.obaBaseUrl = [decoder decodeObjectForKey:kObaBaseUrl];
    self.id_number = [decoder decodeObjectForKey:kId_number];
    self.regionName = [decoder decodeObjectForKey:kRegionName];
    
    return self;
}

@end
