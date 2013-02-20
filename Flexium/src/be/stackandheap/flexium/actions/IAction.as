package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.StageParser;

public interface IAction {

    function attachActions():void;
    function get parser():StageParser;
    function set parser(value:StageParser):void;

}
}
