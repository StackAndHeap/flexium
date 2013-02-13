/*	
 *	License
 *	
 *	This file is part of The SeleniumFlex-API.
 *	
 *	The SeleniumFlex-API is free software: you can redistribute it and/or
 *  modify it  under  the  terms  of  the  GNU  General Public License as 
 *  published  by  the  Free  Software Foundation,  either  version  3 of 
 *  the License, or any later version.
 *
 *  The SeleniumFlex-API is distributed in the hope that it will be useful,
 *  but  WITHOUT  ANY  WARRANTY;  without  even the  implied  warranty  of
 *  MERCHANTABILITY   or   FITNESS   FOR  A  PARTICULAR  PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with The SeleniumFlex-API.
 *	If not, see http://www.gnu.org/licenses/
 *
 */
package be.stackandheap.flexium.parser
{

	import flash.utils.describeType;
	
	import flash.utils.getQualifiedClassName;

	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class AppParser
	{
		public var thisApp:Object;
		public var curMouseX:int;
		public var curMouseY:int;
		
		private var nextNode:AppNode;
		private var firstNode:AppNode;


        public function AppParser(thisApp:Object) {
            this.thisApp = thisApp;
        }

        /**
		 * Get an object in the application
         *
		 * @param  target specification of the Object to return
		 * @return  The Object corresponding to the target, or null if not found
		 */
		public function getElement(target:String):Object
		{
			if(target.indexOf(":") >= 0)
			{
				return getElementByCustomTarget(target.split('/'), thisApp.parent);
			}
			
			var locatorDelimeter:int = target.indexOf("=");
			if(locatorDelimeter < 0)
			{
				return getElementByProperty(target.split('/'), "id", thisApp.parent);
			}
			
			var locator:String=target.substring(0,locatorDelimeter); 
			target=target.substring(locatorDelimeter + 1);
			
			// id is the default
			if(locator == "")
			{
				return getElementByProperty(target.split('/'), "id", thisApp.parent);
			}
			
			try
			{
				var myFunction:Function=this["locateElementBy" + locator];
				if (myFunction != null)
				{
					return myFunction.call(this, target);
				}	
			}
			catch(e:Error)
			{
				trace(e.message);
			}
			return getElementByProperty(target.split('/'), locator, thisApp.parent);
		} 
		
		/**
		 * getElementByCustomTarget()
		 *
		 *	Description:
		 * 		locate the Flex Component object by using a target specifier which allows
		 *		for user-definable nested component references that not assume a specific 
		 *		property type (such as ID).
		 *		
		 *	Target Specifier Grammar:
		 *		specifier 		= component-spec[/component-spec[/component-spec]...]
		 *		component-spec 	= propertyName:targetValue
		 *		propertyName 	= a property defined for the specific component
		 *		targetValue 	= the value of the property to be used to match.
		 *						  The targetValue must be unique within all siblings of the parent container. 
		 */ 
		public function getElementByCustomTarget(searchPath:Array, searchScope:Object):Object
		{
			var current:String = searchPath[searchPath.length - 1];
			var property:String = "id";
			var element:String = current;
			
			var locatorDelimeter:int = current.indexOf(":");
			if(locatorDelimeter >= 0)
			{
				// locator = "myProperty:hello"
				property = current.substring(0, locatorDelimeter); 
				element = current.substring(locatorDelimeter + 1);
			}
			
			if(searchPath.length > 1)
			{
				// build list of ancestors to pass to next iteration of the locator function 
				var narrowSearchPath:Array = [];
				for(var i:int = 0; i < searchPath.length - 1; i++)
				{
					narrowSearchPath.push(searchPath[i]);
				} 
				searchScope = getElementByCustomTarget(narrowSearchPath, searchScope);
			}
			return searchForTarget(element, property, searchScope);
		}
		

		public function getElementByProperty(searchPath:Array, property:String, searchScope:Object):Object
		{
			if(searchPath.length > 1)
			{
				// build list of ancestors to pass to next iteration of the locator function 
				var narrowSearchPath:Array = [];
				for(var i:int = 0; i < searchPath.length - 1; i++)
				{
					narrowSearchPath.push(searchPath[i]);
				} 
				searchScope = getElementByProperty(narrowSearchPath, property, searchScope);
			}
			return searchForTarget(searchPath[searchPath.length - 1], property, searchScope);
		}
		

		private function searchForTarget(element:String, property:String, root:Object):Object
		{
			var parents:Array = [];
			var currentNode:AppNode = new AppNode(root);
			var sibTravers:Boolean = false;
			
			while(isNotTargetNode(element, property, currentNode.child))
			{
				if(hasFirstChild(currentNode) && ! sibTravers)
				{
					parents.push(currentNode);
					currentNode = firstNode;
				}
				else if(hasNextNode(currentNode, parents[parents.length - 1].child))
				{
					currentNode = nextNode;
					sibTravers = false;
				}
				else
				{
					currentNode = parents.pop();
					sibTravers = true;
				}
				if(currentNode.child == root)
				{
					return null
				}
			}
			parents = null;
			if(currentNode.child == root)
			{
				return null
			}
			return currentNode.child;
		}

		private static function isNotTargetNode(element:String, property:String, node:Object):Boolean
		{
			return ! ((node.hasOwnProperty(property) && node[property] == element) || node.name == element);
		}

		private function hasFirstChild(node:AppNode):Boolean
		{
			if(node.child.hasOwnProperty("numChildren") && node.child.numChildren > 0)
			{
				firstNode = new AppNode(node.child.getChildAt(0), 0, false);
				return true;
			}
			if(node.child.hasOwnProperty("rawChildren") && node.child.rawChildren.numChildren > 0)
			{
				firstNode = new AppNode(node.child.rawChildren.getChildAt(0), 0, true);
				return true;
			}
			return false;
		}
		
		private function isChild(child:Object, parent:Object):Boolean
		{
			// this looks weird but its because getChildIndex will throw and exception
			// instead of returning -1 as it should if child does not exist within it 
			try
			{
				parent.getChildIndex(child);
				return true;
			}catch(e:Error){}
			return false;
		}
		
		/**
		 * Finds out if an object is not a ContentPanel. This can be determined quickly by checking if
		 * the qualified class name is "mx.core::FlexSprite".
		 * 
		 * @param  child  the object to check
		 * @return true if the object is not a "mx.core::FlexSprite", otherwise false.
		 */
		private static function isNotContentPane(child:Object):Boolean
		{
			return getQualifiedClassName(child) != "mx.core::FlexSprite";
		}
		
		/**
		 * Find out if the object has a sibling node on the tree that has no been visited yet or
		 * is not a ContentPane.
		 *  
		 * @param  node  The current node the algorithm is positioned on in the application object model
		 * @param  parent  The parent object of the node
		 * @return  true is there is a next-node available, otherwise false.
		 */
		private function hasNextNode(node:AppNode, parent:Object):Boolean
		{
			var i:int;
			
			if(node.isRaw)
			{
				return gotoNextRaw(node, parent);
			}
			else
			{
				if(node.index < parent.numChildren - 1)
				{
					i = node.index + 1;
					nextNode = new AppNode(parent.getChildAt(i), i, false);
					return true;
				}
				return gotoNextRaw(node, parent);
			}
		}
		
		/**
		 * Find out if the object has a sibling node on the tree that has not been visited yet or
		 * is not a ContentPane. The node must be a rawChild of the parent node.
		 *  
		 * @param  node  The current node the algorithm is positioned on in the application object model
		 * @param  parent  The parent object of the node
		 * @return  true is there is a next-node available, otherwise false.
         *
		 */

        // TODO: implement function for spark
		private function gotoNextRaw(node:AppNode, parent:Object):Boolean
		{
//			var i:int = 0;
//			if(node.isRaw)
//			{
//				i = node.index + 1;
//			}
//			if(parent.hasOwnProperty("rawChildren") && i < parent.rawChildren.numChildren)
//			{
//				var child:Object;
//				while(i < parent.rawChildren.numChildren)
//				{
//					child = parent.rawChildren.getChildAt(i);
//					if(isNotContentPane(child) && (!isChild(child, parent) || child is ControlBar))
//					{
//						nextNode = new AppTreeNode(child, i, true);
//						return true;
//					}
//					i++;
//				}
//			}
			return false;
		}

		/**
		 * Find a UIComponent using its id attribute, wherever it is in the application
		 * @param  id  id attribute of the UIComponent to return
		 * @return  The UIComponent corresponding to the id, or null if not found
		 */		
		public function getWidgetById(id:String):Object
		{
			var component:Object = getElement(id);
			if(! component)
			{
				throw new Error("Component with id '" + id + "' could not be found");
			}
			return component;
		}
	}
}
