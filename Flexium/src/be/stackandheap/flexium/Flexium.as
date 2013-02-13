package be.stackandheap.flexium {

import be.stackandheap.flexium.actions.Actions;
import be.stackandheap.flexium.parser.AppParser;

import flash.display.Sprite;
import flash.external.ExternalInterface;

import mx.events.FlexEvent;

[Mixin]
public class Flexium extends Sprite {
    private static var flexium:Flexium;
    public static var application:Object;
    public var appParser:AppParser;
    private var _actions:Actions;

    public function Flexium(app:Object) {
        super();
        app.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
    }

    public static function init(systemRoot:Object):void {
        if(!flexium) {
            application = systemRoot;
            flexium = new Flexium(systemRoot);
        }
    }

    private function applicationCompleteHandler(event:FlexEvent):void {
        application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
        appParser = new AppParser(application.getChildAt(0));
        injectJavaScript();
        _actions = new Actions(appParser);
    }

    private static function injectJavaScript():void {
        ExternalInterface.call("function () { var bob = " +
                "document.createElement('span'); bob.id = 'isSWFReady';" +
                "document.getElementsByTagName('html')[0].appendChild(bob);" +
                "}");
    }
}
}
