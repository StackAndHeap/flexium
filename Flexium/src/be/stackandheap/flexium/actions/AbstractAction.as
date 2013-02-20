package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.StageParser;

import flash.external.ExternalInterface;

public class AbstractAction {

    private var _parser:StageParser;

    public function AbstractAction(parser:StageParser) {
        this.parser = parser;
    }

    public function get parser():StageParser {
        return _parser;
    }

    public function set parser(value:StageParser):void {
        _parser = value;
    }

    public static function attach(action:String, callback:Function):void {
        ExternalInterface.addCallback(action, callback);
    }

}
}
