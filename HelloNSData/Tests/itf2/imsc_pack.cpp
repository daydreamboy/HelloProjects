#include "imsc_pack.h"

using namespace MPM;

void CImReqGetToken::PackHead(std::string& strData)
{
    ResetOutBuff(strData);
    if(strData.size() < m_scHead.SizeExt())
        m_scHead.m_len = m_scHead.SizeExt() - m_scHead.Size();
    else
        m_scHead.m_len = strData.size() - m_scHead.Size();
    if(m_scHead.m_cmd == 0) m_scHead.m_cmd = IM_REQ_GET_TOKEN;
    m_scHead.PackData(strData);
}

void CImReqGetToken::PackBody(std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetOutBuff(strData);
        strData.reserve(Size() + nOffset + 7);
        SetOutCursor(nOffset);
        (*this) << (uint8_t)2;
        (*this) << FT_UINT8;
        (*this) << m_type;
        (*this) << FT_STRING;
        (*this) << m_clientusedata;
    }
    catch(std::exception&)
    {
        strData = "";
    }
}

void CImReqGetToken::PackData(std::string& strData, const std::string& strKey)
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

PACKRETCODE CImReqGetToken::UnpackBody(const std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetInBuff(strData);
        SetInCursor( nOffset );
        uint8_t num;
        (*this) >> num;
        if(num < 2) return PACK_LENGTH_ERROR;
         CFieldType field;
        (*this) >> field;
        if(field.m_baseType != FT_UINT8) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_type;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_clientusedata;
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

PACKRETCODE CImReqGetToken::UnpackData(std::string& strData, const std::string& strKey)
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

void CImRspGetToken::PackHead(std::string& strData)
{
    ResetOutBuff(strData);
    if(strData.size() < m_scHead.SizeExt())
        m_scHead.m_len = m_scHead.SizeExt() - m_scHead.Size();
    else
        m_scHead.m_len = strData.size() - m_scHead.Size();
    if(m_scHead.m_cmd == 0) m_scHead.m_cmd = IM_RSP_GET_TOKEN;
    m_scHead.PackData(strData);
}

void CImRspGetToken::PackBody(std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetOutBuff(strData);
        strData.reserve(Size() + nOffset + 7);
        SetOutCursor(nOffset);
        (*this) << (uint8_t)4;
        (*this) << FT_UINT32;
        (*this) << m_retcode;
        (*this) << FT_UINT8;
        (*this) << m_type;
        (*this) << FT_STRING;
        (*this) << m_token;
        (*this) << FT_STRING;
        (*this) << m_clientusedata;
    }
    catch(std::exception&)
    {
        strData = "";
    }
}

void CImRspGetToken::PackData(std::string& strData, const std::string& strKey)
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

PACKRETCODE CImRspGetToken::UnpackBody(const std::string& strData, uint32_t nOffset)
{
    try
    {
        ResetInBuff(strData);
        SetInCursor( nOffset );
        uint8_t num;
        (*this) >> num;
        if(num < 4) return PACK_LENGTH_ERROR;
         CFieldType field;
        (*this) >> field;
        if(field.m_baseType != FT_UINT32) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_retcode;
        (*this) >> field;
        if(field.m_baseType != FT_UINT8) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_type;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_token;
        (*this) >> field;
        if(field.m_baseType != FT_STRING) return PACK_TYPEMATCH_ERROR;
        (*this) >> m_clientusedata;
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

PACKRETCODE CImRspGetToken::UnpackData(std::string& strData, const std::string& strKey)
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

