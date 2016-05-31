//
//  ModbusHandler.m
//  ModbusTest
//
//  Created by Joe Wilcoxson on 5/30/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

#import "ModbusHandler.h"

@implementation ModbusHandler
{
    modbus_t *mb;
    
}

-(id)init {
    self = [super init];
    if(self) {
        return self;
    }
    else {
        return nil;
    }
}

-(void)connectTo:(NSString *)ipAddress port:(int)port withError:(NSError *__autoreleasing *)error {
    *error = nil;
    const char *cIpAddress = [ipAddress cStringUsingEncoding:NSASCIIStringEncoding];
    mb = modbus_new_tcp(cIpAddress, port);
    
    if (mb != NULL) {
        if (modbus_connect(mb) == -1)
        {
            *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                                code:errno
                                            userInfo:NULL];
            [self disconnect];
        }
        
    }
    else {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
        [self disconnect];
    }
}

-(void)disconnect {
    modbus_close(mb);
    modbus_free(mb);
}

-(void)setSlaveId:(int)slaveId withError:(NSError *__autoreleasing *)error {
    *error = nil;
    if(modbus_set_slave(mb, slaveId) != 0) {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
    }
}

-(NSData*)readInputsStartingAtAddress:(int)start withLength:(int)length withError:(NSError *__autoreleasing *)error {
    *error = nil;
    uint8_t bytes[length];
    if(modbus_read_input_bits(mb, start, length, bytes) == length) {
        NSData *d = [[NSData alloc] initWithBytes:bytes length:length];
        return d;
    }
    else {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
        return nil;
    }

}

-(NSData*)readCoilsStartingAtAddress:(int)start withLength:(int)length withError:(NSError *__autoreleasing *)error {
    *error = nil;
    uint8_t bytes[length];
    if(modbus_read_bits(mb, start, length, bytes) == length) {
        NSData *d = [[NSData alloc] initWithBytes:bytes length:length];
        return d;
    }
    else {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
        return nil;
    }
}

-(void)writeCoilsStartingAtAddress:(int)start withData:(NSData *)data withError:(NSError *__autoreleasing *)error {
    *error = nil;
    int length = (int)[data length];
    uint8_t bytes[length];
    [data getBytes:&bytes length:length];
    if(modbus_write_bits(mb, start, length, bytes) != length) {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
    }
}

-(NSData*)readInputRegistersStartingAtAddress:(int)start withLength:(int)length withError:(NSError *__autoreleasing *)error {
    *error = nil;
    uint16_t words[length];
    if(modbus_read_input_registers(mb, start, length, words) == length) {
        NSData *d = [[NSData alloc] initWithBytes:words length:(length * 2)];
        return d;
    }
    else {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
        return nil;
    }
}

-(NSData*)readHoldingRegistersStartingAtAddress:(int)start withLength:(int)length withError:(NSError *__autoreleasing *)error {
    *error = nil;
    uint16_t words[length];
    if(modbus_read_registers(mb, start, length, words) == length) {
        NSData *d = [[NSData alloc] initWithBytes:words length:(length * 2)];
        return d;
    }
    else {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
        return nil;
    }
}

-(void)writeHoldingRegistersStartingAtAddress:(int)start withData:(NSData *)data withError:(NSError *__autoreleasing *)error {
    *error = nil;
    int length = ((int)[data length] / 2);
    uint16_t words[length];
    [data getBytes:&words length:[data length]];
    if(modbus_write_registers(mb, start, length, words) != length) {
        *error = [[NSError alloc] initWithDomain:ModbusTestErrorDomain
                                            code:errno
                                        userInfo:NULL];
    }
}


@end