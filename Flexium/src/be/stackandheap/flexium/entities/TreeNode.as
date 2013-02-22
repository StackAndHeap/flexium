package be.stackandheap.flexium.entities {
import mx.collections.ArrayCollection;

public class TreeNode {
    private var _id:String;
    private var _label:String;
    private var _children:ArrayCollection;
    private var _object:Object;
    private var _ignore:Boolean = false;

    public function get ignore():Boolean {
        return _ignore;
    }

    public function set ignore(value:Boolean):void {
        _ignore = value;
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get label():String {
        return _label;
    }

    public function set label(value:String):void {
        _label = value;
    }

    public function get children():ArrayCollection {
        return _children;
    }

    public function set children(value:ArrayCollection):void {
        _children = value;
    }

    public function get object():Object {
        return _object;
    }

    public function set object(value:Object):void {
        _object = value;
    }
}
}
