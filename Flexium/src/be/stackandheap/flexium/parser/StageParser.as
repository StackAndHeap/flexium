package be.stackandheap.flexium.parser {
import be.stackandheap.flexium.entities.TreeNode;

import flash.utils.describeType;

import mx.collections.ArrayCollection;
import mx.managers.SystemManager;
import mx.utils.UIDUtil;

import org.as3commons.stageprocessing.impl.FlashStageObjectProcessorRegistry;

import spark.components.Group;
import spark.components.Scroller;
import spark.components.supportClasses.Skin;

public class StageParser {
    private var _registry:FlashStageObjectProcessorRegistry;
    private var _elements:Array;
    private var _popupElements:Array;
    private var elementsTreeLookup:Array;
    public var elementsTree:ArrayCollection;

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
        } else {
            _elements[id] = object;
        }

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
        if(_popupElements[id]) {
            _popupElements[id]=null;
        } else {
            _elements[id] = null;
        }
    }

    public function insertInTree(object:Object):void {
        if(!includeObjectInTree(object)) {
            return;
        }

        if(!elementsTree) {
            elementsTree = new ArrayCollection();
        }
        if(!elementsTreeLookup) {
            elementsTreeLookup = [];
        }

        var node:TreeNode = createNodeFromObject(object);

        addToDictionary(node, elementsTreeLookup);

        addTreeElement(node);
    }

    public function removeFromTree(object:Object):void {
        if(!includeObjectInTree(object)) {
            return;
        }

        var node:TreeNode = elementsTreeLookup[UIDUtil.getUID(object)] as TreeNode;

        for each (var treeNode:TreeNode in elementsTree) {
            if(node == treeNode) {
                elementsTree.removeItemAt(elementsTree.getItemIndex(treeNode));
            } else {
                if(treeNode.children) {
                    findAndRemoveNodeInChildren(node, treeNode.children);
                }
            }
        }

        removeEmptyRootNodes();
    }

    private function removeEmptyRootNodes():void {
        for each (var treeNode:TreeNode in elementsTree) {
            if(!treeNode.children || treeNode.children.length == 0) {
                elementsTree.removeItemAt(elementsTree.getItemIndex(treeNode));
                removeFromDictionary(treeNode, elementsTreeLookup);
            }
        }
    }

    private static function findAndRemoveNodeInChildren(node:TreeNode, collection:ArrayCollection):void {
        for each(var treeNode:TreeNode in collection) {
            if(node == treeNode) {
                collection.removeItemAt(collection.getItemIndex(treeNode));
            } else {
                findAndRemoveNodeInChildren(node, treeNode.children)
            }
        }
    }

    private static function includeObjectInTree(object:Object):Boolean {
        if(object is Skin) {
            return false;
        }
        if(object is Scroller) {
            return false;
        }
        if(object is Group && object.isPopUp == false) {
            return false;
        }
        if(object.hasOwnProperty("id") && object.id == "flexium_invisible") {
            return false;
        }
        if(objectHasIgnoreFlag(object)) {
            return false;
        }
        return true;
    }

    private static function objectHasIgnoreFlag(object:Object):Boolean {
        if(object.hasOwnProperty("flexiumIgnore") && object.flexiumIgnore == true) {
            return true;
        }
        if(object.parent) {
            return objectHasIgnoreFlag(object.parent);
        }
        return false;
    }

    private function addTreeElement(node:TreeNode):void {
        var firstParent:TreeNode = getFirstParent(node.object, elementsTreeLookup);

        if(firstParent) {
            if(!firstParent.children) {
                firstParent.children = new ArrayCollection();
            }
            firstParent.children.addItem(node);
            addToDictionary(node,  elementsTreeLookup);
        } else {
            elementsTree.addItem(node);
            addToDictionary(node, elementsTreeLookup);
        }
    }

    private static function addToDictionary(node:TreeNode, dictionary:Array):void {
        dictionary[UIDUtil.getUID(node.object)] = node;
    }

    private static function removeFromDictionary(node:TreeNode, dictionary:Array):void {
        dictionary[UIDUtil.getUID(node.object)] = null;
    }

    private static function getFirstParent(object:Object, dictionary:Array):TreeNode {
        if(object.parent == null || object.parent is SystemManager) {
            return null;
        }

        if(dictionary[UIDUtil.getUID(object.parent)]) {
            return dictionary[UIDUtil.getUID(object.parent)] as TreeNode;
        }

        return getFirstParent(object.parent, dictionary);
    }

    private static function createNodeFromObject(object:Object):TreeNode {
        var node:TreeNode = new TreeNode();
        node.id = object.id;
        if(object.hasOwnProperty("label")) {
            node.label = object.label;
        }
        node.object = object;
        return node;
    }

}
}