package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;
import be.stackandheap.flexium.utils.Errors;
import be.stackandheap.flexium.utils.References;
import be.stackandheap.flexium.utils.Utils;

import spark.components.List;

public class ComponentAction extends AbstractAction implements IAction {
    public function ComponentAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("hasItem",hasItem);
        attach("hasItems",hasItems);
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

    public function hasItems(id:String):String {
        var child:Object = parser.getElement(id);
        if(child) {
            if(child.hasOwnProperty("dataProvider")) {
                if(child.dataProvider && child.dataProvider.length > 0) {
                    return "true";
                }
            }
            return "false";
        }
        return Errors.OBJECT_NOT_FOUND;
    }

    public function hasItem(id:String, label:String):String {
        var child:Object = parser.getElement(id);
        if (Utils.isA(child, References.LIST_DESCRIPTION)) {
            return sparkListHasItem(child as List, label);
        }
        return Errors.OBJECT_NOT_COMPATIBLE;
    }

    private static function sparkListHasItem(list:List, label:String):String {
        for each (var item:Object in list.dataProvider) {
            if (list.itemToLabel(item) == label) {
                return "true";
            }
        }
        return "false";
    }
}
}
