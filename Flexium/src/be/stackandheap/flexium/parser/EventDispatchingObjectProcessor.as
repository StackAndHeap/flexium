package be.stackandheap.flexium.parser {
import flash.display.DisplayObject;

import mx.core.UIComponent;

import org.as3commons.stageprocessing.IStageObjectDestroyer;
import org.as3commons.stageprocessing.IStageObjectProcessor;

public class EventDispatchingObjectProcessor implements IStageObjectProcessor, IStageObjectDestroyer {
    private var _stageParser:StageParser;

    public function EventDispatchingObjectProcessor(stageParser:StageParser) {
        _stageParser = stageParser;
    }

    public function process(displayObject:DisplayObject):DisplayObject {
        if(displayObject.hasOwnProperty("id")) {
            _stageParser.addElement((displayObject as UIComponent).id, displayObject);
        }
        _stageParser.insertInTree(displayObject);
        return displayObject;
    }

    public function destroy(displayObject:DisplayObject):DisplayObject {
        if(displayObject.hasOwnProperty("id")) {
            _stageParser.removeElement((displayObject as UIComponent).id);
        }
        _stageParser.removeFromTree(displayObject);
        return displayObject;
    }
}
}
