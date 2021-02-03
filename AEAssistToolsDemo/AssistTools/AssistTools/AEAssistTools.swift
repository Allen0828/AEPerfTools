/*
 
 gitHub: https://github.com/Allen0828/AssistTools
 
 辅助开发工具
 功能：
 1 在所有页面上方提示当前页面的类名 方便在代码中快速找到位置
 Prompt the class name of the current page at the top of all pages, so as to quickly find the location in the code
 
 2 检测页面的掉帧率 在低于40时会自动提示
 When the frame dropping rate of the detected page is lower than 40, it will be automatically prompted
 
 
 注：此工作只在Debug模式下工作 在Release时 不会运行
 Note: this work only works in debug mode and will not run in release

 
 */

import UIKit
import ObjectiveC.runtime

class AEAssistTools {

    // 是否开启类名显示功能
    public static var showClassName: Bool = true
    
    /// 在 applicationDidFinishLaunchingWithOptions 中调用
    public static func config() {
        
        #if DEBUG
        UIViewController.initializeMethod()
        #endif
    }

}

private let screenWidth = UIScreen.main.bounds.size.width
private let screenHeight = UIScreen.main.bounds.size.height


extension UIViewController {
    
    private var className: String {
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
        }
    }
    
    public class func initializeMethod(){
        let originalDidAppear = #selector(UIViewController.viewDidAppear(_:))
        let swizzlDidAppear = #selector(UIViewController.swizzledViewDidAppear(_:))
        
        if let original = class_getInstanceMethod(self, originalDidAppear), let swizzled = class_getInstanceMethod(self, swizzlDidAppear) {
            let addMethod = class_addMethod(self, originalDidAppear, method_getImplementation(swizzled), method_getTypeEncoding(swizzled))
            if addMethod {
                class_replaceMethod(self, swizzlDidAppear, method_getImplementation(original), method_getTypeEncoding(original))
            } else {
                method_exchangeImplementations(original, swizzled)
            }
        }
        let originalDeinit = NSSelectorFromString("dealloc")
        let swizzlDeinit = #selector(swizzledDeinit)
        if let original = class_getInstanceMethod(self, originalDeinit), let swizzled = class_getInstanceMethod(self, swizzlDeinit) {
            let addMethod = class_addMethod(self, originalDeinit, method_getImplementation(swizzled), method_getTypeEncoding(swizzled))
            if addMethod {
                class_replaceMethod(self, swizzlDeinit, method_getImplementation(original), method_getTypeEncoding(original))
            } else {
                method_exchangeImplementations(original, swizzled)
            }
        }
    }

    @objc private func swizzledViewDidAppear(_ animated: Bool) {
        swizzledViewDidAppear(animated)
        if AEAssistTools.showClassName && !isClassFromFoundation(className) {
            AEClassNameView.shared.className = className
            debugPrint("ViewDidAppear-----\(className)")
        }
    }
    
    @objc private func swizzledDeinit() {
        if !self.isViewLoaded {
            debugPrint("⚠️⚠️⚠️⚠️⚠️此页面init后未被使用过--\(className)")
        }
    }
    
}


private func isClassFromFoundation(_ cl: String) -> Bool {
    let classes = ["AVPlayerViewController", "UIInputWindowController", "UICompatibilityInputViewController"]
    return classes.contains(cl)
}

private let statusBarHeight: CGFloat = {
    var height: CGFloat = 0
    if #available(iOS 13.0, *) {
        let manager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        height = manager?.statusBarFrame.size.height ?? 20
    } else {
        height = UIApplication.shared.statusBarFrame.size.height
    }
    return height
}()

private class AEClassNameView: UIView {
    
    @objc static let shared = AEClassNameView()
    
    public var className: String = "" {
        didSet {
            nameLa.text = className
        }
    }
    
    override init(frame: CGRect) {
        let newFrame = CGRect(x: 16, y: statusBarHeight, width: screenWidth/2, height: 13)
        super.init(frame: newFrame)
        nameLa.frame = self.bounds
        nameLa.textColor = UIColor.red
        nameLa.font = UIFont.systemFont(ofSize: 10)
        addSubview(nameLa)
        if #available(iOS 14.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.addSubview(self)
        } else {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLa: UILabel = UILabel()
}


/*
 // 掉帧检测
 private class AEFrameRateTools {
     
     private var displayLink: CADisplayLink?
     
     private var frameNumber: Int = 0
     private var hardwareFramesPerSecond: Int = 0
     private var recentFrameTimes: CFTimeInterval = CFTimeInterval.init()
     
     
     public func start() {
         displayLink = CADisplayLink(target: self, selector: #selector(displayLinkWillDraw))
         displayLink?.add(to: RunLoop.main, forMode: .common)
         clearLastSecondOfFrameTimes()
     }
     public func stop() {
         displayLink?.invalidate()
         displayLink = nil
     }
     
     init() {
         print("AEFrameRateTools-----init")
         if #available(iOS 13.0, *) {
             hardwareFramesPerSecond = UIScreen.main.maximumFramesPerSecond
         } else {
             // 13以下 都是60帧
             hardwareFramesPerSecond = 60
         }
 //        recentFrameTimes.
 //        recentFrameTimes = malloc_size(UnsafeRawPointer!)c(sizeof(*_recentFrameTimes) * _hardwareFramesPerSecond);
         recentFrameTimes = malloc(recentFrameTimes.bitW * hardwareFramesPerSecond)
     }
     
     
     @objc private func displayLinkWillDraw(link: CADisplayLink) {
         let current = link.timestamp
 //        let duration = current - lastFrameTime()
         recordFrameTime(time: current)
     }
     
     
     private func clearLastSecondOfFrameTimes() {
         let time = CACurrentMediaTime()
         guard var times = recentFrameTimes else { return }
         for i in 0..<hardwareFramesPerSecond {
             times[i] = time
         }
         recentFrameTimes = times
         frameNumber = 0
     }
     
     private func lastFrameTime() -> CFTimeInterval {
         guard let times = recentFrameTimes else { return CFTimeInterval.init() }
         return times[frameNumber % hardwareFramesPerSecond]
     }
     private func recordFrameTime(time: CFTimeInterval) {
         frameNumber += 1
         guard var times = recentFrameTimes else { return }
         times[frameNumber % hardwareFramesPerSecond] = time
         recentFrameTimes = times
         
         
         print("当前帧率=====\(frameNumber)")
     }
 }

 func sizeof<T:FixedWidthInteger>(_ int:T) -> Int {
     return int.bitWidth/UInt8.bitWidth
     
 }
 func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
     return intType.bitWidth/UInt8.bitWidth
 }

 
 */
