#include "sc_head.h"

using namespace MPM;

CPackData& operator<< ( CPackData& cPackData, const SUserGroup&  sUserGroup )
{
    uint8_t nFieldNum = 3;
    cPackData << nFieldNum;
    cPackData << FT_INT64;
    cPackData << sUserGroup.m_groupId;
    cPackData << FT_INT64;
    cPackData << sUserGroup.m_parentId;
    cPackData << FT_STRING;
    cPackData << sUserGroup.m_groupName;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SUserGroup&  sUserGroup )
{
    uint8_t num;
    cPackData >> num;
    if(num < 3) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserGroup.m_groupId;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserGroup.m_parentId;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserGroup.m_groupName;
    for(int i = 3; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

CPackData& operator<< ( CPackData& cPackData, const SUserChggroup&  sUserChggroup )
{
    uint8_t nFieldNum = 4;
    cPackData << nFieldNum;
    cPackData << FT_UINT64;
    cPackData << sUserChggroup.m_mask;
    cPackData << FT_INT64;
    cPackData << sUserChggroup.m_groupId;
    cPackData << FT_INT64;
    cPackData << sUserChggroup.m_parentId;
    cPackData << FT_STRING;
    cPackData << sUserChggroup.m_groupName;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SUserChggroup&  sUserChggroup )
{
    uint8_t num;
    cPackData >> num;
    if(num < 4) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_UINT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserChggroup.m_mask;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserChggroup.m_groupId;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserChggroup.m_parentId;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sUserChggroup.m_groupName;
    for(int i = 4; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

CPackData& operator<< ( CPackData& cPackData, const SDelGroup&  sDelGroup )
{
    uint8_t nFieldNum = 2;
    cPackData << nFieldNum;
    cPackData << FT_UINT32;
    cPackData << sDelGroup.m_retcode;
    cPackData << FT_INT64;
    cPackData << sDelGroup.m_groupId;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SDelGroup&  sDelGroup )
{
    uint8_t num;
    cPackData >> num;
    if(num < 2) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_UINT32) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sDelGroup.m_retcode;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sDelGroup.m_groupId;
    for(int i = 2; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

CPackData& operator<< ( CPackData& cPackData, const SContactInfo&  sContactInfo )
{
    uint8_t nFieldNum = 6;
    do {
        if(sContactInfo.m_tag == 0xf000)
            nFieldNum--;
        else
            break;
    } while(0);
    cPackData << nFieldNum;
    cPackData << FT_STRING;
    cPackData << sContactInfo.m_contactId;
    cPackData << FT_STRING;
    cPackData << sContactInfo.m_nickName;
    cPackData << FT_STRING;
    cPackData << sContactInfo.m_md5Phone;
    cPackData << FT_STRING;
    cPackData << sContactInfo.m_importance;
    cPackData << FT_INT64;
    cPackData << sContactInfo.m_groupId;
    if(nFieldNum == 5) return cPackData;
    cPackData << FT_INT32;
    cPackData << sContactInfo.m_tag;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SContactInfo&  sContactInfo )
{
    uint8_t num;
    cPackData >> num;
    if(num < 5) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sContactInfo.m_contactId;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sContactInfo.m_nickName;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sContactInfo.m_md5Phone;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sContactInfo.m_importance;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sContactInfo.m_groupId;
    try
    {
        if(num < 6) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_INT32) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sContactInfo.m_tag;
    }
    catch(PACKRETCODE)
    {
        return cPackData;
    }
    for(int i = 6; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

CPackData& operator<< ( CPackData& cPackData, const SChgContactInfo&  sChgContactInfo )
{
    uint8_t nFieldNum = 5;
    cPackData << nFieldNum;
    cPackData << FT_INT64;
    cPackData << sChgContactInfo.m_mask;
    cPackData << FT_STRING;
    cPackData << sChgContactInfo.m_contactId;
    cPackData << FT_STRING;
    cPackData << sChgContactInfo.m_nickName;
    cPackData << FT_STRING;
    cPackData << sChgContactInfo.m_importance;
    cPackData << FT_INT64;
    cPackData << sChgContactInfo.m_groupId;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SChgContactInfo&  sChgContactInfo )
{
    uint8_t num;
    cPackData >> num;
    if(num < 5) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sChgContactInfo.m_mask;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sChgContactInfo.m_contactId;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sChgContactInfo.m_nickName;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sChgContactInfo.m_importance;
    cPackData >> field;
    if(field.m_baseType != FT_INT64) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sChgContactInfo.m_groupId;
    for(int i = 5; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

CPackData& operator<< ( CPackData& cPackData, const SLatentContact&  sLatentContact )
{
    uint8_t nFieldNum = 8;
    cPackData << nFieldNum;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_contactId;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_nickName;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_md5Phone;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_reason;
    cPackData << FT_INT32;
    cPackData << sLatentContact.m_distance;
    cPackData << FT_INT32;
    cPackData << sLatentContact.m_gender;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_avatarurl;
    cPackData << FT_STRING;
    cPackData << sLatentContact.m_signature;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SLatentContact&  sLatentContact )
{
    uint8_t num;
    cPackData >> num;
    if(num < 8) throw PACK_LENGTH_ERROR;
    CFieldType field;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_contactId;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_nickName;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_md5Phone;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_reason;
    cPackData >> field;
    if(field.m_baseType != FT_INT32) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_distance;
    cPackData >> field;
    if(field.m_baseType != FT_INT32) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_gender;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_avatarurl;
    cPackData >> field;
    if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
    cPackData >> sLatentContact.m_signature;
    for(int i = 8; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

void CScHead::PackData(std::string& strData)
{
    try
    {
        ResetOutBuff(strData);
        m_lrc = 0;
        (*this) << m_starter;
        (*this) << m_major;
        (*this) << m_minor;
        (*this) << m_msgtype;
        (*this) << m_encrypt;
        (*this) << m_compress;
        (*this) << m_encode;
        (*this) << m_lrc;
        (*this) << m_seq;
        (*this) << m_len;
        (*this) << m_cmd;
        (*this) << m_cc;
        (*this) << m_reserved;
        if((m_reserved & 0x01) == 1)
        {
            (*this) << m_extdata;
        }
        m_lrc = CalcLrc(strData, Size());
        SetOutCursor(7);
        (*this) << m_lrc;
    }
    catch(std::exception&)
    {
        strData = "";
    }
}

PACKRETCODE CScHead::UnpackData(const std::string& strData)
{
    try
    {
        ResetInBuff(strData);
        if(CalcLrc(strData, Size()) != 0) return PACK_INVALID;
        (*this) >> m_starter;
        (*this) >> m_major;
        (*this) >> m_minor;
        (*this) >> m_msgtype;
        (*this) >> m_encrypt;
        (*this) >> m_compress;
        (*this) >> m_encode;
        (*this) >> m_lrc;
        (*this) >> m_seq;
        (*this) >> m_len;
        (*this) >> m_cmd;
        (*this) >> m_cc;
        (*this) >> m_reserved;
        if((m_reserved & 0x01) == 1)
        {
            (*this) >> m_extdata;
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

CPackData& operator<< ( CPackData& cPackData, const SScUserInfo&  sScUserInfo )
{
    uint8_t nFieldNum = 5;
    do {
        if(sScUserInfo.m_uuid == 0)
            nFieldNum--;
        else
            break;
        if(sScUserInfo.m_notifyAppId == 0)
            nFieldNum--;
        else
            break;
        if(sScUserInfo.m_bizId == 0)
            nFieldNum--;
        else
            break;
        if(sScUserInfo.m_fromApp == 0)
            nFieldNum--;
        else
            break;
        if(sScUserInfo.m_userId == "")
            nFieldNum--;
        else
            break;
    } while(0);
    cPackData << nFieldNum;
    if(nFieldNum == 0) return cPackData;
    cPackData << FT_STRING;
    cPackData << sScUserInfo.m_userId;
    if(nFieldNum == 1) return cPackData;
    cPackData << FT_UINT32;
    cPackData << sScUserInfo.m_fromApp;
    if(nFieldNum == 2) return cPackData;
    cPackData << FT_UINT32;
    cPackData << sScUserInfo.m_bizId;
    if(nFieldNum == 3) return cPackData;
    cPackData << FT_UINT32;
    cPackData << sScUserInfo.m_notifyAppId;
    if(nFieldNum == 4) return cPackData;
    cPackData << FT_UINT64;
    cPackData << sScUserInfo.m_uuid;

    return cPackData;

}

CPackData& operator>> ( CPackData& cPackData, SScUserInfo&  sScUserInfo )
{
    uint8_t num;
    try
    {
        cPackData >> num;
        CFieldType field;
        if(num < 1) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_STRING) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sScUserInfo.m_userId;
        if(num < 2) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_UINT32) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sScUserInfo.m_fromApp;
        if(num < 3) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_UINT32) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sScUserInfo.m_bizId;
        if(num < 4) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_UINT32) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sScUserInfo.m_notifyAppId;
        if(num < 5) return cPackData;
        cPackData >> field;
        if(field.m_baseType != FT_UINT64) throw PACK_TYPEMATCH_ERROR;
        cPackData >> sScUserInfo.m_uuid;
    }
    catch(PACKRETCODE)
    {
        return cPackData;
    }
    for(int i = 5; i < num; i++)
        cPackData.PeekField();
    return cPackData;
}

