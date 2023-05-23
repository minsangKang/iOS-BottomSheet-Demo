# iOS-BottomSheet-Demo
<img src="https://github.com/FreeDeveloper97/iOS-BottomSheet-Demo/assets/65349445/fd922b33-4463-4b3e-9689-8da83c9cb058" width=50%>

# 기능
- Bottom Sheet 표시 애니메이션 (하단에서 상단으로 올라오는 애니메이션)
- Bottom Sheet 뒷영역 Bottom Sheet의 높이에 따라 어둡게 표시
- Bottom Sheet를 터치하여 높이 조절 활성, 비활성화
- Bottom Sheet를 빠르게 아래로 드래그하여 창닫기
- Bottom Sheet의 기본 높이값 설정
- Bottom Sheet의 상단 좌,우 Radius 값 설정
- Bottom Sheet의 화면회전에 따른 높이값 조절

# 사용법
`BottomSheetViewController`를 init으로 생성 후 `present`를 통해 표시합니다.
- `contentViewController`: 표시하고자 하는 viewController
- `defaultHeight`: Bottom Sheet의 기본 높이값
- `cornerRadius`: 상단 좌, 우 Radius 값
- `isPannedable`: 높이조절 활성화 여부

```swift
let viewController = LogSettingVC()
let height: CGFloat = 500
let bottomSheetViewController = BottomSheetViewController(contentViewController: viewController,
                                                          defaultHeight: height,
                                                          cornerRadius: 25,
                                                          isPannedable: true)
                                                          
self.present(bottomSheetViewController, animated: false, completion: nil)
```

# 설명
원하시는 대로 수정하고싶으신 분들은 설명 내용을 참고하시면 됩니다!
## BottomSheetViewState
BottomSheet의 높이 상태 값이며, 전체화면 표시와 defaultHeight 높이 표시 상태가 있습니다.
- 중간단계의 높이를 추가하고 싶으신 경우 case를 추가하신 후 `showBottomSheet()` 함수 부분을 수정하시면 됩니다.
```swift
enum BottomSheetViewState {
    case expanded // 전체화면 표시 상태
    case normal // defaultHeight 표시 상태
}
```

## dimmedView
BottomSheet의 뒷배경을 흐리게 표시하는 뷰, darkGray 컬러의 `dimmedAlpha(0.4)` alpha 값으로 설정됩니다.
- alpha 값을 변경하고자 하신 경우 `dimmedAlpha` 값을 변경하시면 됩니다.
```swift
private lazy var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.darkGray.withAlphaComponent(self.dimmedAlpha)
    view.alpha = 0
    return view
}()
```

## bottomSheetView
dimmedView 위에 BottomSheet를 표시하는 뷰 영역, init시 입력된 `cornerRedius`값으로 상단 Radius값이 설정됩니다.
- backgroundColor 값이 white로 설정되어 있지만, contentViewController의 backgroundColor 값이 표시됩니다.
```swift
private lazy var bottomSheetView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = self.cornerRedius
    view.layer.cornerCurve = .continuous
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.clipsToBounds = true
    return view
}()
```

## dragIndicatorView
bottomSheetView가 드래그 가능하다는것을 나타내기 위한 Indicator, init시 입력된 `isPannedable`값에 따라 표시, 숨김이 됩니다.
```swift
private let dragIndicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .label
    view.layer.cornerRadius = 1.5
    view.alpha = 0
    return view
}()
```

## bottomSheetViewTopConstraint
view의 상단과 bottomSheetView간의 거리를 조절하기 위한 property, 해당 값을 통해 bottomSheetView의 높이를 조절합니다.
```swift
private var bottomSheetViewTopConstraint: NSLayoutConstraint!
```

## defaultHeight
BottomSheet의 기본 높이를 지정하기 위한 property, init시  전달받은 값으로 설정됩니다.
```swift
// 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
var defaultHeight: CGFloat = 500
```

## cornerRedius
bottomSheetView의 상단 CornerRedius 값, init시 전달받은 값으로 설정되며, 기본값으로 16 입니다.
```swift
// bottomSheetView의 상단 CornerRadius 값
var cornerRedius: CGFloat = 16
```

