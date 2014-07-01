//
//  StickersViewController.m
//  Stickers
//
//  Created by Om Pathipaka on 6/28/14.
//  Copyright (c) 2014 Om Pathipaka. All rights reserved.
//

#import "StickersViewController.h"

@interface StickersViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
- (IBAction)onStickerDrag:(UIPanGestureRecognizer *)sender;
@property (nonatomic, strong) UIImageView * createdImageView;
- (void)trayPan:(UIPanGestureRecognizer *)panGesture;
- (void)stickerPan:(UIPanGestureRecognizer *)panGesture;
- (void)stickerScale:(UIPinchGestureRecognizer *)pinchGesture;
- (void)stickerRotate:(UIRotationGestureRecognizer *)rotateGesture;
@property (nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic) UIRotationGestureRecognizer *rotateGesture;

@end

@implementation StickersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIPanGestureRecognizer *trayPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(trayPan:)];
    [self.trayView addGestureRecognizer:trayPanGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onStickerDrag:(UIPanGestureRecognizer *)sender {
            CGPoint touchPosition = [sender locationInView:self.view];
            UIImageView * originalImageView = (UIImageView *)sender.view;
    
       if (sender.state == UIGestureRecognizerStateBegan) {
            // Create the new image
           UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(touchPosition.x, touchPosition.y-30,originalImageView.frame.size.width*2, originalImageView.frame.size.height*2
                                                                                  
                                                                                  )];
           imageView.image = originalImageView.image;
           self.createdImageView = imageView;
            [self.view addSubview:self.createdImageView];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            // Change the position of the new image view
            self.createdImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
            
        } else if (sender.state == UIGestureRecognizerStateEnded){
           // add methods to apply gesture recognizers on the newly created images

            [self.createdImageView setUserInteractionEnabled:YES];
            
           UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerPan:)];
            [self.createdImageView addGestureRecognizer:panGR];
            
            panGR.delegate = self;

            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(stickerScale:)];
  
            [self.createdImageView addGestureRecognizer:pinchGesture];
            //pinchGesture.delegate = self;
            
            
            UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(stickerRotate:)];
            [self.createdImageView addGestureRecognizer:rotateGesture];
        }}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

 - (void)trayPan:(UIPanGestureRecognizer *)trayPanGesture {
     
    //CGPoint velocity = [trayPanGesture velocityInView:self.view];
    CGPoint location = [trayPanGesture locationInView:self.view];
    /*
     CGFloat trayUpPosition = 532;
     CGFloat trayHidePosition = 564;
     */
     if(trayPanGesture.state == UIGestureRecognizerStateChanged) {
        
        self.trayView.center = CGPointMake(self.trayView.center.x, location.y +10);
        if (location.y < 532) {
            self.trayView.center = CGPointMake(self.trayView.center.x, 532);}

     }
 }

 - (void)stickerPan:(UIPanGestureRecognizer *)panGesture {
    
        CGPoint translation = [panGesture translationInView:self.view];
        
        if(panGesture.state == UIGestureRecognizerStateChanged) {
            NSLog(@"panning sticker");
            //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
            
            panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
            [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            
        } if (panGesture.state == UIGestureRecognizerStateEnded) {
            //UIImageView *view;
            
        }
}

- (void)stickerScale:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"scaling sticker ..");
    CGFloat scale = pinchGesture.scale;
    self.createdImageView.transform = CGAffineTransformScale(self.createdImageView.transform, scale, scale);
    pinchGesture.scale = 1.0;
    }

- (void)stickerRotate:(UIRotationGestureRecognizer *)rotateGesture{
    CGFloat angle = rotateGesture.rotation;
    self.createdImageView.transform = CGAffineTransformRotate(self.createdImageView.transform, angle);
    rotateGesture.rotation = 0.0;
}
@end
