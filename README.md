## 프로그라피 iOS 10기  사전과제
- MVVM 활용하여 프로젝트 구성했습니다. ViewModel의 경우 https://github.com/Jimmy-Jung/JimmyKit -> 이 개발자분의 구현방식을 보고 차용해서 사용했습니다.
- 기존 뷰모델을 사용할때 주로 많이 사용하는 input -> output 방식에서 좀더 세분화해서, input마다 여러개의 다른 action을 취하도록 구성할수 있어 좋다고 판단하여, 이 프로젝트 뿐만 아니라,
- 다른 프로젝트를 진행할때도 채택해서 사용하고 있습니다.

- Local DB의 경우 Core Data 활용했습니다. Realm을 사용할까도 고민했으나, 조금 더안정성을 챙기기 위해 Core Data를 활용하여 구현했습니다.
- UIKit 기반에서 코드 베이스로 모든 화면을 구성했습니다.
- 화면을 구성하는 주요 컴포넌트 배치는 Scroll View와 CollectionView 활용하여 구현했습니다.
- CollectionView 구현은 Diffable DataSource + Compositional Layou 조합으로 구성하여 구현했습니다.
- 전반적으로 영화마다 텍스트 길이에 차이가 있어서 scrollView를 적극적으로 사용하여, 모든 컨텐츠 내용에 상관없이 유연하게 UI가 대응할수 있도록 구현했습니다.
- 키보드 움직임에 따라 화면이 이동하는 부분은 기존에는 NotificationCenter에서 키보드가 나타나는 시점에 실행되는 메소드를 사용해서 구현했는데, 새로 생긴 API에서는 Keyboard Layout Guide를 활용하여 구현하면 더 간결한 코드로 동일한 기능을 구현할수 있다고 판단하여 해당 방식으로 구현했습니다.
- 프로젝트를 진행하면서 극한으로 UIKit을 사용해보고 싶어서 라이브러리를 사용하지 않고 기본 프레임워크로만 사용하여 프로젝트를 구성해봤습니다.
