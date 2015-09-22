package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

class Final implements IState
{
    public var container:Element;
    public var surface:Surface;

    private var iptFeedrate:InputElement;
    private var iptBitWidth:InputElement;
    private var iptThickness:InputElement;

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

    private function generateStand(width:Float, height:Float):Void
    {
    }

    private function createButtons():Void
    {
        container.appendChild(App.createButton("Customize", displayCustom));
    }
}
