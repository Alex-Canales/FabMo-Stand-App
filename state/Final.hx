package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

class Final implements IState
{
    public var container:Element;
    public var explanationContainer:Element;
    public var surface:Surface;

    //Default values
    public static var FEEDRATE(default, null):Float = 120;
    public static var THICKNESS(default, null):Float = 1/4;
    public static var BIT_LENGTH(default, null):Float = 1;
    public static var BIT_WIDTH(default, null):Float = 1/4;

    private var stand:Stand;

    private var iptFeedrate:InputElement;
    private var iptBitWidth:InputElement;
    private var iptBitLength:InputElement;
    private var iptThickness:InputElement;
    private var iptPxToIn:InputElement;

    public function new(surface:Surface, width:Float, height:Float)
    {
        container = Browser.document.getElementById("finalization");
        container.style.display = "inline-block";

        this.surface = surface;
        stand = new Stand(surface, width, height, BIT_WIDTH, THICKNESS);

        iptPxToIn = cast Browser.document.getElementById("inToPx");
        iptPxToIn.value = Std.string(surface.inToPx);
        Browser.document.getElementById("changeInToPx").onclick = changeInToPx;

        explanationContainer = Browser.document.getElementById("explanations-final");
        explanationContainer.style.display = "block";
        var toggle:Element = Browser.document.getElementById("toggle-details-final");
        toggle.onclick = toggleDetails;
        //NOTE: do not put modification on the surface here
    }

    private function toggleDetails()
    {
        var elt:Element = Browser.document.getElementById("details-final");
        if(elt.style.display == "none" || elt.style.display == "")
            elt.style.display = "block";
        else
            elt.style.display = "none";
    }

    public function create():Void
    {
        stand.createElements();
        createButtons();
    }

    public function destroy():Void
    {
        container.style.display = "none";
        explanationContainer.style.display = "none";
        surface.removeAll();
    }

    private function changeInToPx():Void
    {
        surface.setInToPx(Std.int(App.checkFloat(iptPxToIn, 1)));
        setParameters();
    }

    private function displayCustom():Void
    {
        App.switchState(new Custom(surface, stand.width, stand.height));
    }

    private function setParameters():Void
    {
        var bitWidth:Float = App.checkFloat(iptBitWidth, 0);
        var thickness:Float = App.checkFloat(iptThickness, 0);
        App.checkFloat(iptBitLength, 0);
        App.checkFloat(iptFeedrate, 0);

        stand.setBitWidth(bitWidth);
        stand.setBoardThickness(thickness);
    }

    private function generateCode():Void
    {
        var bitLength:Float = App.checkFloat(iptBitLength);
        var feedrate:Float = App.checkFloat(iptFeedrate);
        var code:String = stand.getGCode(bitLength, feedrate);
        Job.submitJob(code, { filename : "stand.ngc" });
    }

    private function createButtons():Void
    {
        Browser.document.getElementById("go-customize").onclick = displayCustom;
        iptFeedrate = cast Browser.document.getElementById("feedrate");
        iptFeedrate.value = Std.string(FEEDRATE);
        iptThickness = cast Browser.document.getElementById("thickness");
        iptThickness .value = Std.string(THICKNESS);
        iptBitLength = cast Browser.document.getElementById("bitLength");
        iptBitLength .value = Std.string(BIT_LENGTH);
        iptBitWidth = cast Browser.document.getElementById("bitWidth");
        iptBitWidth .value = Std.string(BIT_WIDTH);

        Browser.document.getElementById("setParameters").onclick = setParameters;
        Browser.document.getElementById("generate").onclick = generateCode;
    }
}
