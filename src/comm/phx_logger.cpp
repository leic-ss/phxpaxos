/*
Tencent is pleased to support the open source community by making 
PhxPaxos available.
Copyright (C) 2016 THL A29 Limited, a Tencent company. 
All rights reserved.

Licensed under the BSD 3-Clause License (the "License"); you may 
not use this file except in compliance with the License. You may 
obtain a copy of the License at

https://opensource.org/licenses/BSD-3-Clause

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" basis, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
implied. See the License for the specific language governing 
permissions and limitations under the License.

See the AUTHORS file for names of contributors. 
*/

#include "phx_logger.h"
#include <string>
#include <stdarg.h>
using namespace std;

namespace phxpaxos
{

PhxLogger :: PhxLogger()
    : m_pLogFunc(nullptr), m_eLogLevel(LogLevel::LogLevel_None)
{
}

PhxLogger :: ~PhxLogger()
{
}

PhxLogger * PhxLogger :: Instance()
{
    static PhxLogger oLogger;
    return &oLogger;
}

void PhxLogger :: InitLogger(const LogLevel eLogLevel)
{
    m_eLogLevel = eLogLevel;
}

void PhxLogger :: SetLogFunc(LogFunc pLogFunc)
{
    m_pLogFunc = pLogFunc;
}


void PhxLogger :: LogError(const char * pcFormat, ...)
{
    string newFormat = "\033[41;37m " + string(pcFormat) + " \033[0m";

    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Error), newFormat.c_str(), args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Error)
    {
        return;
    }

    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), newFormat.c_str(), args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}

void PhxLogger :: LogStatus(const char * pcFormat, ...)
{
    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Error), pcFormat, args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Error)
    {
        return;
    }

    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), pcFormat, args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}

void PhxLogger :: LogWarning(const char * pcFormat, ...)
{
    string newFormat = "\033[44;37m " + string(pcFormat) + " \033[0m";

    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Warning), newFormat.c_str(), args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Warning)
    {
        return;
    }
        
    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), newFormat.c_str(), args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}


void PhxLogger :: LogInfo(const char * pcFormat, ...)
{
    string newFormat = "\033[45;37m " + string(pcFormat) + " \033[0m";

    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Info), newFormat.c_str(), args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Info)
    {
        return;
    }
    
    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), newFormat.c_str(), args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}

void PhxLogger :: LogVerbose(const char * pcFormat, ...)
{
    string newFormat = "\033[45;37m " + string(pcFormat) + " \033[0m";

    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Verbose), newFormat.c_str(), args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Verbose)
    {
        return;
    }

    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), newFormat.c_str(), args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}

void PhxLogger :: LogShowy(const char * pcFormat, ...)
{
    string newFormat = "\033[45;37m " + string(pcFormat) + " \033[0m";

    if (m_pLogFunc != nullptr)
    {
        va_list args;
        va_start(args, pcFormat);
        m_pLogFunc(static_cast<int>(LogLevel::LogLevel_Verbose), newFormat.c_str(), args);
        va_end(args);
        return;
    }

    if (m_eLogLevel < LogLevel::LogLevel_Verbose)
    {
        return;
    }
    
    char sBuf[1024] = {0};
    va_list args;
    va_start(args, pcFormat);
    vsnprintf(sBuf, sizeof(sBuf), newFormat.c_str(), args);
    va_end(args);

    m_oMutex.lock();
    printf("%s\n", sBuf);
    m_oMutex.unlock();
}

}


