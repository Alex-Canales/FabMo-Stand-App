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
        var x:Float = 5;
        var y:Float = surface.canvas.height - hR - 5;
        rectangle = new element.Rectangle(x, y, false, null, wR, hR);
        surface.add(rectangle);
    }

    private function setWidth(widthInInch):Void
    {
        width = Math.max(MIN_WIDTH, widthInInch);
    }

    private function setHeight(heightInInch):Void
    {
        height = Math.max(MIN_WIDTH, heightInInch);
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
        rectangle.y = surface.canvas.height - rectangle.height - 5;
        surface.draw();
    }

    private function createButtons():Void
    {
        container.appendChild(App.createButton("Menu", displayMenu));
        container.appendChild(App.createButton("Next", displayFinal));
        container.appendChild(App.createLabel("Width:"));

        iptWidth = App.createInputText(cast width);
        container.appendChild(iptWidth);

        container.appendChild(App.createLabel("Height:"));

        iptHeight = App.createInputText(cast height);
        container.appendChild(iptHeight);

        container.appendChild(App.createButton("Set size", setSize));
    }
}
