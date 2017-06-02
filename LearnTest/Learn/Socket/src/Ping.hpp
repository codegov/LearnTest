//
//  Ping.hpp
//  LearnTest
//
//  Created by javalong on 2017/6/1.
//  Copyright © 2017年 com.chanjet. All rights reserved.
//

#ifndef Ping_hpp
#define Ping_hpp

#include <stdio.h>

class Ping
{
public:
    int pingImp();
private:
    int ping(int count, int interval/*S*/, int timeout/*S*/, const char *dest, unsigned int packetSize);
};

#endif /* Ping_hpp */
