package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

class Custom implements IState
{
    public var container:Element;
    // public var sampleContainer:Element;
    public var explanationContainer:Element;
    public var surface:Surface;
    private var iptPxToIn:InputElement;

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
        // sampleContainer = Browser.document.getElementById("samples");
        // sampleContainer .style.display = "block";

        this.surface = surface;
        setWidth(widthInInch);
        setHeight(heightInInch);

        iptPxToIn = cast Browser.document.getElementById("inToPx");
        iptPxToIn.value = Std.string(surface.inToPx);
        iptPxToIn.onchange = changeInToPx;

        explanationContainer = Browser.document.getElementById("explanations-custom");
        explanationContainer.style.display = "block";
        var toggle:Element = Browser.document.getElementById("toggle-details-custom");
        toggle.onclick = toggleDetails;
        //NOTE: do not put modification on the surface here
    }

    private function toggleDetails()
    {
        var elt:Element = Browser.document.getElementById("details-custom");
        if(elt.style.display == "none" || elt.style.display == "")
            elt.style.display = "block";
        else
            elt.style.display = "none";
    }

    public function create():Void
    {
        setHTMLElements();

        var wR:Float = width * surface.inToPx;
        var hR:Float = height * surface.inToPx;
        var x:Float = 5;
        var y:Float = surface.canvas.height - hR - 5;
        rectangle = new element.Rectangle(x, y, wR, hR);
        surface.add(rectangle);
    }

    private function changeInToPx():Void
    {
        surface.inToPx = Std.int(App.checkFloat(iptPxToIn, 1));
        setSize();
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
        // sampleContainer.style.display = "none";
        explanationContainer.style.display = "none";
        surface.removeAll();
    }

    private function setSizeSample(width:Float, height:Float):Void
    {
        iptWidth.value = Std.string(width);
        iptHeight.value = Std.string(height);
        setSize();
    }

    private function setIPhone():Void
    {
        setSizeSample(3, 6);
    }

    private function setMusicStand():Void
    {
        setSizeSample(18, 16);
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

    private function setHTMLElements():Void
    {
        Browser.document.getElementById("go-finalize").onclick = displayFinal;

        iptWidth = cast Browser.document.getElementById("width");
        iptWidth.value = Std.string(width);
        iptWidth.onchange = setSize;
        iptHeight = cast Browser.document.getElementById("height");
        iptHeight.value = Std.string(height);
        iptHeight.onchange = setSize;

        Browser.document.getElementById("iPhone").onclick = setIPhone;
        Browser.document.getElementById("music-stand").onclick = setMusicStand;
    }
}
