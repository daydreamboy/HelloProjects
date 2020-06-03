#include "casc_pack.h"

using namespace MPM;

void CCascReqSiteApp::PackHead(std::string& strData)
{
    ResetOutBuff(strData);
    if(strData.size() < m_scHead.SizeExt())
        m_scHead.m_len = m_scHead.SizeExt() - m_scHead.Size();
    else
        m_scHead.m_len = strData.size() - m_scHead.Size();
    if(m_scHead.m_cmd == 0) m_scHead.m_cmd = CASC_REQ_SITE_APP;
    m_scHead.PackData(strData);
}

void CCascReqSiteApp::PackBody(std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetOutBuff(strData);
        strData.reserve(Size() + nOffset + 7);
        SetOutCursor(nOffset);
        (*this) << (uint8_t)5;
        (*this) << FT_STRING;
        (*this) << m_site;
        (*this) << FT_STRING;
        (*this) << m_appid;
        (*this) << FT_STRING;
        (*this) << m_reqData;
        (*this) << FT_UINT8;
        (*this) << m_needRsp;
        (*this) << FT_UINT8;
        (*this) << m_tryTimes;
    }
    catch(std::exception&)
    {
        strData = "";
    }
}

void CCascReqSiteApp::PackData(std::string& strData, const std::string& strKey)
{
    uint32_t nHeadLen = m_scHead.SizeExt();
    PackBody(strData, nHeadLen);
    uLongf falllen = strData.size() - nHeadLen;
    if(falllen > COMPRESS_THRESHOLD)
    {
        if(CompressData2(strData, nHeadLen))
            m_scHead.m_compress = 1;
    }

    FormData( nHeadLen );
    m_scHead.m_cc = CalcCheckCode(strData, nHeadLen);
    if(m_scHead.m_encrypt == 1 && !strKey.empty())
    {
//        CDesEncrypt des;
//        des.Encrypt(strData, strKey, m_scHead.SizeExt());
    }
    PackHead(strData);
}

PACKRETCODE CCascReqSiteApp::UnpackBody(const std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetInBuff(strData);
        SetInCursor( nOffset );
        uint8_t num;
        (*this) >> num;
        if(num < 3) return PACK_LENGTH_ERROR;
         CFieldType field;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_site;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_appid;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_reqData;
        try
        {
            if(num < 4) return PACK_RIGHT;
            (*this) >> field;
            if(field.m_baseType != FT_UINT8) return PACK_TYPEMATCH_ERROR;
            (*this) >> m_needRsp;
            if(num < 5) return PACK_RIGHT;
            (*this) >> field;
            if(field.m_baseType != FT_UINT8) return PACK_TYPEMATCH_ERROR;
            (*this) >> m_tryTimes;
        }
        catch(PACKRETCODE)
        {
            return PACK_RIGHT;
        }
    }
    catch(PACKRETCODE ret)
    {
        return ret;
    }
    catch(std::exception&)
    {
        return PACK_SYSTEM_ERROR;
    }
    return PACK_RIGHT;
}

PACKRETCODE CCascReqSiteApp::UnpackData(std::string& strData, const std::string& strKey)
{
    m_scHead.UnpackData(strData);
    uint32_t nHeadLen = m_scHead.SizeExt();
    if(m_scHead.m_encrypt == 1 && !strKey.empty())
    {
//        CDesEncrypt des;
//        des.Decrypt(strData, strKey, nHeadLen);
    }
    uint16_t checkCode = CalcCheckCode(strData, nHeadLen);
    if(checkCode != m_scHead.m_cc) return PACK_CHECKCODE_ERROR;
    if(m_scHead.m_compress == 1)
    {
        if(!UncompressData2(strData, nHeadLen)) return PACK_SYSTEM_ERROR;
    }
    return UnpackBody(strData, nHeadLen);
}

void CCascRspSiteApp::PackHead(std::string& strData)
{
    ResetOutBuff(strData);
    if(strData.size() < m_scHead.SizeExt())
        m_scHead.m_len = m_scHead.SizeExt() - m_scHead.Size();
    else
        m_scHead.m_len = strData.size() - m_scHead.Size();
    if(m_scHead.m_cmd == 0) m_scHead.m_cmd = CASC_RSP_SITE_APP;
    m_scHead.PackData(strData);
}

void CCascRspSiteApp::PackBody(std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetOutBuff(strData);
        strData.reserve(Size() + nOffset + 7);
        SetOutCursor(nOffset);
        (*this) << (uint8_t)5;
        (*this) << FT_UINT8;
        (*this) << m_retcode;
        (*this) << FT_STRING;
        (*this) << m_site;
        (*this) << FT_STRING;
        (*this) << m_appid;
        (*this) << FT_STRING;
        (*this) << m_reqData;
        (*this) << FT_STRING;
        (*this) << m_rspData;
    }
    catch(std::exception&)
    {
        strData = "";
    }
}

void CCascRspSiteApp::PackData(std::string& strData, const std::string& strKey)
{
    uint32_t nHeadLen = m_scHead.SizeExt();
    PackBody(strData, nHeadLen);
    uLongf falllen = strData.size() - nHeadLen;
    if(falllen > COMPRESS_THRESHOLD)
    {
        if(CompressData2(strData, nHeadLen))
            m_scHead.m_compress = 1;
    }

    FormData( nHeadLen );
    m_scHead.m_cc = CalcCheckCode(strData, nHeadLen);
    if(m_scHead.m_encrypt == 1 && !strKey.empty())
    {
//        CDesEncrypt des;
//        des.Encrypt(strData, strKey, m_scHead.SizeExt());
    }
    PackHead(strData);
}

PACKRETCODE CCascRspSiteApp::UnpackBody(const std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetInBuff(strData);
        SetInCursor( nOffset );
        uint8_t num;
        (*this) >> num;
        if(num < 5) return PACK_LENGTH_ERROR;
         CFieldType field;
        (*this) >> field;
        if(field.m_baseType != FT_UINT8) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_retcode;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_site;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_appid;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_reqData;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_rspData;
    }
    catch(PACKRETCODE ret)
    {
        return ret;
    }
    catch(std::exception&)
    {
        return PACK_SYSTEM_ERROR;
    }
    return PACK_RIGHT;
}

PACKRETCODE CCascRspSiteApp::UnpackData(std::string& strData, const std::string& strKey)
{
    m_scHead.UnpackData(strData);
    uint32_t nHeadLen = m_scHead.SizeExt();
    if(m_scHead.m_encrypt == 1 && !strKey.empty())
    {
//        CDesEncrypt des;
//        des.Decrypt(strData, strKey, nHeadLen);
    }
    uint16_t checkCode = CalcCheckCode(strData, nHeadLen);
    if(checkCode != m_scHead.m_cc) return PACK_CHECKCODE_ERROR;
    if(m_scHead.m_compress == 1)
    {
        //if(!UncompressData2(strData, nHeadLen)) return PACK_SYSTEM_ERROR;
        //if(!UncompressData1(strData, nHeadLen, 0)) return PACK_SYSTEM_ERROR;
        if(!UncompressData1_V2(strData, nHeadLen)) return PACK_SYSTEM_ERROR;
    }
    return UnpackBody(strData, nHeadLen);
}

