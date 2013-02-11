package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

import mx.controls.Alert;

public class Actions {
    private var actionClasses:Array;

    public function Actions(parser:AppParser) {
        addActions(parser);
        attachActions();
    }

    private function addActions(parser:AppParser):void {
        actionClasses = [];
        actionClasses.push(new MouseAction(parser));
        actionClasses.push(new KeyboardAction(parser));
        actionClasses.push(new PopupAction(parser));
        actionClasses.push(new ApplicationAction(parser));
    }

    private function attachActions():void {
        for each (var actionClass:IAction in actionClasses) {
            actionClass.attachActions();
        }
    }



}
}
