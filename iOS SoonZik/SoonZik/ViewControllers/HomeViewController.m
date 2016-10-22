//
//  HomeViewController.m
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Pack.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "NewsNouvelleCell.h"
#import "DetailNewsViewController.h"
#import "SimplePopUp.h"
#import "SocialConnect.h"

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self getData];
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        
        self.listOfNews = [[NSMutableArray alloc] initWithArray:[Factory provideListWithClassName:@"News"]];
        if (self.listOfNews.count == 0) {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"loading_error"] onView:self.view withSuccess:false] show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataLoaded)
        return self.listOfNews.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    if ([news.type isEqualToString:@"Nouvelle"]) {
        return 138;
    }
    
    return 138;
}

- (void)closeView {
    [self.shareView removeFromSuperview];
    [self removeBlurEffect:200 onView:self.view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"cellID1";
    static NSString *cellId2 = @"cellID2";
    
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    //if ([news.type isEqualToString:@"Nouvelle"]) {
        NewsNouvelleCell *cell = (NewsNouvelleCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"NewsNouvelleCell" bundle:nil] forCellReuseIdentifier:cellId1];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        }
        [cell initCellWithNews:news];
        cell.shareDelegate = self;
        [cell.shareButton setBackgroundImage:[Tools imageWithImage:[UIImage imageNamed:@"share"] scaledToSize:CGSizeMake(26, 26)] forState:UIControlStateNormal];
        bool found = false;
        int i = 0;
        
        while ((i < news.listOfAttachments.count) && (!found)) {
            Attachment *att = [news.listOfAttachments objectAtIndex:i];
            if ([att.contentType isEqualToString:@"image/jpeg"]) {
                NSString *urlImage = [NSString stringWithFormat:@"%@assets/news/%@", API_URL, att.url];
                NSLog(@"%@", urlImage);
                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
                cell.newsImage.image = [UIImage imageWithData:imageData];
                found = true;
            }
            i++;
        }
    
    /*unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour;
    NSDateComponents *conversionInfo = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:unitFlags fromDate:news.date   toDate:[NSDate date]  options:0];
    
    int seconds = [conversionInfo second];
    int days = [conversionInfo day];
    int hours = [conversionInfo hour];
    int minutes = [conversionInfo minute];
    
    if (days < 1) {
        if (hours < 1) {
            if (minutes < 1) {
                cell.dateLabel.text = [NSString stringWithFormat:@"Il y a %i secondes", seconds];
            } else {
                cell.dateLabel.text = [NSString stringWithFormat:@"Il y a %i minutes", minutes];
            }
        } else {
            cell.dateLabel.text = [NSString stringWithFormat:@"Il y a %i heures", hours];
        }
    } else if (days == 1) {
        cell.dateLabel.text = [NSString stringWithFormat:@"Il y a %i jour", 1];
    } else if (days > 1) {
        
        cell.dateLabel.text = [NSString stringWithFormat:@"Il y a %i jours", days];
    }*/

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
  /*  }
        
    NewsTypeAlbumCell *cell = (NewsTypeAlbumCell *)[tableView dequeueReusableCellWithIdentifier:cellId2];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"NewsTypeAlbumCell" bundle:nil] forCellReuseIdentifier:cellId2];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
    }
    [cell initCellWithNews:news];
    cell.shareDelegate = self;
    [cell.shareButton setBackgroundImage:[Tools imageWithImage:[UIImage imageNamed:@"share"] scaledToSize:CGSizeMake(26, 26)] forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    DetailNewsViewController *vc = [[DetailNewsViewController alloc] initWithNibName:@"DetailNewsViewController" bundle:nil];
    vc.news = news;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
