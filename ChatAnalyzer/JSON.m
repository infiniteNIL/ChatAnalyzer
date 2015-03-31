//
//  JSON.m
//  ChatAnalyzer
//
//  Created by Rod Schmidt on 3/28/15.
//  Copyright (c) 2015 Rod Schmidt. All rights reserved.
//

#import "JSON.h"

@implementation NSDictionary (JSON)

- (NSString *)toJSON {
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
	if (jsonData == nil) {
		NSLog(@"Error creating JSON: %@", [error localizedDescription]);
	}
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
