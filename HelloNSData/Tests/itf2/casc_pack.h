#ifndef __CASC_PACK_H__
#define __CASC_PACK_H__

#include <string>
#include "packdata.h"
#include "sc_head.h"
#include "mimsc_cmd.h"
#include "const_macro.h"

namespace MPM {
    class CCascReqSiteApp : public CPackData
    {
        public:
        enum
        {
            CMD_ID = CASC_REQ_SITE_APP
        };
        CCascReqSiteApp() : m_needRsp(1),
        m_tryTimes(1)
        {
        }
        
        ~CCascReqSiteApp() { }
        CCascReqSiteApp(const std::string& strSite, const std::string& strAppid, const std::string& strReqData, uint8_t chNeedRsp= 1, uint8_t chTryTimes= 1)
        {
            m_site = strSite;
            m_appid = strAppid;
            m_reqData = strReqData;
            m_needRsp = chNeedRsp;
            m_tryTimes = chTryTimes;
        }
        CCascReqSiteApp&  operator=( const CCascReqSiteApp&  cCascReqSiteApp )
        {
            m_site = cCascReqSiteApp.m_site;
            m_appid = cCascReqSiteApp.m_appid;
            m_reqData = cCascReqSiteApp.m_reqData;
            m_needRsp = cCascReqSiteApp.m_needRsp;
            m_tryTimes = cCascReqSiteApp.m_tryTimes;
            return *this;
        }
        
        const std::string&  GetSite () const { return m_site; }
        bool SetSite ( const std::string&  strSite )
        {
            m_site = strSite;
            return true;
        }
        const std::string&  GetAppid () const { return m_appid; }
        bool SetAppid ( const std::string&  strAppid )
        {
            m_appid = strAppid;
            return true;
        }
        const std::string&  GetReqData () const { return m_reqData; }
        bool SetReqData ( const std::string&  strReqData )
        {
            m_reqData = strReqData;
            return true;
        }
        const uint8_t&  GetNeedRsp () const { return m_needRsp; }
        bool SetNeedRsp ( const uint8_t&  chNeedRsp )
        {
            m_needRsp = chNeedRsp;
            return true;
        }
        const uint8_t&  GetTryTimes () const { return m_tryTimes; }
        bool SetTryTimes ( const uint8_t&  chTryTimes )
        {
            m_tryTimes = chTryTimes;
            return true;
        }
        private:
        std::string m_site;
        std::string m_appid;
        std::string m_reqData;
        uint8_t m_needRsp;
        uint8_t m_tryTimes;
        
        public:
        CScHead m_scHead;
        void PackHead(std::string& strData);
        void PackBody(std::string& strData, uint32_t nOffset);
        void PackData(std::string& strData, const std::string& strKey = "");
        PACKRETCODE UnpackBody(const std::string& strData, uint32_t nOffset);
        PACKRETCODE UnpackData(std::string& strData, const std::string& strKey = "");
        uint32_t Size() const;
    };
    
    inline uint32_t CCascReqSiteApp::Size() const
    {
        uint32_t nSize = 20;
        nSize += m_site.length();
        nSize += m_appid.length();
        nSize += m_reqData.length();
        return nSize;
    }
    
    class CCascRspSiteApp : public CPackData
    {
        public:
        enum
        {
            CMD_ID = CASC_RSP_SITE_APP
        };
        CCascRspSiteApp()
        {
        }
        
        ~CCascRspSiteApp() { }
        CCascRspSiteApp(uint8_t chRetcode, const std::string& strSite, const std::string& strAppid, const std::string& strReqData, const std::string& strRspData)
        {
            m_retcode = chRetcode;
            m_site = strSite;
            m_appid = strAppid;
            m_reqData = strReqData;
            m_rspData = strRspData;
        }
        CCascRspSiteApp&  operator=( const CCascRspSiteApp&  cCascRspSiteApp )
        {
            m_retcode = cCascRspSiteApp.m_retcode;
            m_site = cCascRspSiteApp.m_site;
            m_appid = cCascRspSiteApp.m_appid;
            m_reqData = cCascRspSiteApp.m_reqData;
            m_rspData = cCascRspSiteApp.m_rspData;
            return *this;
        }
        
        const uint8_t&  GetRetcode () const { return m_retcode; }
        bool SetRetcode ( const uint8_t&  chRetcode )
        {
            m_retcode = chRetcode;
            return true;
        }
        const std::string&  GetSite () const { return m_site; }
        bool SetSite ( const std::string&  strSite )
        {
            m_site = strSite;
            return true;
        }
        const std::string&  GetAppid () const { return m_appid; }
        bool SetAppid ( const std::string&  strAppid )
        {
            m_appid = strAppid;
            return true;
        }
        const std::string&  GetReqData () const { return m_reqData; }
        bool SetReqData ( const std::string&  strReqData )
        {
            m_reqData = strReqData;
            return true;
        }
        const std::string&  GetRspData () const { return m_rspData; }
        bool SetRspData ( const std::string&  strRspData )
        {
            m_rspData = strRspData;
            return true;
        }
        private:
        uint8_t m_retcode;
        std::string m_site;
        std::string m_appid;
        std::string m_reqData;
        std::string m_rspData;
        
        public:
        CScHead m_scHead;
        void PackHead(std::string& strData);
        void PackBody(std::string& strData, uint32_t nOffset);
        void PackData(std::string& strData, const std::string& strKey = "");
        PACKRETCODE UnpackBody(const std::string& strData, uint32_t nOffset);
        PACKRETCODE UnpackData(std::string& strData, const std::string& strKey = "");
        uint32_t Size() const;
    };
    
    inline uint32_t CCascRspSiteApp::Size() const
    {
        uint32_t nSize = 23;
        nSize += m_site.length();
        nSize += m_appid.length();
        nSize += m_reqData.length();
        nSize += m_rspData.length();
        return nSize;
    }

}
#endif
