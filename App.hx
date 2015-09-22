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
    public static function checkFloat(element:InputElement):Float
    {
        var number:Float = Std.parseFloat(element.value);

        if(!Math.isFinite(number))
            number = 0;
        element.value = cast number;

        return number;
    }

    private function displayUI(id:String):Void
    {
        var ids:Array<String> = ["menu", "custom", "finalization"];
        for(i in ids) {
            document.getElementById(i).style.display = "none";
        }
        document.getElementById(id).style.display = "block";
    }

    private function displayMenu():Void
    {
        displayUI("menu");
        // Stand.elements = [];
        // Stand.createTextElement(10, 10, false, undefined, "text");
        // // var customize = { type : "text", x : 10, y : 10, text : "Customize",
        // //     callback : Stand.displayCustom };
        // // Stand.elements.push(customize);
        // Stand.drawCanvas();
    }

    private function displayCustom():Void
    {
        displayUI("custom");
    }

    private function displayFinalization(width:Float, height:Float,
            holes:Array<Hole>):Void
    {
        displayUI("finalization");
        stand.width = width;
        stand.height = height;
        stand.holes = holes;
    }

    private function setButtons():Void
    {
        document.getElementById("go-custom").onclick = displayCustom;
        document.getElementById("go-finalize").onclick = displayFinalization;
        document.getElementById("back-custom").onclick = displayCustom;
        document.getElementById("back-menu").onclick = displayMenu;
        document.getElementById("back-menu2").onclick = displayMenu;
        // document.getElementById("make-file").onclick = makeFile;
    }
}
