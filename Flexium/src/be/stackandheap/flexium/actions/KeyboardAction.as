package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;
import be.stackandheap.flexium.utils.Errors;

import mx.controls.Alert;

import spark.events.TextOperationEvent;

public class KeyboardAction extends AbstractAction implements IAction {
    public function KeyboardAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("doFlexType", doFlexType);
    }

    public function doFlexType(id:String, args:String):String
    {
        var child:Object = parser.getElement(id);
        if(child == null)
        {
            return Errors.OBJECT_NOT_FOUND;
        }

        if(child.hasOwnProperty("text"))
        {
            if((child.hasOwnProperty('visible') && child.visible != true)
                    || (child.hasOwnProperty('enabled') && child.enabled != true)
                    || (child.hasOwnProperty('editable') && child.editable != true)) {
                return Errors.OBJECT_NOT_TYPEABLE;
            } else {
                child.setFocus();
                child.text = args;
                return String(child.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE)));
            }
        }
        else
        {
            return Errors.OBJECT_NOT_TYPEABLE;
        }
    }
}
}
