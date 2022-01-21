import Flutter
import UIKit

class BannerFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return BannerView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class BannerView: NSObject, FlutterPlatformView {
    var controller: BannerAdController
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments: Any?, binaryMessenger messenger: FlutterBinaryMessenger?)
    {
        controller = BannerAdController()
        if let args = arguments as? Dictionary<String, Any>
        {
            let unitId = args["UnitId"] as? String
            let size = args["Size"] as? String
            controller.initBannerAdController(unitId: unitId!, sizeType: size!)
        }
        super.init()
    }

    func view() -> UIView {
        return controller.view
    }

}
