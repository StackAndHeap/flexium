package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.Button;
import mx.core.FlexGlobals;
import mx.core.mx_internal;

use namespace mx_internal;

public class PopupAction extends AbstractAction implements IAction {
    public function PopupAction(parser:AppParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("doFlexCloseAlert",doFlexCloseAlert);
    }

    public static function doFlexCloseAlert(buttonLabel:String):String {
        var alert:Alert = findAlertInNode(FlexGlobals.topLevelApplication.parent);
        if (alert) {
            for each (var button:Button in alert.mx_internal::alertForm.buttons) {
                if (button.label == buttonLabel) {
                    return String(button.dispatchEvent(new MouseEvent(MouseEvent.CLICK)));
                }
            }
        }
        return "false";
    }

    private static function findAlertInNode(obj:Object):Alert {
        if (obj.hasOwnProperty("numChildren")) {
            for (var i:int = 0; i < obj.numChildren; i++) {
                var object:Object = obj.getChildAt(i);
                if (object is Alert) {
                    return object as Alert;
                }
            }
        }

        return null;
    }
}
}
