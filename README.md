## 프로그라피 iOS 10기  사전과제
- MVVM 활용하여 프로젝트 구성.
- Local DB의 경우 Core Data 활용.
- UIKit 프레임 워크를 사용하여 코드로 화면 전체 구성
- 주요 컴포넌트 배치는 Scroll View와 CollectionView 활용
- CollectionView 구현은 Diffable DataSource + Compositional Layou 조합으로 구성.
- 전반적으로 영화마다 텍스트 길이에 차이가 있어서 scrollView를 적극적으로 사용하여, 글자가 길어지더라도 대응할수 있도록 구현.
- 키보드 움직임에 따라 화면이 이동하는 부분은 Keyboard Layout Guide를 활용하여 구현
