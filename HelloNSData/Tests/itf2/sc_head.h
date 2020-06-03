#ifndef __SC_HEAD_H__
#define __SC_HEAD_H__

#include <string>
#include "packdata.h"
#include "const_macro.h"

#ifndef COMPRESS_THRESHOLD
#define COMPRESS_THRESHOLD 10240
#endif

namespace MPM {
    struct SUserGroup
    {
        public:
        SUserGroup()
        {
        }
        
        ~SUserGroup() { }
        SUserGroup(int64_t llGroupId, int64_t llParentId, const std::string& strGroupName)
        {
            m_groupId = llGroupId;
            m_parentId = llParentId;
            m_groupName = strGroupName;
        }
        SUserGroup&  operator=( const SUserGroup&  sUserGroup )
        {
            m_groupId = sUserGroup.m_groupId;
            m_parentId = sUserGroup.m_parentId;
            m_groupName = sUserGroup.m_groupName;
            return *this;
        }
        
        int64_t m_groupId;
        int64_t m_parentId;
        std::string m_groupName;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SUserGroup::Size() const
    {
        uint32_t nSize = 24;
        nSize += m_groupName.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SUserGroup&  sUserGroup );
    CPackData& operator>> ( CPackData& cPackData, SUserGroup&  sUserGroup );
    
    struct SUserChggroup
    {
        public:
        SUserChggroup()
        {
        }
        
        ~SUserChggroup() { }
        SUserChggroup(uint64_t ullMask, int64_t llGroupId, int64_t llParentId, const std::string& strGroupName)
        {
            m_mask = ullMask;
            m_groupId = llGroupId;
            m_parentId = llParentId;
            m_groupName = strGroupName;
        }
        SUserChggroup&  operator=( const SUserChggroup&  sUserChggroup )
        {
            m_mask = sUserChggroup.m_mask;
            m_groupId = sUserChggroup.m_groupId;
            m_parentId = sUserChggroup.m_parentId;
            m_groupName = sUserChggroup.m_groupName;
            return *this;
        }
        
        uint64_t m_mask;
        int64_t m_groupId;
        int64_t m_parentId;
        std::string m_groupName;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SUserChggroup::Size() const
    {
        uint32_t nSize = 33;
        nSize += m_groupName.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SUserChggroup&  sUserChggroup );
    CPackData& operator>> ( CPackData& cPackData, SUserChggroup&  sUserChggroup );
    
    struct SDelGroup
    {
        public:
        SDelGroup()
        {
        }
        
        ~SDelGroup() { }
        SDelGroup(uint32_t dwRetcode, int64_t llGroupId)
        {
            m_retcode = dwRetcode;
            m_groupId = llGroupId;
        }
        SDelGroup&  operator=( const SDelGroup&  sDelGroup )
        {
            m_retcode = sDelGroup.m_retcode;
            m_groupId = sDelGroup.m_groupId;
            return *this;
        }
        
        uint32_t m_retcode;
        int64_t m_groupId;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SDelGroup::Size() const
    {
        return 15;
    }
    CPackData& operator<< ( CPackData& cPackData, const SDelGroup&  sDelGroup );
    CPackData& operator>> ( CPackData& cPackData, SDelGroup&  sDelGroup );
    
    struct SContactInfo
    {
        public:
        SContactInfo() : m_tag(0xf000)
        {
        }
        
        ~SContactInfo() { }
        SContactInfo(const std::string& strContactId, const std::string& strNickName, const std::string& strMd5Phone, const std::string& strImportance, int64_t llGroupId, int32_t lTag= 0xf000)
        {
            m_contactId = strContactId;
            m_nickName = strNickName;
            m_md5Phone = strMd5Phone;
            m_importance = strImportance;
            m_groupId = llGroupId;
            m_tag = lTag;
        }
        SContactInfo&  operator=( const SContactInfo&  sContactInfo )
        {
            m_contactId = sContactInfo.m_contactId;
            m_nickName = sContactInfo.m_nickName;
            m_md5Phone = sContactInfo.m_md5Phone;
            m_importance = sContactInfo.m_importance;
            m_groupId = sContactInfo.m_groupId;
            m_tag = sContactInfo.m_tag;
            return *this;
        }
        
        std::string m_contactId;
        std::string m_nickName;
        std::string m_md5Phone;
        std::string m_importance;
        int64_t m_groupId;
        int32_t m_tag;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SContactInfo::Size() const
    {
        uint32_t nSize = 35;
        nSize += m_contactId.length();
        nSize += m_nickName.length();
        nSize += m_md5Phone.length();
        nSize += m_importance.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SContactInfo&  sContactInfo );
    CPackData& operator>> ( CPackData& cPackData, SContactInfo&  sContactInfo );
    
    struct SChgContactInfo
    {
        public:
        SChgContactInfo()
        {
        }
        
