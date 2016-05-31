//
//  ModbusHandler.h
//  ModbusTest
//
//  Created by Joe Wilcoxson on 5/30/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

#ifndef ModbusHandler_h
#define ModbusHandler_h

#import <Foundation/Foundation.h>
#import <modbus/modbus-tcp.h>
#import "ModbusErrors.h"

@interface ModbusHandler : NSObject

//Administrative Functions
-(void) connectTo: (NSString*) ipAddress port: (int) port withError: (NSError **) error;
-(void) disconnect;
-(void) setSlaveId: (int) slaveId withError: (NSError **) error;

//Inputs
-(NSData*) readInputsStartingAtAddress: (int) start withLength: (int) length withError: (NSError **) error;

//Coils
-(NSData*) readCoilsStartingAtAddress: (int) start withLength: (int) length withError: (NSError **) error;
-(void) writeCoilsStartingAtAddress: (int) start withData: (NSData*) data withError: (NSError **) error;

//Input Registers
-(NSData*) readInputRegistersStartingAtAddress: (int) start withLength: (int) length withError: (NSError **) error;

//Holding Registers
-(NSData*) readHoldingRegistersStartingAtAddress: (int) start withLength: (int) length withError: (NSError **) error;
-(void) writeHoldingRegistersStartingAtAddress: (int) start withData: (NSData*) data withError: (NSError **) error;

@end

#endif /* ModbusHandler_h */
