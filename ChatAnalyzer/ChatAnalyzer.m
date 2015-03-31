//
//  ChatAnalyzer.m
//  ChatAnalyzer
//
//  Created by Rod Schmidt on 3/28/15.
//  Copyright (c) 2015 Rod Schmidt. All rights reserved.
//

#import "ChatAnalyzer.h"
#import "JSON.h"

@interface ChatAnalyzer ()
@end

@implementation ChatAnalyzer

- (NSString *)analyzeMessage:(NSString *)message {
	if (message == nil) {
		return @"{}";
	}
	
	NSMutableDictionary *result = [NSMutableDictionary new];

	NSArray *mentions = [self mentionsInMessage:message];
	if ([mentions count] > 0) {
		result[@"mentions"] = mentions;
	}

	NSArray *emoticons = [self emoticonsInMessage:message];
	if ([emoticons count] > 0) {
		result[@"emoticons"] = emoticons;
	}

	NSArray *links = [self linksInMessage:message];
	if ([links count] > 0) {
		result[@"links"] = links;
	}

	return [result toJSON];
}

- (NSArray *)mentionsInMessage:(NSString *)message {
	NSParameterAssert(message != nil);

	NSMutableArray *mentions = [NSMutableArray new];

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w*)"
																		   options:0
																			 error:nil];
	NSAssert(regex != nil, @"Bad regular expression");

	[regex enumerateMatchesInString:message options:0 range:NSMakeRange(0, [message length])
						 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
							 NSString *mention = [message substringWithRange:[result rangeAtIndex:1]];
							 [mentions addObject:mention];
						 }];

	return [mentions copy];
}

- (NSArray *)emoticonsInMessage:(NSString *)message {
	NSParameterAssert(message != nil);

	NSMutableArray *emoticons = [NSMutableArray new];

	// The instructions say emoticons are no longer than 15 characters, but one is firstworldproblems which is
	// 18 characters, so I will allow any length.
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\((\\w*)\\)"
																		   options:0
																			 error:nil];
	NSAssert(regex != nil, @"Bad regular expression");

	[regex enumerateMatchesInString:message options:0 range:NSMakeRange(0, [message length])
						 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
							 NSString *emoticon = [message substringWithRange:[result rangeAtIndex:1]];
							 [emoticons addObject:emoticon];
						 }];

	return [emoticons copy];
}

- (NSArray *)linksInMessage:(NSString *)message {
	NSParameterAssert(message != nil);

	NSMutableArray *links = [NSMutableArray new];

	NSArray *urls = [self URLsInMessage:message];
	[urls enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
		NSString *title = [self fetchTitleOfURL:url];
		[links addObject:@{@"url": [url absoluteString],
						   @"title": title}];
	}];

	return [links copy];
}

- (NSArray *)URLsInMessage:(NSString *)message {
	NSParameterAssert(message != nil);

	NSMutableArray *urls = [NSMutableArray new];

	NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
	[detector enumerateMatchesInString:message options:0 range:NSMakeRange(0, [message length])
							usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
								[urls addObject:[result URL]];
							}];

	return [urls copy];
}

- (NSString *)fetchTitleOfURL:(NSURL *)url {
	NSParameterAssert(url != nil);

	NSError *error = nil;
	NSString *contents = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	if (contents) {
		return [self extractTitleFromHTML:contents];
	}
	else {
		NSLog(@"Error fetching contents of %@: %@", url, [error localizedDescription]);
		return @"";
	}
}

- (NSString *)extractTitleFromHTML:(NSString *)html {
	NSParameterAssert(html != nil);

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<title>(.*)</title>"
																		   options:0
																			 error:nil];
	NSAssert(regex != nil, @"Bad regular expression");

	__block NSString *title;

	[regex enumerateMatchesInString:html options:0 range:NSMakeRange(0, [html length])
						 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
							 title = [html substringWithRange:[result rangeAtIndex:1]];
							 *stop = YES;
						 }];

	return title ?: @"";
}

@end
