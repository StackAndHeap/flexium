package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;

public interface IAction {

    function attachActions():void;
    function get parser():AppParser;
    function set parser(value:AppParser):void;

}
}
