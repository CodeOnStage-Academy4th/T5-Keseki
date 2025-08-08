# Keseki

<p align="center">
  <img src="https://github.com/user-attachments/assets/fe146634-7d16-4119-875a-dd54eb2bbfd2" alt="Keseki App Icon" width="300" />
</p>

## 소개
**Keseki**는 아침 알람 소리에 짜증이 나는 사용자를 위해 설계된 특별한 알람 앱입니다.  
이 앱은 사용자가 **소리를 질러야만** 알람이 꺼지도록 하여,  
짜증을 해소하면서 동시에 빠르게 잠에서 깰 수 있도록 돕습니다.  

> **"소리를 질러서 끄는 알람"**


---

## 주요 기능 (Feature List)

1. **데시벨 측정**
    - 단어 인식이 아닌, 단순히 소리 크기(데시벨) 감지
2. **알람 시간 예약**
    - 원하는 시간에 알람 설정 가능
3. **알람 강도 점진적 증가**
    - 점점 더 강한 소리로 사용자를 깨움 (예: 멍멍 → 왈왈 → 쾅콰왘와!)  
4. **알람 종료**
    - 일정 데시벨 이상의 소리를 내면 알람 자동 종료
5. **화면 잠금시**
    - 잠금 화면 알림 및 알림 소리 유지
      

---

## 앱 구조 개요
- **플랫폼**: iOS (SwiftUI,UIkit)
- **주요 폴더**
    - `Alarm`: 음원변경 (AVFAudio)
    - `DecibelMeter`: 데시벨 측정 및 마이크 권한설정 알람 설정 (AVFoundation)
    - `Home`: HomeView 및 HomeViewModel 그 외 Component
    - `LockNotification`: 알림 권한설정 (UserNotifications)
    

---

## 팀
- 팀명: The Merge Conflicts
- 팀구호: 브랜치는 달라도, 목표는 하나!
- 팀원:
    - [Presence] – PM
    - [Nell] – TECH
    - [HappyJay] – TECH
    - [Pherd] – TECH
    - [Yan] – DESIGN
    - [Yuu] – DESIGN

    

---

## 라이선스
- MIT License
