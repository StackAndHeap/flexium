package be.stackandheap.flexium.actions {
import be.stackandheap.flexium.parser.StageParser;
import be.stackandheap.flexium.utils.Errors;
import be.stackandheap.flexium.utils.References;
import be.stackandheap.flexium.utils.Utils;

import com.sparkTree.Tree;

import com.sparkTree.Tree;
import com.sparkTree.TreeDataProvider;

import flash.events.Event;

import flash.events.MouseEvent;

import mx.core.mx_internal;
import mx.events.ChildExistenceChangedEvent;

import spark.components.CheckBox;

import spark.components.DataGrid;
import spark.components.List;
import spark.components.gridClasses.GridColumn;
import spark.events.GridEvent;

use namespace mx_internal;

public class MouseAction extends AbstractAction implements IAction {
    public function MouseAction(parser:StageParser) {
        super(parser);
    }

    public function attachActions():void {
        attach("doFlexClick", doFlexClick);
        attach("doFlexDoubleClick", doFlexDoubleClick);
        attach("clickInPopup", clickInPopup);
    }

    public function doFlexClick(id:String, args:String):String {
        var child:Object = parser.getElementById(id);

        if (child == null) {
            return Errors.OBJECT_NOT_FOUND;
        }

        // Checkbox
        if(child is CheckBox) {
            (child as CheckBox).selected = !((child as CheckBox).selected);
            return String(child.dispatchEvent(new Event(Event.CHANGE)));
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

    public function doFlexDoubleClick(id:String, args:String):String {
        var child:Object = parser.getElementById(id);

        if (child == null) {
            return Errors.OBJECT_NOT_FOUND;
        }

        if (child.hasOwnProperty("doubleClickEnabled") && child.doubleClickEnabled) {
            // check if child is a spark datagrid
            if (child is DataGrid) {
                return doubleClickItemInDataGrid(child as DataGrid, args);
            }

            return String(child.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK)));
        }
        return Errors.OBJECT_NOT_COMPATIBLE;
    }

    public static function clickInPopup(id:String):String {
        return "true";
    }

    private static function clickSparkTree(tree:Tree, selectItemLabel:String):String {
        for each (var item:* in (tree.dataProvider as TreeDataProvider).dataProvider) {
            var selectedItem:Object = hasItemByLabel(tree,item, selectItemLabel);
            if(selectedItem) {
                tree.mx_internal::setSelectedItem(selectedItem, true);
                return "true";
            }
        }
        return "false";
    }

    private static function hasItemByLabel(tree:Tree, item:Object, label:String):Object {
        if(tree.itemToLabel(item)==label) {
            return item;
        }
        if(item.hasOwnProperty("children")) {
            for each (var object:Object in item.children) {
                if(hasItemByLabel(tree, object, label)) {
                   return hasItemByLabel(tree, object, label);
                }
            }
        }
        return null;
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

    private static function doubleClickItemInDataGrid(grid:DataGrid, args:String):String {
        if(args.indexOf("||") > 0) {
            return doubleClickItemInDataGridByLabel(grid,  args);
        } else {
            return doubleClickItemInDataGridById(grid, args);
        }
    }

    private static function doubleClickItemInDataGridById(grid:DataGrid, args:String):String {
        var item:Object = grid.dataProvider.getItemAt(int(args));

        if(!item) {
            return Errors.ITEM_NOT_FOUND;
        }

        return selectItemInGrid(grid, item);
    }

    private static function doubleClickItemInDataGridByLabel(grid:DataGrid, args:String):String {
        var argsArray:Array = args.split("||");
        var colHeader:String = argsArray[0];
        var itemLabel:String = argsArray[1];
        var selectedColumn:GridColumn;

        for each (var column:GridColumn in grid.columns.toArray()) {
            if (column.headerText == colHeader) {
                selectedColumn = column;
                break;
            }
        }

        if (selectedColumn) {
            for each (var item:Object in grid.dataProvider) {
                if (selectedColumn.itemToLabel(item) == itemLabel) {
                    return selectItemInGrid(grid, item, selectedColumn);
                }
            }
        }
        return Errors.OBJECT_NOT_COMPATIBLE;
    }

    private static function selectItemInGrid(grid:DataGrid, item:Object, column:GridColumn=null):String {
        grid.setSelectedIndex(grid.dataProvider.getItemIndex(item));
        var event:GridEvent = new GridEvent(GridEvent.GRID_DOUBLE_CLICK);
        event.item = item;
        if(column) {
            event.column = column;
            event.columnIndex = grid.columns.getItemIndex(column);
        }
        return String(grid.dispatchEvent(event));
    }

}
}
