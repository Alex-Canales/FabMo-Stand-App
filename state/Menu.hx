package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

import element.Rectangle;

class Menu implements IState
{
    public var container:Element;
    public var surface:Surface;

    public function new(surface:Surface)
    {
        container = Browser.document.getElementById("menu");
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

    private function createButtons():Void
    {
        var btnCustom:Element = Browser.document.createElement("button");
        btnCustom.innerHTML = "Customize";
        btnCustom.onclick = displayCustom;
        container.appendChild(btnCustom);
    }
}
