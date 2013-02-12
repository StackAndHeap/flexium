package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;
import be.stackandheap.flexium.utils.Errors;

public class ComponentAction extends AbstractAction implements IAction {
    public function ComponentAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("isVisible",isVisible);
        attach("hasItem",hasItem);
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
    public function hasItem(id:String, label:String):String {
        var child:Object = parser.getElement(id);
        if (Utils.isA(child, References.LIST_DESCRIPTION)) {
            return sparkListHasItem(child as List, label);
        }
        return Errors.OBJECT_NOT_COMPATIBLE;
    }

    private function sparkListHasItem(list:List, label:String):String {
        for each (var item:Object in list.dataProvider) {
            if (list.itemToLabel(item) == label) {
                return "true";
            }
        }
        return "false";
    }
}
}
