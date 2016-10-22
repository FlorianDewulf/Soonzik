//
//  SocialConnect.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "SocialConnect.h"
#import "Network.h"
#import "User.h"
#import "News.h"
#import "Music.h"
#import "Album.h"
#import "Concert.h"
#import <Social/Social.h>

@implementation SocialConnect

+ (BOOL)shareOnFacebook:(id)elem onVC:(UIViewController *)vc
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                NSLog(@"Done");
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler = myBlock;
        [controller removeAllImages];
        [controller removeAllURLs];
        
        if ([elem isKindOfClass:[News class]]) {
            News *news = (News *)elem;
            [controller setInitialText:news.title];
            [controller addImage:[UIImage imageNamed:@"news_icon"]];
        } else if ([elem isKindOfClass:[User class]]) {
            User *artist = (User *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Découvrez %@ sur SoonZik", artist.username]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, artist.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        } else if ([elem isKindOfClass:[Album class]]) {
            Album *album = (Album *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Découvrez l'album %@ de %@ sur SoonZik", album.title, album.artist.username]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, album.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        } else if ([elem isKindOfClass:[Concert class]]) {
            Concert *concert = (Concert *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Concert de %@ à %@", concert.artist.username, concert.address.city]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, concert.artist.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        }
        
        [controller addURL:[NSURL URLWithString:@"http://soonzik.com"]];
        
        
        [vc presentViewController:controller animated:YES completion:Nil];
    }
    
    return true;
}

+ (BOOL)shareOnTwitter:(id)elem onVC:(UIViewController *)vc
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                NSLog(@"Done");
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler = myBlock;
        [controller removeAllImages];
        [controller removeAllURLs];
        
        if ([elem isKindOfClass:[News class]]) {
            News *news = (News *)elem;
            [controller setInitialText:news.title];
            [controller addImage:[UIImage imageNamed:@"news_icon"]];
        } else if ([elem isKindOfClass:[User class]]) {
            User *artist = (User *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Découvrez %@ sur @@SoonZik", artist.username]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, artist.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        } else if ([elem isKindOfClass:[Album class]]) {
            Album *album = (Album *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Découvrez l'album %@ de %@ sur @@SoonZik", album.title, album.artist.username]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, album.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        } else if ([elem isKindOfClass:[Concert class]]) {
            Concert *concert = (Concert *)elem;
            [controller setInitialText:[NSString stringWithFormat:@"Concert de %@ à %@", concert.artist.username, concert.address.city]];
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, concert.artist.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [controller addImage:[UIImage imageWithData:imageData]];
        }
        
        [controller addURL:[NSURL URLWithString:@"http://soonzik.com"]];
        
        
        [vc presentViewController:controller animated:YES completion:Nil];
    }
    
    return true;
}

@end
