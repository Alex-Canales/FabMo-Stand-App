package;

import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.html.CanvasElement;
import js.Browser;

import state.IState;

/**
 * Defines a point.
 */
typedef Point = { x:Float, y:Float };

//TODO: see to modify Coordinate by Rectangle or something like that
/**
 * Defines a coordinate/rectangle.
 */
typedef Coordinate = { x : Float, y : Float, width : Float, height : Float };

/**
 * Main class of the app. Starts the app and contains some useful functions.
 */
class App
{
    public static var currentState:IState;

    /**
     * Main function. Starts the app.
     */
    static public function main()
    {
        var iptPxToIn:InputElement;
        var canvas:CanvasElement = cast Browser.document.getElementById("canvas");

        var surface:Surface = new Surface(canvas);
        switchState(new state.Custom(surface));

        iptPxToIn = cast Browser.document.getElementById("inToPx");
        iptPxToIn.value = Std.string(surface.inToPx);
    }

    /**
     * Change the displayed state with the new one.
     * @param  newState  The new state to display.
     */
    public static function switchState(newState:IState)
    {
        if(currentState != null)
        {
            currentState.destroy();
            currentState = null;
        }
        newState.create();
        currentState = newState;
    }

    //If value not a number, becomes 0
    /**
     * Checks if the input text contains a correct float number. If not or if
     * the number is inferior to the given minimal value, change  the number by
     * this value.
     * @param   element  The element to check.
     * @param   minVal   The minimal value to put.
     * @return  The value inside the element (after checking).
     */
    public static function checkFloat(element:InputElement, minVal:Float=0):Float
    {
        var number:Float = Std.parseFloat(element.value);

        if(!Math.isFinite(number) || number < minVal)
            number = minVal;
        element.value = cast number;

        return number;
    }
}
