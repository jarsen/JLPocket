JLPocket
========

JLPocket provides a very simple wrapper around the Pocket API (formerly Read It Later) for iOS applications.

Why it's better than the [ReadItLaterFull/Lite](http://getpocket.com/api/libraries-iphone/) they give you:
* Uses SSKeychain to store account information, NOT NSUserDefaults
* Uses blocks. No more gross delegates.

Why it may not be better:
* I really haven't tested it much. It authenticates and saves links at least. I haven't tested registering.

Distributed under the Do-Whatever-You-Want License. But maybe give me a shoutout if you'd like or follow me on [twitter](http://twitter.com/jarsen).

Dropping into project
---------------------
1. Copy all files from the JLPocket group/folder into your own project.
2. Make sure the JLPocket.m, SSKeychain.m, and NSString+URLEncode.m files are added to your build settings.
3. Add Security.framework to your build.