        ~SChgContactInfo() { }
        SChgContactInfo(int64_t llMask, const std::string& strContactId, const std::string& strNickName, const std::string& strImportance, int64_t llGroupId)
        {
            m_mask = llMask;
            m_contactId = strContactId;
            m_nickName = strNickName;
            m_importance = strImportance;
            m_groupId = llGroupId;
        }
        SChgContactInfo&  operator=( const SChgContactInfo&  sChgContactInfo )
        {
            m_mask = sChgContactInfo.m_mask;
            m_contactId = sChgContactInfo.m_contactId;
            m_nickName = sChgContactInfo.m_nickName;
            m_importance = sChgContactInfo.m_importance;
            m_groupId = sChgContactInfo.m_groupId;
            return *this;
        }
        
        int64_t m_mask;
        std::string m_contactId;
        std::string m_nickName;
        std::string m_importance;
        int64_t m_groupId;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SChgContactInfo::Size() const
    {
        uint32_t nSize = 34;
        nSize += m_contactId.length();
        nSize += m_nickName.length();
        nSize += m_importance.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SChgContactInfo&  sChgContactInfo );
    CPackData& operator>> ( CPackData& cPackData, SChgContactInfo&  sChgContactInfo );
    
    struct SLatentContact
    {
        public:
        SLatentContact()
        {
        }
        
        ~SLatentContact() { }
        SLatentContact(const std::string& strContactId, const std::string& strNickName, const std::string& strMd5Phone, const std::string& strReason, int32_t lDistance, int32_t lGender, const std::string& strAvatarurl, const std::string& strSignature)
        {
            m_contactId = strContactId;
            m_nickName = strNickName;
            m_md5Phone = strMd5Phone;
            m_reason = strReason;
            m_distance = lDistance;
            m_gender = lGender;
            m_avatarurl = strAvatarurl;
            m_signature = strSignature;
        }
        SLatentContact&  operator=( const SLatentContact&  sLatentContact )
        {
            m_contactId = sLatentContact.m_contactId;
            m_nickName = sLatentContact.m_nickName;
            m_md5Phone = sLatentContact.m_md5Phone;
            m_reason = sLatentContact.m_reason;
            m_distance = sLatentContact.m_distance;
            m_gender = sLatentContact.m_gender;
            m_avatarurl = sLatentContact.m_avatarurl;
            m_signature = sLatentContact.m_signature;
            return *this;
        }
        
        std::string m_contactId;
        std::string m_nickName;
        std::string m_md5Phone;
        std::string m_reason;
        int32_t m_distance;
        int32_t m_gender;
        std::string m_avatarurl;
        std::string m_signature;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SLatentContact::Size() const
    {
        uint32_t nSize = 41;
        nSize += m_contactId.length();
        nSize += m_nickName.length();
        nSize += m_md5Phone.length();
        nSize += m_reason.length();
        nSize += m_avatarurl.length();
        nSize += m_signature.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SLatentContact&  sLatentContact );
    CPackData& operator>> ( CPackData& cPackData, SLatentContact&  sLatentContact );
    
    class CScHead : public CPackData
    {
        public:
        CScHead() : m_starter(0x88),
        m_major(0x06),
        m_minor(0x00),
        m_msgtype(0),
        m_encrypt(0x01),
        m_compress(0),
        m_encode(0),
        m_lrc(0),
        m_seq(0),
        m_len(0),
        m_cmd(0),
        m_cc(0),
        m_reserved(0)
        {
        }
        
        ~CScHead() { }
        CScHead(uint8_t chStarter, uint8_t chMajor, uint8_t chMinor, uint8_t chMsgtype, uint8_t chEncrypt, uint8_t chCompress, uint8_t chEncode, uint8_t chLrc, uint32_t dwSeq, uint32_t dwLen, uint32_t dwCmd, uint16_t wCc, uint16_t wReserved, const std::string& strExtdata)
        {
            m_starter = chStarter;
            m_major = chMajor;
            m_minor = chMinor;
            m_msgtype = chMsgtype;
            m_encrypt = chEncrypt;
            m_compress = chCompress;
            m_encode = chEncode;
            m_lrc = chLrc;
            m_seq = dwSeq;
            m_len = dwLen;
            m_cmd = dwCmd;
            m_cc = wCc;
            m_reserved = wReserved;
            m_extdata = strExtdata;
        }
        CScHead&  operator=( const CScHead&  cScHead )
        {
            m_starter = cScHead.m_starter;
            m_major = cScHead.m_major;
            m_minor = cScHead.m_minor;
            m_msgtype = cScHead.m_msgtype;
            m_encrypt = cScHead.m_encrypt;
            m_compress = cScHead.m_compress;
            m_encode = cScHead.m_encode;
            m_lrc = cScHead.m_lrc;
            m_seq = cScHead.m_seq;
            m_len = cScHead.m_len;
            m_cmd = cScHead.m_cmd;
            m_cc = cScHead.m_cc;
            m_reserved = cScHead.m_reserved;
            m_extdata = cScHead.m_extdata;
            return *this;
        }
        
