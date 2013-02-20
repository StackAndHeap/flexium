package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.StageParser;

public class Actions {
    private var actionClasses:Array;

    public function Actions(parser:StageParser) {
        addActions(parser);
        attachActions();
    }

    private function addActions(parser:StageParser):void {
        actionClasses = [];
        actionClasses.push(new MouseAction(parser));
        actionClasses.push(new KeyboardAction(parser));
        actionClasses.push(new PopupAction(parser));
        actionClasses.push(new ApplicationAction(parser));
        actionClasses.push(new ComponentAction(parser));
    }

    private function attachActions():void {
        for each (var actionClass:IAction in actionClasses) {
            actionClass.attachActions();
        }
    }



}
}
