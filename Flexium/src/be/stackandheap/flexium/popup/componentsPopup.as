package be.stackandheap.flexium.popup {
import be.stackandheap.flexium.entities.TreeNode;

import com.sparkTree.Tree;
import com.sparkTree.TreeDataProvider;

import flash.events.Event;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mx.binding.utils.BindingUtils;
import mx.collections.ArrayCollection;
import mx.collections.IList;

import mx.core.ScrollPolicy;
import mx.events.CloseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.PopUpManager;

import spark.components.TitleWindow;
import spark.layouts.VerticalLayout;

public class ComponentsPopup extends TitleWindow {
    public var flexiumIgnore:Boolean = true;

    public var tree:Tree;
    private var _data:ArrayCollection;
    private var _selectedComponent:IFocusManagerComponent;

    public static const DATA_CHANGED_EVENT:String = "dataChanged";
    public static const SELECTEDCOMPONENT_CHANGED_EVENT:String = "selectedComponentChanged";

    public function ComponentsPopup() {
        id = "flexium_invisible";
        layout = new VerticalLayout();
        createList();
        attachListeners();
    }

    [Bindable(event="selectedComponentChanged")]
    public function get selectedComponent():IFocusManagerComponent {
        return _selectedComponent;
    }

    public function set selectedComponent(value:IFocusManagerComponent):void {
        if (_selectedComponent == value) {
            return;
        }
        _selectedComponent = value;
        selectSelectedComponent();
        dispatchEvent(new Event(SELECTEDCOMPONENT_CHANGED_EVENT));
    }

    [Bindable(event="dataChanged")]
    public function get data():ArrayCollection {
        return _data;
    }

    public function set data(value:ArrayCollection):void {
        if (_data == value) return;
        _data = value;
        dispatchEvent(new Event(DATA_CHANGED_EVENT));
    }

    private function createList():void {
        tree = new Tree();
        tree.labelFunction = treeLabelFunction;
        tree.iconsVisible = false;
        BindingUtils.bindProperty(tree, "dataProvider", this, "data");
        tree.height = 400;
        tree.width = 350;
        selectSelectedComponent();
        this.addElement(tree);
    }

    private function selectSelectedComponent():void {
        if(tree.dataProvider && tree.dataProvider.length > 0) {
            expandAllItemsInList(tree, (tree.dataProvider as TreeDataProvider).dataProvider);
            tree.selectedItem = findSelectedNodeInTree(selectedComponent, (tree.dataProvider as TreeDataProvider).dataProvider);
        }
    }

    private static function expandAllItemsInList(tree:Tree,collection:IList):void {
        for each (var treeNode:TreeNode in collection) {
            tree.expandItem(treeNode, true);
            expandAllItemsInList(tree,  treeNode.children);
        }
    }

    private static function findSelectedNodeInTree(component:Object, list:IList):TreeNode {
        for each (var treeNode:TreeNode in list) {
            if(treeNode.object == component) {
                return treeNode;
            } else {
                if(findSelectedNodeInTree(component, treeNode.children)) {
                    return findSelectedNodeInTree(component, treeNode.children);
                }
            }
        }
        return null;
    }

    private static function treeLabelFunction(item:TreeNode):String {
        var returnVal:String = "";
        if(item.id) {
            returnVal += item.id;
        } else {
            returnVal = getDefinitionByName(getQualifiedClassName(item.object)).toString();
        }
        if(item.label) {
            returnVal += " (" + item.label + ")";
        }
        return returnVal;
    }

    private function attachListeners():void {
        this.addEventListener(CloseEvent.CLOSE, closePopup);
    }

    private function closePopup(e:CloseEvent):void {
        PopUpManager.removePopUp(this);
    }

}
}
