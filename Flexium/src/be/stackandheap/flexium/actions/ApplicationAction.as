package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

import mx.managers.CursorManager;

public class ApplicationAction extends AbstractAction implements IAction {
    public function ApplicationAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("getFlexCursorState", getFlexCursorState);
    }

    public static function getFlexCursorState():String {
        return CursorManager.currentCursorID.toString();
    }
}
}
