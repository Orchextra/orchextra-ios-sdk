//
//  GIGDispatch.h
//  giglibrary
//
//  Created by Sergio Baró on 03/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#ifndef utils_GIGDispatch_h
#define utils_GIGDispatch_h

#import <Foundation/Foundation.h>

__unused static void gig_dispatch_main(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

__unused static void gig_dispatch_after_seconds(NSTimeInterval delayInSeconds, dispatch_block_t block)
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

__unused static void gig_dispatch_background(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

#endif
