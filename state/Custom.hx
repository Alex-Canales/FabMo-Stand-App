package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

class Custom implements IState
{
    public var container:Element;
    public var surface:Surface;

    private var rectangle:element.Rectangle;

    private var iptWidth:InputElement;
    private var iptHeight:InputElement;

    public function new(surface:Surface)
    {
        trace("Final custom.");
        container = Browser.document.getElementById("finalization");
        this.surface = surface;
        //NOTE: do not write any thing in new
    }
    public function create():Void
    {
        createButtons();

        var width:Float = 3 * surface.inToPx;
        var height:Float = 3 * surface.inToPx;
        rectangle = new element.Rectangle(5, 5, false, null, width, height);
        surface.add(rectangle);
    }

    public function destroy():Void
    {
        container.innerHTML = "";
        surface.removeAll();
    }

    private function displayMenu():Void
    {
        App.switchState(new Menu(surface));
    }

    private function setSize():Void
    {
        var width:Float = App.checkFloat(iptWidth) * surface.inToPx;
        var height:Float = App.checkFloat(iptHeight) * surface.inToPx;
        trace('$width x $height');
    }

    private function createButtons():Void
    {
        var btnMenu:Element = Browser.document.createElement("button");
        btnMenu.innerHTML = "Menu";
        btnMenu.onclick = displayMenu;
        container.appendChild(btnMenu);

        var lblWidth:Element = cast Browser.document.createElement("label");
        lblWidth.innerHTML = "Width:";
        container.appendChild(lblWidth);

        iptWidth = cast Browser.document.createElement("input");
        iptWidth.type = "text";
        container.appendChild(iptWidth);

        var lblHeight:Element = cast Browser.document.createElement("label");
        lblHeight.innerHTML = "Height:";
        container.appendChild(lblHeight);

        iptHeight = cast Browser.document.createElement("input");
        iptHeight.type = "text";
        container.appendChild(iptHeight);

        var btnSet:Element = Browser.document.createElement("button");
        btnSet.innerHTML = "Set size";
        btnSet.onclick = setSize;
        container.appendChild(btnSet);
    }
}
