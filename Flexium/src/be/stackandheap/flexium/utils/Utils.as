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
package be.stackandheap.flexium.utils {
import flash.utils.describeType;

import mx.events.PropertyChangeEvent;

public class Utils {
    public function Utils() {
    }

    public static function getOjectType(child:Object):String {
        var classInfo:XML = describeType(child);
        classInfo = describeType(child);
        return classInfo.@name.toString();
    }

    public static function isA(child:Object, requiredTypeInHierarchy:String):Boolean {
        var classInfo:XML = describeType(child);

        // match this exact class
        if (classInfo.@name == requiredTypeInHierarchy) {
            return true;
        }

        // match up in type hierarchy to match extended classes
        for each (var clazzExtended:XML in classInfo.extendsClass) {
            trace("checking if '" + requiredTypeInHierarchy + "'='" + clazzExtended.@type + "'");
            if (requiredTypeInHierarchy == clazzExtended.@type) {
                return true;
            }
        }

        return false;
    }

    public static function setValueFromString(child:Object, property:String, setval:String):String {
        if (child[property] is String) {
            child[property] = setval;
            return String(child.dispatchEvent(new PropertyChangeEvent("propertyChange")));
        }
        else if (child[property] is Number) {
            child[property] = parseInt(setval);
            return String(child.dispatchEvent(new PropertyChangeEvent("propertyChange")));
        }
        else if (child[property] is Boolean) {
            child[property] = setval == 'true' ? true : false;
            return String(child.dispatchEvent(new PropertyChangeEvent("propertyChange")));
        }
        else {
            child[property] = setval as Object;
            return String(child.dispatchEvent(new PropertyChangeEvent("propertyChange")));
        }
        return null;
    }

    /*
     * Gets all the children of a UIComponent of a given class name and
     * returns them in an array.
     *
     * The class name provided to the this function should be in the
     * following format: mx.controls.listClasses::ListBaseContentHolder
     */
    public static function getChildrenOfTypeFromContainer(container:Object, clsName:String):Array {
        var childrenByType:Array = new Array;

        for (var i:int; i < container.numChildren; i++) {
            if (getOjectType(container.getChildAt(i)) == clsName) {
                childrenByType.push(container.getChildAt(i));
            }
        }
        return childrenByType;
    }
}
}
