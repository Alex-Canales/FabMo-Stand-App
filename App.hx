package;

import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.html.CanvasElement;
import js.Browser;

import state.IState;

typedef Point = { x:Float, y:Float };

/**
 * Main class of the app. Starts the app and 
 */

class App
{
    public static var currentState:IState;

    // public function new()
    static public function main()
    {
        var iptPxToIn:InputElement;
        var canvas:CanvasElement = cast Browser.document.getElementById("canvas");

        var surface:Surface = new Surface(canvas);
        switchState(new state.Custom(surface));

        iptPxToIn = cast Browser.document.getElementById("inToPx");
        iptPxToIn.value = Std.string(surface.inToPx);
    }

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
    public static function checkFloat(element:InputElement, minVal:Float=0):Float
    {
        var number:Float = Std.parseFloat(element.value);

        if(!Math.isFinite(number) || number < minVal)
            number = minVal;
        element.value = cast number;

        return number;
    }

    public static function createButton(text:String, callback:Dynamic):Element
    {
        var button:Element = Browser.document.createElement("button");
        button.innerHTML = text;
        button.onclick = callback;
        return button;
    }

    public static function createLabel(text:String):Element
    {
        var label:Element = Browser.document.createElement("label");
        label.innerHTML = text;
        return label;
    }

    public static function createInputText(value:String):InputElement
    {
        var input:InputElement = cast Browser.document.createElement("input");
        input.type = "text";
        input.value = cast value;
        return input;
    }

}
