package;

import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.Browser;

import state.IState;

typedef Hole = Int;   //TODO: CHANGE THAT!
typedef Stand = { width:Float, height:Float, holes:Array<Hole> };

class App
{
    private var document:Document = Browser.document;
    private var stand:Stand;
    private var surface:Surface;

    public static var currentState:IState;

    public function new()
    {
        stand = { width : 10, height : 10, holes : new Array<Hole>() };
        surface = new Surface(cast document.getElementById("canvas"));
        switchState(new state.Menu(surface));
        // setButtons();
        // displayMenu();
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
