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

    private var width:Float;    //Store width in inches
    private var height:Float;   //Store width in inches

    private static var MIN_WIDTH(default, null):Float = 3;
    private static var MIN_HEIGHT(default, null):Float = 3;

    public function new(surface:Surface, widthInInch:Float=0, heightInInch:Float=0)
    {
        trace("Final custom.");
        container = Browser.document.getElementById("finalization");
        this.surface = surface;
        setWidth(widthInInch);
        setHeight(heightInInch);
        //NOTE: do not write any thing in new
    }

    public function create():Void
    {
        createButtons();

        var wR:Float = width * surface.inToPx;
        var hR:Float = height * surface.inToPx;
        rectangle = new element.Rectangle(5, 5, false, null, wR, hR);
        surface.add(rectangle);
    }

    private function setWidth(widthInInch):Void
    {
        width = Math.max(MIN_WIDTH, widthInInch);
        // width = widthInInch * surface.inToPx;
    }

    private function setHeight(heightInInch):Void
    {
        height = Math.max(MIN_WIDTH, heightInInch);
        // height = heightInInch * surface.inToPx;
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

    private function displayFinal():Void
    {
        App.switchState(new Final(surface, width, height));
    }

    private function setSize():Void
    {
        setWidth(App.checkFloat(iptWidth, MIN_WIDTH));
        setHeight(App.checkFloat(iptHeight, MIN_WIDTH));

        rectangle.width = width * surface.inToPx;
        rectangle.height = height * surface.inToPx;
        surface.draw();
    }

    private function createButtons():Void
    {
        var btnMenu:Element = Browser.document.createElement("button");
        btnMenu.innerHTML = "Menu";
        btnMenu.onclick = displayMenu;
        container.appendChild(btnMenu);

        var btnFinal:Element = Browser.document.createElement("button");
        btnFinal.innerHTML = "Next";
        btnFinal.onclick = displayFinal;
        container.appendChild(btnFinal);

        var lblWidth:Element = cast Browser.document.createElement("label");
        lblWidth.innerHTML = "Width:";
        container.appendChild(lblWidth);

        iptWidth = cast Browser.document.createElement("input");
        iptWidth.type = "text";
        iptWidth.value = cast width;
        container.appendChild(iptWidth);

        var lblHeight:Element = cast Browser.document.createElement("label");
        lblHeight.innerHTML = "Height:";
        container.appendChild(lblHeight);

        iptHeight = cast Browser.document.createElement("input");
        iptHeight.type = "text";
        iptHeight.value = cast height;
        container.appendChild(iptHeight);

        var btnSet:Element = Browser.document.createElement("button");
        btnSet.innerHTML = "Set size";
        btnSet.onclick = setSize;
        container.appendChild(btnSet);
    }
}