## dimmedAlpha
dimmedView의 alpha 값이며, init시 전달받은 값으로 설정되며, 기본값으로 0.4 입니다.
```swift
// dimmedView의 alpha값
var dimmedAlpha: CGFloat = 0.4
```

## bottomSheetPanMinTopConstant
bottomSheetView.top과 safeArea.top 사이의 최소간격값을 나타내는 property
- 최소간격을 변경하고자 하는 경우 해당 값을 변경하시면 됩니다.
```swift
// Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
var bottomSheetPanMinTopConstant: CGFloat = 40
```

## isPannedable
bottomSheetView를 드래그할 수 있는지 여부값, init시 전달받은 값으로 설정되며, 기본값으로 false 입니다.
- 기본적으로 항상 드래그되도록 하고싶으신 경우 해당 값을 true로, BottomSheetViewController의 인자값의 기본값을 true로 설정하시면 됩니다.
```swift
// pannedGesture 활성화 여부
var isPannedable: Bool = false
````

## bottomSheetPanStartingTopConstraint
bottomSheetView를 드래그하기 전에 bottomSheetView의 top constraint 값을 저장하기 위한 property
```swift
// 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
```

## contentViewController
bottomSheetView에 표시되고자 하는 viewController
```swift
private let contentViewController: UIViewController
```

## init
BottomSheetViewController를 생성하는 부분, 필요한 값들을 받아 설정합니다.
- 코드로 만들어신 ViewController 이므로 init과 required init이 필요합니다.
```swift
init(contentViewController: UIViewController, defaultHeight: CGFloat, cornerRadius: CGFloat = 16, dimmedAlpha: CGFloat = 0.3, isPannedable: Bool = false) {
    self.contentViewController = contentViewController
    self.defaultHeight = defaultHeight
    self.cornerRedius = cornerRadius
    self.dimmedAlpha = dimmedAlpha
    self.isPannedable = isPannedable

    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```

## viewDidLoad()
[viewDidLoad()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621495-viewdidload) 함수이며, BottonSheetViewController의 view가 메모리에 로드된 후 호출되며, 해당 함수내에서 ui와 layout 등을 설정합니다.
- `isPannedable` 값에 따라 bottomSheetView의 드래그 제스처 및 dragIndicatorView 표시를 설정합니다.
```swift
override func viewDidLoad() {
    super.viewDidLoad()

    self.configureUI()
    self.configureLayout()
    self.configureDimmedTapGesture()

    if isPannedable {
        self.configureViewPannedGesture()
        self.dragIndicatorView.alpha = 1
    }
}
```

## viewDidAppear()
[viewDidAppear()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621423-viewdidappear) 함수이며, BottomSheetViewController의 view가 뷰 계층에 추가되었음을 알립니다.
- BottomSheet가 표시되는 애니메이션이 동작됩니다.
```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.showBottomSheet()
}
```

## viewWillTransition()
[viewWillTransition()](https://developer.apple.com/documentation/uikit/uicontentcontainer/1621466-viewwilltransition) 함수이며, view의 크기가 변경되는 경우를 알립니다.
- 화면 회전시 동작되며, defaultHeight 높이가 가로상태의 높이보다 더 큰 경우 화면에서 벗어나는 것을 방지하기 위하여 bottomSheetView의 높이를 다시 계산합니다.
```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate { [weak self] _ in
        self?.showBottomSheet()
    }
}
```

## showBottomSheet()
bottomSheetView를 나타내는 애니메이션 및 높이조절을 담당합니다.
- BottomSheetViewState 값을 받으며, 해당 값에 따라 defaultHeight, 또는 최대 높이로 표시됩니다.
- 중간단계의 높이를 추가하고 싶으신 경우 `BottomSheetViewState`에 case를 추가하신 후, 이 함수에서 추가로직을 작성하시면 됩니다.
```swift
private func showBottomSheet(atState: BottomSheetViewState = .normal) {
    if atState == .normal {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        let constraintValue = (safeAreaHeight + bottomPadding) - defaultHeight

        if constraintValue > 0 {
            self.bottomSheetViewTopConstraint.constant = constraintValue
        } else {
            self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanMinTopConstant
        }

    } else {
        self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanMinTopConstant
    }

    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
        self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: self.bottomSheetViewTopConstraint.constant)
        self.view.layoutIfNeeded()
    }, completion: nil)
}
```

## configureUI()
viewDidLoad 시점에 불리며, contentViewController의 view를 추가 및 UI를 설정합니다.
- 전달받은 `contentViewController`를 addChild를 통해 `bottomSheetView` 내 추가합니다.
- 추가적인 View를 표시하고자 하시는 경우 이 함수 내 추가하시면 됩니다.
```swift
private func configureUI() {
    view.addSubview(dimmedView)
    view.addSubview(bottomSheetView)
    view.addSubview(dragIndicatorView)

    addChild(contentViewController)
    bottomSheetView.addSubview(contentViewController.view)
    contentViewController.didMove(toParent: self)
    bottomSheetView.clipsToBounds = true
}
```

## configureLayout()
configureUI() 후 불리며, AutoLayout을 설정하는 부분입니다.
- bottomSheetView의 bottomAnchor 값 설정으로 인해 Layout 경고창이 출력됩니다. 해당 경고창을 제거하고자 하는 경우 bottomAnchor의 heightAnchor 값을 지정하면 해결됩니다.
- 추가적인 View를 표시하고자 하시는 경우 이 함수 내에서 Layout을 설정하시면 됩니다.
```swift
private func configureLayout() {
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
        dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    // MARK: Layout 깨짐 경고를 제거하고자 하는 경우 bottomSheetView의 heightAnchor 값을 지정하면 해결된다.
    bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
    let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
    bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
    NSLayoutConstraint.activate([
        bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // MARK: 이부분으로 인해 Layout 깨짐 경고가 뜬다
        bottomSheetViewTopConstraint,
    ])
    
    contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        contentViewController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
        contentViewController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
        contentViewController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
        contentViewController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
    ])
    
    dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        dragIndicatorView.widthAnchor.constraint(equalToConstant: 60),
        dragIndicatorView.heightAnchor.constraint(equalToConstant: dragIndicatorView.layer.cornerRadius * 2),
        dragIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        dragIndicatorView.bottomAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12)
    ])
}
```

## configureDimmedTapGesture()
dimmedView의 Tap Gesture를 추가하는 함수이며, Tap을 통해 BottomSheet를 닫습니다.
- Tap 액션의 경우 `dimmedViewTapped()` 함수에서 동작됩니다.
- Tap으로 인해 BottomSheet가 닫히지 않기를 원하시는 경우 해당 함수를 수정, 또는 해당 함수를 사용하지시 않으면 됩니다.
```swift
private func configureDimmedTapGesture() {
    let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
    dimmedView.addGestureRecognizer(dimmedTap)
    dimmedView.isUserInteractionEnabled = true
}
```

## configureViewPannedGesture()
view에 드래그 제스처를 추가하는 함수이며, 드래그를 통해 `viewPanned()` 함수가 동작됩니다.
- `isPannedable` 값에 따라 해당함수가 불리지 않는 경우 드래그 제스처가 동작되지 않습니다.
- view 전체가 아닌 bottomSheetView에만 드래그 제스처를 넣고싶으신 경우 해당 함수를 수정하시면 됩니다.
```swift
private func configureViewPannedGesture() {
    // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
    let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))

    // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
    // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
    viewPan.delaysTouchesBegan = false
    viewPan.delaysTouchesEnded = false
    view.addGestureRecognizer(viewPan)
}
```

## dimmedViewTapped()
dimmedView의 Tap 액션이 발생했을 경우 불리며, `hideBottomSheetAndGoBack()` 함수가 동작되며 BottomSheetViewController가 닫힙니다.
```swift
@objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    self.hideBottomSheetAndGoBack()
}
````

