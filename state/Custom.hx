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
        container = Browser.document.getElementById("custom");
        container.style.display = "inline-block";
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
        container.style.display = "none";
        surface.removeAll();
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
        Browser.document.getElementById("go-finalize").onclick = displayFinal;

        iptWidth = cast Browser.document.getElementById("width");
        iptHeight = cast Browser.document.getElementById("height");

        Browser.document.getElementById("setSize").onclick = setSize;
    }
}
