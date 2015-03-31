//
//  ChatAnalyzer.h
//  ChatAnalyzer
//
//  Created by Rod Schmidt on 3/28/15.
//  Copyright (c) 2015 Rod Schmidt. All rights reserved.
//

@import Foundation;

@interface ChatAnalyzer : NSObject

/*
	Takes a chat message string and returns a JSON string containing information about its contents.

	The following content is looked for:
		1. @mentions - A way to mention a user. Always starts with an '@' and ends when hitting a non-word character.

		2. Emoticons - 'custom' emoticons which are ASCII strings, no longer than 15 characters, contained in parenthesis.
					   Assume that anything matching this format is an emoticon. (http://hipchat-emoticons.nyh.name)

		3. Links - Any URLs contained in the message, along with the page's title.

	Returns JSON representing the content with keys for mentions, emoticons, and links which are all arrays: For example:

		{
			"mentions": [
				"bob",
				"john"
			],
			"emoticons": [
				"success"
			]
			"links": [
				{
					"url": "https://twitter.com/jdorfman/status/430511497475670016",
					"title": "Twitter / jdorfman: nice @littlebigdetail from ..."
				}
			]
		}
*/
- (NSString *)analyzeMessage:(NSString *)message;

@end
