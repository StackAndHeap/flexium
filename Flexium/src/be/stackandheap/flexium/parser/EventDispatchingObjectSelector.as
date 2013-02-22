package be.stackandheap.flexium.parser {
import mx.core.UIComponent;

import org.as3commons.stageprocessing.IObjectSelector;

public class EventDispatchingObjectSelector implements IObjectSelector {
    public function approve(object:Object):Boolean {
        return object is UIComponent;
        //return object is UIComponent;
    }
}
}
