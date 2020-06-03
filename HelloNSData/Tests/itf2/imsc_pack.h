#ifndef __IMSC_PACK_H__
#define __IMSC_PACK_H__

#include <string>
#include "packdata.h"
#include "const_macro.h"
#include "sc_head.h"
#include "mimsc_cmd.h"

#ifndef STATUSDEF_LENGTH
#define STATUSDEF_LENGTH 64
#endif 

namespace MPM {
    class CImReqGetToken : public CPackData
    {
        public:
        enum
        {
            CMD_ID = IM_REQ_GET_TOKEN
        };
        CImReqGetToken()
        {
        }
        
        ~CImReqGetToken() { }
        CImReqGetToken(uint8_t chType, const std::string& strClientusedata)
        {
            m_type = chType;
            m_clientusedata = strClientusedata;
        }
        CImReqGetToken&  operator=( const CImReqGetToken&  cImReqGetToken )
        {
            m_type = cImReqGetToken.m_type;
            m_clientusedata = cImReqGetToken.m_clientusedata;
            return *this;
        }
        
        const uint8_t&  GetType () const { return m_type; }
        bool SetType ( const uint8_t&  chType )
        {
            m_type = chType;
            return true;
        }
        const std::string&  GetClientusedata () const { return m_clientusedata; }
        bool SetClientusedata ( const std::string&  strClientusedata )
        {
            m_clientusedata = strClientusedata;
            return true;
        }
        private:
        uint8_t m_type;
        std::string m_clientusedata;
        
        public:
        CScHead m_scHead;
        void PackHead(std::string& strData);
        void PackBody(std::string& strData, uint32_t nOffset);
        void PackData(std::string& strData, const std::string& strKey = "");
        PACKRETCODE UnpackBody(const std::string& strData, uint32_t nOffset);
        PACKRETCODE UnpackData(std::string& strData, const std::string& strKey = "");
        uint32_t Size() const;
    };
    
    inline uint32_t CImReqGetToken::Size() const
    {
        uint32_t nSize = 8;
        nSize += m_clientusedata.length();
        return nSize;
    }
    
    class CImRspGetToken : public CPackData
    {
        public:
        enum
        {
            CMD_ID = IM_RSP_GET_TOKEN
        };
        CImRspGetToken()
        {
        }
        
        ~CImRspGetToken() { }
        CImRspGetToken(uint32_t dwRetcode, uint8_t chType, const std::string& strToken, const std::string& strClientusedata)
        {
            m_retcode = dwRetcode;
            m_type = chType;
            m_token = strToken;
            m_clientusedata = strClientusedata;
        }
        CImRspGetToken&  operator=( const CImRspGetToken&  cImRspGetToken )
        {
            m_retcode = cImRspGetToken.m_retcode;
            m_type = cImRspGetToken.m_type;
            m_token = cImRspGetToken.m_token;
            m_clientusedata = cImRspGetToken.m_clientusedata;
            return *this;
        }
        
        const uint32_t&  GetRetcode () const { return m_retcode; }
        bool SetRetcode ( const uint32_t&  dwRetcode )
        {
            m_retcode = dwRetcode;
            return true;
        }
        const uint8_t&  GetType () const { return m_type; }
        bool SetType ( const uint8_t&  chType )
        {
            m_type = chType;
            return true;
        }
        const std::string&  GetToken () const { return m_token; }
        bool SetToken ( const std::string&  strToken )
        {
            m_token = strToken;
            return true;
        }
        const std::string&  GetClientusedata () const { return m_clientusedata; }
        bool SetClientusedata ( const std::string&  strClientusedata )
        {
            m_clientusedata = strClientusedata;
            return true;
        }
        private:
        uint32_t m_retcode;
        uint8_t m_type;
        std::string m_token;
        std::string m_clientusedata;
        
        public:
        CScHead m_scHead;
        void PackHead(std::string& strData);
        void PackBody(std::string& strData, uint32_t nOffset);
        void PackData(std::string& strData, const std::string& strKey = "");
        PACKRETCODE UnpackBody(const std::string& strData, uint32_t nOffset);
        PACKRETCODE UnpackData(std::string& strData, const std::string& strKey = "");
        uint32_t Size() const;
    };
    
    inline uint32_t CImRspGetToken::Size() const
    {
        uint32_t nSize = 18;
        nSize += m_token.length();
        nSize += m_clientusedata.length();
        return nSize;
    }
}

#endif
