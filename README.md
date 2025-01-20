# ForLong-frontend
프론트앤드 개발

## gitflow 전략 사용
![image](https://github.com/user-attachments/assets/c4013333-66a3-4870-a42c-79c993a6c703)

## main 브랜치 :

최종 프로덕트 용 브랜치(배포용), 최대한 완벽한 것만 올리는 브랜치로 2주 간격으로 올릴 예정

## develop 브랜치 :

개발자가 자유롭게 개발하는 브랜치(테스트), 실직적으로 개인이 개발한 후 Push후 Pull Requests 하는 공간

# git 협업 규칙

## main 브랜치 규칙

main 브랜치는 함부로 접근 및 Push 할 수 없고 PR할 경우 2명에게 승인을 받아야 한다.

## develop 브랜치 규칙

develop 브랜치는 PR할 경우 2명에게 승인을 받아야 한다. 개인 브랜치에서 작업 하고 해당 담당자가 PR

### develop에 PR 요청하기

1. 상단 Pull requests 누르기
2. New pull requests 누르기
3. base: develop ← compare: 내 브랜치로 설정하고 Create pull requests 누르기
4. Write 작성하기
5. 코드 리뷰 받기

    1. 문제가 있다면 해당 코드에 메세지 남기거나 연락하기. 문제가 없다면 코드 리뷰 하는 사람이 approve누르기
    2. 코드 리뷰 하는 사람이 Finish your review를 눌러 해당하는 사항 누르기
    3. 수정할 것이 있다면 수정 된 파일을 개인 브랜치에 다시 올리기(코드가 바뀌면 complain 메세지가 사라짐)
    4. 코드 작성자가 Merge pull request를 누르기

## 협업 규칙

1. commit은 기능 단위로 짧게 끊어서 commit한다. 만약 여러 작업(기능 추가, 디버그 등)을 했다면 한꺼번에 add를 하지 말고 같은 작업 파일을 묶어서 add를 한 후 commit하기
2. PR까지 완료한 후 팀원에게 pull하라고 알리기
3. 문제가 생기면 혼자서 해결하려고 하지 말고 반드시 팀원에게 알리기

## 기능 추가 메뉴얼

1. 이슈 생성
2. 로컬에서 기능에 대한 브랜치 생성 ex) 브랜치 이름 : feature/(기능이름)

```bash
git branch 브랜치이름
git checkout 브랜치이름
git push --set-upstream origin 브랜치이름 # 원격에 로컬 브랜치에 해당하는 브랜치 생성 후 연결


```

1. 해당 이슈 들어가서 development 톱니바퀴 클릭
2. 리포 선택 → 브랜치 선택
3. 완료
  
[//]: # (=======)

[//]: # (# forlong)

[//]: # ()
[//]: # (A new Flutter project.)

[//]: # ()
[//]: # (## Getting Started)

[//]: # ()
[//]: # (This project is a starting point for a Flutter application.)

[//]: # ()
[//]: # (A few resources to get you started if this is your first Flutter project:)

[//]: # ()
[//]: # (- [Lab: Write your first Flutter app]&#40;https://docs.flutter.dev/get-started/codelab&#41;)

[//]: # (- [Cookbook: Useful Flutter samples]&#40;https://docs.flutter.dev/cookbook&#41;)

[//]: # ()
[//]: # (For help getting started with Flutter development, view the)

[//]: # ([online documentation]&#40;https://docs.flutter.dev/&#41;, which offers tutorials,)

[//]: # (samples, guidance on mobile development, and a full API reference.)

[//]: # (>>>>>>> 9af50f9 &#40;예약기능 ui 개발&#41;)
