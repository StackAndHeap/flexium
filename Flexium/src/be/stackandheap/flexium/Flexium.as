package be.stackandheap.flexium {

import be.stackandheap.flexium.actions.Actions;
import be.stackandheap.flexium.parser.StageParser;
import be.stackandheap.flexium.popup.ComponentsPopup;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.external.ExternalInterface;
import flash.system.Security;
import flash.ui.Keyboard;

import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.managers.FocusManager;
import mx.managers.IFocusManagerComponent;
import mx.managers.IFocusManagerContainer;
import mx.managers.PopUpManager;

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
        if (!flexium) {
            application = systemRoot;
            flexium = new Flexium(systemRoot);
        }
    }

    private function applicationCompleteHandler(event:FlexEvent):void {
        Security.allowDomain("*");
        application.addEventListener(KeyboardEvent.KEY_DOWN, openElementList);
        application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
        stageParser = new StageParser();
        injectJavaScript();
        _actions = new Actions(stageParser);
    }

    private function openElementList(e:KeyboardEvent):void {
        if (e.ctrlKey == true && e.keyCode == Keyboard.I) {
            var focusManager:FocusManager = new FocusManager(FlexGlobals.topLevelApplication as IFocusManagerContainer, false);
            var componentWithFocus:IFocusManagerComponent = focusManager.getFocus();
            var popup:ComponentsPopup = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, ComponentsPopup, false) as ComponentsPopup;
            PopUpManager.centerPopUp(popup);
            popup.data = stageParser.elementsTree;
            popup.selectedComponent = componentWithFocus;
        }
    }

    private static function injectJavaScript():void {
        ExternalInterface.call("function () { var bob = " +
                "document.createElement('span'); bob.id = 'isSWFReady';" +
                "document.getElementsByTagName('html')[0].appendChild(bob);" +
                "}");
    }
}
}
