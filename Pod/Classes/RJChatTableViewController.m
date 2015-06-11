//
//  RJChatTableViewController.m
//  Pods
//
//  Created by Rahul Jaswa on 6/11/15.
//
//

#import "RJChatTableViewController.h"
#import "RJWriteChatView.h"


@interface RJChatTableViewController () <RJWriteChatViewDelegate>

@property (nonatomic, assign, getter=hasViewAppeared) BOOL viewAppeared;

@end


@implementation RJChatTableViewController

@synthesize writeChatView = _writeChatView;

#pragma mark - Private Properties

- (RJWriteChatView *)writeChatView {
    if (!_writeChatView) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        _writeChatView = [[RJWriteChatView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 41.0f)];
        _writeChatView.delegate = self;
    }
    return _writeChatView;
}

#pragma mark - Private Protocols - RJSendCommentViewDelegate

- (void)writeChatView:(RJWriteChatView *)writeChatView wantsHeight:(CGFloat)height {
    for (NSLayoutConstraint *constraint in [writeChatView constraints]) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
            [writeChatView layoutIfNeeded];
        }
    }
}

#pragma mark - Private Instance Methods

- (void)keyboardDidHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.writeChatView.bounds), 0.0f);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self scrollToBottomOfContentIfNecessaryAnimated:self.hasViewAppeared];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(endFrame), 0.0f);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self scrollToBottomOfContentIfNecessaryAnimated:self.hasViewAppeared];
}

- (void)scrollToBottomOfContentIfNecessaryAnimated:(BOOL)animated {
    CGFloat tableFrameHeight = CGRectGetHeight(self.tableView.bounds);
    CGFloat contentHeight = self.tableView.contentSize.height;
    CGFloat contentInsetBottom = self.tableView.contentInset.bottom;
    
    CGFloat usableHeight = tableFrameHeight;
    usableHeight -= self.tableView.contentInset.top;
    usableHeight -= contentInsetBottom;
    
    if (contentHeight > usableHeight) {
        CGPoint targetContentOffset = CGPointMake(0.0f, contentHeight + contentInsetBottom - tableFrameHeight);
        if (!CGPointEqualToPoint(targetContentOffset, self.tableView.contentOffset)) {
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.contentOffset = targetContentOffset;
                }];
            } else {
                self.tableView.contentOffset = targetContentOffset;
            }
        }
    }
}

#pragma mark - Public Instance Methods

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputAccessoryView {
    return self.writeChatView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.hasViewAppeared) {
        if (![self isFirstResponder]) {
            [self becomeFirstResponder];
        }
        [self scrollToBottomOfContentIfNecessaryAnimated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

@end
