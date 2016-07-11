//
//  ViewController.m
//  MADTwitterShare
//
//  Created by Mariia Cherniuk on 07.07.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTextView];
}

- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    if (_postTextView.isFirstResponder) {
        [_postTextView resignFirstResponder];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Post your note" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *twitterAction = [UIAlertAction actionWithTitle:@"Post to Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
             SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
             
             if (_postTextView.text.length < 140) {
                 [composeVC setInitialText:_postTextView.text];
             } else {
                 [composeVC setInitialText:[_postTextView.text substringToIndex:140]];
             }
             [self presentViewController:composeVC animated:YES completion:nil];
         } else {
             [self alertMessage:@"You are not singed in to Twitter"];
         }
    }];
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Post to Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [composeVC setInitialText:_postTextView.text];
            [self presentViewController:composeVC animated:YES completion:nil];
        } else {
            [self alertMessage:@"You are not singed in to Facebook"];
        }
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Post to ..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *objectsToShare = [NSArray arrayWithObject:_postTextView.text];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }];
    
    [alertController addAction:twitterAction];
    [alertController addAction:facebookAction];
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)configureTextView {
    _postTextView.layer.cornerRadius = 20.f;
    _postTextView.layer.borderWidth = 2.f;
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SocialShare" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
