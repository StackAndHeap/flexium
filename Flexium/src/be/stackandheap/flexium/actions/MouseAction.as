package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.AppParser;
import be.stackandheap.flexium.utils.Errors;
import be.stackandheap.flexium.utils.References;
import be.stackandheap.flexium.utils.Utils;

import com.sparkTree.Tree;
import com.sparkTree.TreeDataProvider;

import flash.events.MouseEvent;

import mx.core.mx_internal;

import spark.components.List;

use namespace mx_internal;

public class MouseAction implements IAction {
    private var _parser:AppParser;

    public function MouseAction(parser:AppParser) {
        this.parser = parser
    }

    public function get parser():AppParser {
        return _parser;
    }

    public function set parser(value:AppParser):void {
        _parser = value;
    }

    public function attachActions():void {
    }

    public function doFlexClick(id:String, args:String):String {
        var child:Object = parser.getElement(id);

        if (child == null) {
            return Errors.OBJECT_NOT_FOUND;
        }

        // if stand alone control, just click it
        if (!args) {
            return String(child.dispatchEvent(new MouseEvent(MouseEvent.CLICK)));
        }

        // for a sparktree
        if (Utils.isA(child, References.SPARKTREE_DESCRIPTION)) {
            return clickSparkTree(child as Tree, args);
        }

        // for a List control
        if (Utils.isA(child, References.LIST_DESCRIPTION)) {
            return clickSparkList(child as List, args);
        }

        return Errors.OBJECT_NOT_COMPATIBLE;
    }

    private static function clickSparkTree(tree:Tree, selectItemLabel:String):String {
        for each (var item:* in (tree.dataProvider as TreeDataProvider).dataProvider) {
            if (tree.itemToLabel(item) == selectItemLabel) {
                tree.mx_internal::setSelectedItem(item, true);
                return "true";
            }
        }
        return "false";
    }

    private static function clickSparkList(list:List, selectItemLabel:String):String {
        for each (var item:Object in list.dataProvider) {
            if (list.itemToLabel(item) == selectItemLabel) {
                list.mx_internal::setSelectedItem(item, true);
                return "true";
            }
        }
        return "false";
    }
}
}
