//
//  RJChatTableViewController.h
//  Pods
//
//  Created by Rahul Jaswa on 6/11/15.
//
//

#import <UIKit/UIKit.h>


@class RJWriteChatView;

@interface RJChatTableViewController : UITableViewController

@property (nonatomic, strong, readonly) RJWriteChatView *writeChatView;

@end
