//
//  ConnectionManager.h
//  Nora
//
//  Created by Paul Smal on 4/27/13.
//  Copyright (c) 2013 Paul Smal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ocilib.h"

@interface ConnectionManager : NSObject {
    
 //   OCI_Connection *connectionInstance;
    @public
    OCI_Connection *cnarray[10];
    @public
    int count;
}


+ (id)sharedManager;
@end
