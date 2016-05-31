//
//  main.m
//  ModbusTest
//
//  Created by Joe Wilcoxson on 5/30/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModbusHandler.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        ModbusHandler *m = [[ModbusHandler alloc] init];
        NSError *e;
        [m connectTo:@"10.0.0.16" port:1502 withError:&e];
        
        if (e == nil) {
            NSData *d = [m readInputsStartingAtAddress:0 withLength:10 withError:&e];
            
            for (int i = 0; i < 10; i++) {
                int b = 0;
                [d getBytes:&b range:NSMakeRange(i, 1)];
                NSLog(@"%d", b);
            }
            
            [m setSlaveId:6 withError:&e];
            [m writeCoilsStartingAtAddress:0 withData:d withError:&e];
            [m disconnect];
        }
        else {
            NSLog(@"Couldn't connect to server");
        }
        
    }
    return 0;
}
