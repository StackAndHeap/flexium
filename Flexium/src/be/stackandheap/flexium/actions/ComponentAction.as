package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;
import be.stackandheap.flexium.utils.Errors;

public class ComponentAction extends AbstractAction implements IAction {
    public function ComponentAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("isVisible",isVisible);
    }

    public function isVisible(id:String):String {
        var child:Object = parser.getElement(id);
        if(child) {
            if(child.hasOwnProperty("visible")) {
                return child.visible;
            } else {
                return Errors.PROPERTY_DOESNT_EXIST;
            }
        } else {
            return Errors.OBJECT_NOT_FOUND;
        }
    }
}
}
