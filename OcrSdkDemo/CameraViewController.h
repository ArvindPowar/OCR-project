//
//  CameraViewController.h
//  OcrSdkDemo
//
//  Created by arvind on 3/26/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CameraViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    IBOutlet UIView *viewPreview;             //<<<<<ADD THIS
}
@property(nonatomic, retain) IBOutlet UIView *viewPreview;
@property(nonatomic,retain) AVCaptureSession *session;


@end
