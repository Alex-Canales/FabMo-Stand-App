package state;

import js.html.Element;

class Final implements IState
{
    public var container:Element;
    public var surface:Surface;

    //TODO; define stand here

    public function new(surface:Surface, width:Float, height:Float)
    {
        trace("Final state.");
        container = Browser.document.getElementById("finalization");
        this.surface = surface;
        //NOTE: do not write any thing in new
    }

    public function create():Void
    {
        createButtons();
    }

    public function destroy():Void
    {
        container.innerHTML = "";
        surface.removeAll();
    }

    private function displayCustom():Void
    {
        App.switchState(new Custom(surface));
    }

    private function displayMenu():Void
    {
        App.switchState(new Menu(surface));
    }

    private function createButtons():Void
    {
        var btnCustom:Element = Browser.document.createElement("button");
        btnCustom.innerHTML = "Customize";
        btnCustom.onclick = displayCustom;
        container.appendChild(btnCustom);
    }

    private function generateStand(width:Float, height:Float):Void
    {
    }
}
