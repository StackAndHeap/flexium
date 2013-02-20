package be.stackandheap.flexium.parser {
import flash.display.DisplayObject;
import flash.geom.PerspectiveProjection;

import org.as3commons.stageprocessing.impl.FlashStageObjectProcessorRegistry;

public class StageParser {
    private var _registry:FlashStageObjectProcessorRegistry;
    private var _elements:Array;
    private var _popupElements:Array;

    public function StageParser() {
        _elements = [];
        _popupElements = [];
        initProcessor();
    }

    private function initProcessor():void {
        _registry = new FlashStageObjectProcessorRegistry();
        _registry.useStageDestroyers = true;
        _registry.registerStageObjectProcessor(new EventDispatchingObjectProcessor(this), new EventDispatchingObjectSelector());
        _registry.initialize();
    }

    public function getElementById(id:String):Object {
        if(_popupElements[id]) {
            return _popupElements[id];
        } else {
            if(_elements[id]) {
                return _elements[id];
            }
        }
        throw new Error("Element not found on stage :'"+id+"'");
    }

    /**
     * @private
     */
    public function addElement(id:String, object:Object):void {
        if(isObjectInPopup(object)) {
            _popupElements[id] = object;
        }
        _elements[id] = object;

    }

    private static function isObjectInPopup(object:Object):Boolean {
        if(object.hasOwnProperty("isPopUp") && object.isPopUp) {
            return true;
        } else {
            if(object.parent) {
                return isObjectInPopup(object.parent);
            }
        }
        return false
    }

    /**
     * @private
     */
    public function removeElement(id:String):void {
        _popupElements[id]=null;
        _elements[id] = null;
    }
}
}