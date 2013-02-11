package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

public class Actions {
    private var actionClasses:Array;

    public function Actions(parser:AppParser) {
        addActions(parser);
        attachActions();
    }

    private function addActions(parser:AppParser):void {
        actionClasses = [];
        actionClasses.push(new MouseAction(parser));
    }

    private function attachActions():void {
        for each (var actionClass:IAction in actionClasses) {
            actionClass.attachActions();
        }
    }



}
}
