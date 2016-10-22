//
//  ChatViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 16/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "Socket.h"
#import "MessagesController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        NSString *urlImage1 = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, user.image];
        NSData * imageData1 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage1]];
        self.myImage = [UIImage imageWithData:imageData1];

        NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.friend.image];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        self.partnerImage = [UIImage imageWithData:imageData];

        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self refreshMessages];
        });
    });
    
    //--------------------------------------------------
    //         Customizing input view
    //--------------------------------------------------
    self.inputView.textInitialHeight = 45;
    self.inputView.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    // Apply changes
    [self.inputView adjustInputView];
    //--------------------------------------------------
    
    [self loadMessages];
    
    self.socket = [Socket sharedCenter];
    self.socket.delegate = self;
    
    self.view.backgroundColor = DARK_GREY;
}

- (void)messageHasBeenReceived:(Message *)msg {
    [self loadMessages];
    [self refreshMessages];
}

- (void)loadMessages
{
    self.messages = [[self generateConversation] mutableCopy];
}

#pragma mark - SOMessaging data source

- (CGFloat)heightForMessageForIndex:(NSInteger)index
{
    CGFloat height = [super heightForMessageForIndex:index];
    
    height += 15; // Increasing message height for more 15pts
    
    return height;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.messages[index];
    
    // Adjusting content for 4pt. (In this demo the width of bubble's tail is 8pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 4.0f, 0, 0); //Move content for 4 pt. to right
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 4.0f); //Move content for 4 pt. to left
    }
    
    cell.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    if (message.fromMe) {
        cell.textView.textColor = ORANGE;
    } else {
        cell.textView.textColor = BLUE_1;
    }
    
    cell.textView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.userImageView.layer.cornerRadius = 3;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
    
    // Disabling left drag functionality
    cell.panGesture.enabled = NO;
    
    
    //-----------------------------------------------//
    //     Adding datetime label under balloon
    //-----------------------------------------------//
    [self generateLabelForCell:cell];
    //-----------------------------------------------//
}

- (void)generateLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 90;
    
    Message *message = (Message *)cell.message;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor grayColor];
        label.tag = labelTag;
        [cell.contentView addSubview:label];
    }
    label.text = [formatter stringFromDate:message.date];
    [label sizeToFit];
    CGRect frame = label.frame;
    
    CGFloat topMargin = 5.0f;
    CGFloat leftMargin = 15.0f;
    CGFloat rightMargin = 20.0f;
    
    if (message.fromMe) {
        frame.origin.x = cell.contentView.frame.size.width - cell.userImageView.frame.size.width - frame.size.width - rightMargin;
        frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    } else {
        frame.origin.x = cell.containerView.frame.origin.x + cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width + leftMargin;
        frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    
    label.frame = frame;
}

- (UIImage *)balloonImageForSending
{
    UIImage *img = [UIImage imageNamed:@"bubble_rect_sending.png"];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 24, 11)];
}

- (UIImage *)balloonImageForReceiving
{
    UIImage *img = [UIImage imageNamed:@"bubble_rect_receiving.png"];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 11, 24, 3)];
}

- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(44, 44);
}

- (CGFloat)balloonMinHeight
{
    return 44;
}

- (CGFloat)balloonMinWidth
{
    return 243;
}

#pragma mark - SOMessaging delegate
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [self sendMessage:msg];
    
    [[Socket sharedCenter] sendMessage:message toUserId:self.friend.identifier];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

- (NSArray *)generateConversation
{
    NSMutableArray *result = [NSMutableArray new];
    NSArray *data = [MessagesController getMessagesWithFriendId:self.friend.identifier withOffset:0];
    for (Message *msg in data) {
        
        msg.type = 0;//[self messageTypeFromString:msg[@"type"]];
        //msg.date = msg.date;
        
        /*if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }*/
        
        [result addObject:msg];
    }
    
    return result;
}

/*- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }
    
    return SOMessageTypeOther;
}*/

@end