        public:
        uint8_t m_starter;
        uint8_t m_major;
        uint8_t m_minor;
        uint8_t m_msgtype;
        uint8_t m_encrypt;
        uint8_t m_compress;
        uint8_t m_encode;
        uint8_t m_lrc;
        uint32_t m_seq;
        uint32_t m_len;
        uint32_t m_cmd;
        uint16_t m_cc;
        uint16_t m_reserved;
        std::string m_extdata;
        
        public:
        void PackData(std::string& strData);
        PACKRETCODE UnpackData(const std::string& strData);
        uint32_t SizeExt() const
        {
            if((m_reserved & 0x01) == 1)
            {
                uint32_t nSize = 28;
                nSize += m_extdata.length();
                return nSize;
            }
            else
            return 24;
        }
        uint32_t PeekSize()
        {
            uint32_t nSize = 24;
            if((PeekReserved() & 0x01) == 1)
            {
                {
                    SetInCursor(nSize);
                    uint32_t len;
                    (*this) >> len;
                    nSize += len + 4;
                }
            }
            return nSize;
        }
        uint32_t Size() const { return 24; }
        uint8_t PeekStarter()
        {
            uint8_t chStarter;
            SetInCursor(0);
            *this >> chStarter;
            return chStarter;
        }
        uint8_t PeekMajor()
        {
            uint8_t chMajor;
            SetInCursor(1);
            *this >> chMajor;
            return chMajor;
        }
        uint8_t PeekMinor()
        {
            uint8_t chMinor;
            SetInCursor(2);
            *this >> chMinor;
            return chMinor;
        }
        uint8_t PeekMsgtype()
        {
            uint8_t chMsgtype;
            SetInCursor(3);
            *this >> chMsgtype;
            return chMsgtype;
        }
        uint8_t PeekEncrypt()
        {
            uint8_t chEncrypt;
            SetInCursor(4);
            *this >> chEncrypt;
            return chEncrypt;
        }
        uint8_t PeekCompress()
        {
            uint8_t chCompress;
            SetInCursor(5);
            *this >> chCompress;
            return chCompress;
        }
        uint8_t PeekEncode()
        {
            uint8_t chEncode;
            SetInCursor(6);
            *this >> chEncode;
            return chEncode;
        }
        uint8_t PeekLrc()
        {
            uint8_t chLrc;
            SetInCursor(7);
            *this >> chLrc;
            return chLrc;
        }
        uint32_t PeekSeq()
        {
            uint32_t dwSeq;
            SetInCursor(8);
            *this >> dwSeq;
            return dwSeq;
        }
        uint32_t PeekLen()
        {
            uint32_t dwLen;
            SetInCursor(12);
            *this >> dwLen;
            return dwLen;
        }
        uint32_t PeekCmd()
        {
            uint32_t dwCmd;
            SetInCursor(16);
            *this >> dwCmd;
            return dwCmd;
        }
        uint16_t PeekCc()
        {
            uint16_t wCc;
            SetInCursor(20);
            *this >> wCc;
            return wCc;
        }
        uint16_t PeekReserved()
        {
            uint16_t wReserved;
            SetInCursor(22);
            *this >> wReserved;
            return wReserved;
        }
    };
    
    struct SScUserInfo
    {
        public:
        ~SScUserInfo() { }
        SScUserInfo(const std::string& strUserId= "", uint32_t dwFromApp= 0, uint32_t dwBizId= 0, uint32_t dwNotifyAppId= 0, uint64_t ullUuid= 0)
        {
            m_userId = strUserId;
            m_fromApp = dwFromApp;
            m_bizId = dwBizId;
            m_notifyAppId = dwNotifyAppId;
            m_uuid = ullUuid;
        }
        SScUserInfo&  operator=( const SScUserInfo&  sScUserInfo )
        {
            m_userId = sScUserInfo.m_userId;
            m_fromApp = sScUserInfo.m_fromApp;
            m_bizId = sScUserInfo.m_bizId;
            m_notifyAppId = sScUserInfo.m_notifyAppId;
            m_uuid = sScUserInfo.m_uuid;
            return *this;
        }
        
        std::string m_userId;
        uint32_t m_fromApp;
        uint32_t m_bizId;
        uint32_t m_notifyAppId;
        uint64_t m_uuid;
        
        public:
        uint32_t Size() const;
    };
    
    inline uint32_t SScUserInfo::Size() const
    {
        uint32_t nSize = 30;
        nSize += m_userId.length();
        return nSize;
    }
    
    CPackData& operator<< ( CPackData& cPackData, const SScUserInfo&  sScUserInfo );
    CPackData& operator>> ( CPackData& cPackData, SScUserInfo&  sScUserInfo );

}

#endif