## viewPanned()
view의 드레그 제스처가 동작될 때 불리며, 드래그 제스처에 따라 높이조절 및 닫힘 액션이 실행됩니다.
- 자세한 내용은 [[iOS] Auto Layout을 이용하여 페이스북의 Bottom Sheet을 만들어보자! - Part 2](https://velog.io/@dd3557/iOS-14-Auto-Layout을-이용하여-페이스북의-Bottom-Sheet을-만들어보자-Part-2)를 참고해주세요
```swift
// 해당 메소드는 사용자가 view를 드래그하면 실행됨
@objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let translation = panGestureRecognizer.translation(in: view)

    let velocity = panGestureRecognizer.velocity(in: view)

    switch panGestureRecognizer.state {
    case .began:
        bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
    case .changed:
        if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
            bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
        }

        dimmedView.alpha = dimAlphaWithBottomSheetTopConstraint(value: bottomSheetViewTopConstraint.constant)
    case .ended:
        if velocity.y > 1500 {
            hideBottomSheetAndGoBack()
            return
        }

        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight

        let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])

        if nearestValue == bottomSheetPanMinTopConstant {
            showBottomSheet(atState: .expanded)
        } else if nearestValue == defaultPadding {
            // Bottom Sheet을 .normal 상태로 보여주기
            showBottomSheet(atState: .normal)
        } else {
            // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
            hideBottomSheetAndGoBack()
        }
    default:
        break
    }
}
```

## hideBottomSheetAndGoBack()
BottomSheetViewController를 닫습니다.
- bottomSheetView가 아래로 내려가는 애니메이션과 함께 닫힙니다.
```swift
private func hideBottomSheetAndGoBack() {
    let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding = view.safeAreaInsets.bottom
    bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
        self.dimmedView.alpha = 0.0
        self.view.layoutIfNeeded()
    }) { _ in
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
```

## nearest()
`dimmedViewTapped()` 함수내에서 불리며, bottomSheetPanMinTopConstant (최대화면 상태), defaultPadding (defaultHeight 높이 상태), 화면 닫는 상태 중 하나를 반환합니다.
- 자세한 내용은 [[iOS] Auto Layout을 이용하여 페이스북의 Bottom Sheet을 만들어보자! - Part 2](https://velog.io/@dd3557/iOS-14-Auto-Layout을-이용하여-페이스북의-Bottom-Sheet을-만들어보자-Part-2)를 참고해주세요
```swift
//주어진 CGFloat 배열의 값 중 number로 주어진 값과 가까운 값을 찾아내는 메소드
private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
    guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
    else { return number }
    return nearestVal
}
```

## dimAlphaWithBottomSheetTopConstraint()
bottomSheetView의 높이에 따라 dimmedView의 alpha 값을 조절합니다.
- 높이가 높아지면 점점 alpha 값이 높아집니다. (어두워집니다)
- 높이가 낮아지면 점점 alpha 값이 낮아집니다. (밝아집니다)
- 자세한 내용은 [[iOS] Auto Layout을 이용하여 페이스북의 Bottom Sheet을 만들어보자! - Part 2](https://velog.io/@dd3557/iOS-14-Auto-Layout을-이용하여-페이스북의-Bottom-Sheet을-만들어보자-Part-2)를 참고해주세요
```swift
private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
    let fullDimAlpha: CGFloat = self.dimmedAlpha

    let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
    let bottomPadding = view.safeAreaInsets.bottom

        // bottom sheet의 top constraint 값이 fullDimPosition과 같으면
        // dimmer view의 alpha 값이 dimmedAlpha가 되도록 합니다
    let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2

        // bottom sheet의 top constraint 값이 noDimPosition과 같으면
        // dimmer view의 alpha 값이 0.0이 되도록 합니다
    let noDimPosition = safeAreaHeight + bottomPadding

        // Bottom Sheet의 top constraint 값이 fullDimPosition보다 작으면
        // 배경색이 가장 진해진 상태로 지정해줍니다.
    if value < fullDimPosition {
        return fullDimAlpha
    }

        // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
        // 배경색이 투명한 상태로 지정해줍니다.
    if value > noDimPosition {
        return 0.0
    }

        // 그 외의 경우 top constraint 값에 따라 0.0과 dimmedAlpha 사이의 alpha 값이 Return되도록 합니다
    return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
}
```
