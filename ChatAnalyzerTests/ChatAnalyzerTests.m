//
//  ChatAnalyzerTests.m
//  ChatAnalyzerTests
//
//  Created by Rod Schmidt on 3/28/15.
//  Copyright (c) 2015 Rod Schmidt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ChatAnalyzer.h"
#import "JSON.h"

@interface ChatAnalyzerTests : XCTestCase

@property (nonatomic) ChatAnalyzer *analyzer;

@end

@implementation ChatAnalyzerTests

- (void)setUp {
    [super setUp];

	self.analyzer = [[ChatAnalyzer alloc] init];
}

- (void)tearDown {
	self.analyzer = nil;

	[super tearDown];
}

- (void)testExtractingMentions {
	NSDictionary *expectedResult = @{@"mentions": @[@"chris"]};

	NSString *json = [self.analyzer analyzeMessage:@"@chris you around?"];
	XCTAssertEqualObjects(json, [expectedResult toJSON]);
}

- (void)testExtractingEmoticons {
	NSDictionary *expectedResult = @{@"emoticons": @[@"megusta", @"coffee"]};

	NSString *json = [self.analyzer analyzeMessage:@"Good morning! (megusta) (coffee)"];
	XCTAssertEqualObjects(json, [expectedResult toJSON]);
}

- (void)testExtractingLinks {
	NSDictionary *expectedResult = @{
	  @"links": @[
        @{
		   @"url": @"http://www.nbcolympics.com",
           @"title": @"NBC Olympics | Home of the 2016 Olympic Games in Rio"
		 }
	  ]
	};

	NSString *json = [self.analyzer analyzeMessage:@"Olympics are starting soon; http://www.nbcolympics.com"];
	XCTAssertEqualObjects(json, [expectedResult toJSON]);
}

- (void)testExtractingAll {
	NSDictionary *expectedResult = @{
	  @"mentions": @[
	    @"bob",
		@"john"
	  ],
	  @"emoticons": @[
	    @"success"
	  ],
	  @"links": @[
	    @{
		   @"url": @"https://twitter.com/jdorfman/status/430511497475670016",
		   @"title": @"Justin Dorfman on Twitter: &quot;nice @littlebigdetail from @HipChat (shows hex colors when pasted in chat). http://t.co/7cI6Gjy5pq&quot;"
		 }
	  ]
	};

	NSString *json = [self.analyzer analyzeMessage:@"@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"];
	XCTAssertEqualObjects(json, [expectedResult toJSON]);
}

- (void)testNilMessage {
	NSString *json = [self.analyzer analyzeMessage:nil];
	XCTAssertEqualObjects(json, @"{}");
}

- (void)testEmptyMessage {
	NSString *json = [self.analyzer analyzeMessage:@""];
	XCTAssertEqualObjects(json, @"{}");
}

/* This test is commented out for now because it takes 60 seconds for network access to time out
 * We could speed it up by mocking the NSString#initWithContentsOfURL call, but I think its probably a little overkill
 * for this.
- (void)testMessageWithBadURL {
	NSDictionary *expectedResult = @{
	  @"links": @[
		 @{
			 @"url": @"http://www.asdfasdfsdf.com",
			 @"title": @""
		  }
	  ]
	};

	NSString *json = [self.analyzer analyzeMessage:@"http://www.asdfasdfsdf.com"];
	XCTAssertEqualObjects(json, [expectedResult toJSON]);
}
*/

@end
