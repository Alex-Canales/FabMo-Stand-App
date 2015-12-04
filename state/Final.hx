package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import stand.*;

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

    private var width:Float;
    private var height:Float;

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
        this.width = width;
        this.height = height;
        stand = new StandVertical(surface, width, height, BIT_WIDTH, THICKNESS);

        iptPxToIn = cast Browser.document.getElementById("inToPx");
        iptPxToIn.value = Std.string(surface.inToPx);
        iptPxToIn.onchange = changeInToPx;

        explanationContainer = Browser.document.getElementById("explanations-final");
        explanationContainer.style.display = "block";
        var toggle:Element = Browser.document.getElementById("toggle-details-final");
        toggle.onclick = toggleDetails;
        //NOTE: do not put modification on the surface here
    }

    public function create():Void
    {
        stand.createElements();
        setButtons();
    }

    private function toggleDetails()
    {
        var elt:Element = Browser.document.getElementById("details-final");
        if(elt.style.display == "none" || elt.style.display == "")
            elt.style.display = "block";
        else
            elt.style.display = "none";
    }

    public function destroy():Void
    {
        container.style.display = "none";
        explanationContainer.style.display = "none";
        surface.removeAll();
    }

    private function changeInToPx():Void
    {
        surface.inToPx = Std.int(App.checkFloat(iptPxToIn, 1));
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

        var codes:Array<String> = stand.getGCode(bitLength, feedrate);
        if(codes.length > 1)
        {
            Job.submitJob(codes[0], { filename : "stand-central.nc" });
            Job.submitJob(codes[1], { filename : "stand-support.nc" });
        }
        else
            Job.submitJob(codes[0], { filename : "stand.nc" });
    }

    private function setStandVertical():Void
    {
        stand = new StandVertical(surface, width, height,
                App.checkFloat(iptBitWidth), App.checkFloat(iptThickness));
        stand.createElements();
    }

    private function setStandHorizontal():Void
    {
        stand = new StandHorizontal(surface, width, height,
                App.checkFloat(iptBitWidth), App.checkFloat(iptThickness));
        stand.createElements();
    }

    private function setStandFiles():Void
    {
        stand = new StandFiles(surface, width, height,
                App.checkFloat(iptBitWidth), App.checkFloat(iptThickness));
        stand.createElements();
    }

    private function setButtons():Void
    {
        Browser.document.getElementById("go-customize").onclick = displayCustom;
        iptFeedrate = cast Browser.document.getElementById("feedrate");
        iptFeedrate.value = Std.string(FEEDRATE);
        iptFeedrate.onchange = setParameters;
        iptThickness = cast Browser.document.getElementById("thickness");
        iptThickness.value = Std.string(THICKNESS);
        iptThickness.onchange = setParameters;
        iptBitLength = cast Browser.document.getElementById("bitLength");
        iptBitLength.value = Std.string(BIT_LENGTH);
        iptBitLength.onchange = setParameters;
        iptBitWidth = cast Browser.document.getElementById("bitWidth");
        iptBitWidth.value = Std.string(BIT_WIDTH);
        iptBitWidth.onchange = setParameters;

        var iptVertical:InputElement;
        iptVertical = cast Browser.document.getElementById("vertical");
        iptVertical.onchange = setStandVertical;
        iptVertical.checked = true;
        Browser.document.getElementById("horizontal").onchange = setStandHorizontal;
        Browser.document.getElementById("twoFiles").onchange = setStandFiles;

        Browser.document.getElementById("generate").onclick = generateCode;
    }
}
