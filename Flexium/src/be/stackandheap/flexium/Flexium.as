package be.stackandheap.flexium {

import be.stackandheap.flexium.actions.Actions;
import be.stackandheap.flexium.parser.StageParser;

import flash.display.Sprite;
import flash.external.ExternalInterface;
import flash.system.Security;

import mx.events.FlexEvent;

[Mixin]
public class Flexium extends Sprite {
    private static var flexium:Flexium;
    public static var application:Object;
    public var stageParser:StageParser;
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
        Security.allowDomain("*");
        application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
        stageParser = new StageParser();
        injectJavaScript();
        _actions = new Actions(stageParser);
    }

    private static function injectJavaScript():void {
        ExternalInterface.call("function () { var bob = " +
                "document.createElement('span'); bob.id = 'isSWFReady';" +
                "document.getElementsByTagName('html')[0].appendChild(bob);" +
                "}");
    }
}
}
