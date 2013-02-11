package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

import flash.external.ExternalInterface;

public class AbstractAction {

    private var _parser:AppParser;

    public function AbstractAction(parser:AppParser) {
        this.parser = parser
    }

    public function get parser():AppParser {
        return _parser;
    }

    public function set parser(value:AppParser):void {
        _parser = value;
    }

    public static function attach(action:String, callback:Function):void {
        ExternalInterface.addCallback(action, callback);
    }

}
}
