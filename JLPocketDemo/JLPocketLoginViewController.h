//
//  JLPocketLoginViewController.h
//  JLPocketDemo
//
//  Created by Jason Larsen on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// when the user presses save, the controller does whatever this block says
// to do with the supplied username and password
typedef void(^JLLoginCompletionBlock)(NSString *username, NSString *password);

@interface JLPocketLoginViewController : UITableViewController
@property (nonatomic, copy) JLLoginCompletionBlock completion;
@end
