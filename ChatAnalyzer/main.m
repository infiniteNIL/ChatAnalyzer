//
//  main.m
//  ChatAnalyzer
//
//  Created by Rod Schmidt on 3/28/15.
//  Copyright (c) 2015 Rod Schmidt. All rights reserved.
//

@import Foundation;
#import "ChatAnalyzer.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		printf("ChatAnalyzer v1.0\n");
		if (argc != 2) {
			printf("Usage: ChatAnalyzer <chatMessage>\n");
		}
		else {
			printf("message: %s\n", argv[1]);
			ChatAnalyzer *analyzer = [ChatAnalyzer new];
			NSString *json = [analyzer analyzeMessage:[NSString stringWithUTF8String:argv[1]]];
			printf("\n%s\n", [json UTF8String]);
		}
	}

    return 0;
}
