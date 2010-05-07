// Copyright 2010 The Omni Group.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.
//
// $Id$

@protocol OUIDocumentPreview <NSObject>
@property(readonly) CGSize originalViewSize;
- (CGAffineTransform)transformForTargetRect:(CGRect)targetRect;
@property(readonly) CGRect untransformedPageRect;
@property(retain) UIImage *cachedImage;
@end
