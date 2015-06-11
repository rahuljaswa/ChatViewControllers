//
//  RJWriteChatView.h
//  Pods
//
//  Created by Rahul Jaswa on 6/11/15.
//
//

#import <UIKit/UIKit.h>


@class RJWriteChatView;

@protocol RJWriteChatViewDelegate <NSObject>

- (void)writeChatView:(RJWriteChatView *)writeChatView wantsHeight:(CGFloat)height;

@end


@interface RJWriteChatView : UIView

@property (nonatomic, weak) id<RJWriteChatViewDelegate> delegate;

@property (nonatomic, strong, readonly) UITextView *commentView;
@property (nonatomic, strong, readonly) UIButton *sendButton;

- (void)reset;

@end
