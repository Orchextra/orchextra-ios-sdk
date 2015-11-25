/*===============================================================================
Copyright (c) 2012-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/


#import <UIKit/UIKit.h>

#import <QCAR/UIGLViewProtocol.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/Vectors.h>

#import "ORCTexture.h"
#import "VuforiaApplicationSession.h"


// structure to point to an object to be drawn
@interface ORCObject3D : NSObject

@property (nonatomic) unsigned int numVertices;
@property (nonatomic) const float *vertices;
@property (nonatomic) const float *normals;
@property (nonatomic) const float *texCoords;

@property (nonatomic) unsigned int numIndices;
@property (nonatomic) const unsigned short *indices;

@property (nonatomic) ORCTexture *texture;

@end


@class ORCCloudRecoViewController;

static const int kNumAugmentationTextures = 1;


// EAGLView is a subclass of UIView and conforms to the informal protocol
// UIGLViewProtocol
@interface ORCCloudRecoEAGLView : UIView <UIGLViewProtocol> {
@private
    // OpenGL ES context
    EAGLContext *context;
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
    // Shader handles
    GLuint shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
    GLint texSampler2DHandle;
    
    // Texture used when rendering augmentation
    ORCTexture* augmentationTexture[kNumAugmentationTextures];

    BOOL offTargetTrackingEnabled;
}

@property (nonatomic, weak) VuforiaApplicationSession * vapp;
@property (nonatomic, weak) ORCCloudRecoViewController * viewController;


- (id)initWithFrame:(CGRect)frame appSession:(VuforiaApplicationSession *) app viewController:(ORCCloudRecoViewController *) viewController;
- (void)finishOpenGLESCommands;
- (void)freeOpenGLESResources;

@end
