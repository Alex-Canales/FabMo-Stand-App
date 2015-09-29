package state;

import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;

class Final implements IState
{
    public var container:Element;
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

    public function new(surface:Surface, width:Float, height:Float)
    {
        container = Browser.document.getElementById("finalization");
        this.surface = surface;
        //NOTE: do not write any thing in new
        stand = new Stand(surface, width, height, BIT_WIDTH, THICKNESS);
    }

    public function create():Void
    {
        stand.createElements();
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
        trace(stand.getGCode(bitLength, feedrate));
        trace("Code generation");
    }

    private function createButtons():Void
    {
        container.appendChild(App.createButton("Customize", displayCustom));

        container.appendChild(App.createLabel("Feedrate:"));
        iptFeedrate = App.createInputText(cast FEEDRATE);
        container.appendChild(iptFeedrate);

        container.appendChild(App.createLabel("Board thickness:"));
        iptThickness = App.createInputText(cast THICKNESS);
        container.appendChild(iptThickness);

        container.appendChild(App.createLabel("Bit length:"));
        iptBitLength = App.createInputText(cast BIT_LENGTH);
        container.appendChild(iptBitLength);

        container.appendChild(App.createLabel("Bit width:"));
        iptBitWidth = App.createInputText(cast BIT_WIDTH);
        container.appendChild(iptBitWidth);

        container.appendChild(App.createButton("Set parameters", setParameters));
        container.appendChild(App.createButton("Generate", generateCode));
    }
}
