package be.stackandheap.flexium.utils {
import flash.display.DisplayObject;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.core.IChildList;
import mx.core.UIComponent;

public class PopupUtils {
    public function PopupUtils() {
    }

    public static function getAllPopups(onlyVisible: Boolean = true): ArrayCollection
    {
        var result: ArrayCollection = new ArrayCollection();
        var applicationInstance:Object;

        applicationInstance = FlexGlobals.topLevelApplication;

        var rawChildren:IChildList = applicationInstance.systemManager.rawChildren;

        for (var i: int = 0; i < rawChildren.numChildren; i++) {
            var currRawChild: DisplayObject = rawChildren.getChildAt(i);

            if ((currRawChild is UIComponent) && UIComponent(currRawChild).isPopUp) {
                if (!onlyVisible || UIComponent(currRawChild).visible) {
                    result.addItem(currRawChild);
                }
            }
        }

        return result;
    }

}
}
