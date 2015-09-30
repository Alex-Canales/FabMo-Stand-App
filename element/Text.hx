package element;

import js.html.CanvasRenderingContext2D

class Text implements IElement
{
    public var x:Float;
    public var y:Float;
    public var draggable:Bool;
    public var callback:Dynamic;  //callback function
    public var text:String;

    public function new(x, y, draggable, callback, text)
    {
        this.x = x;
        this.y = y;
        this.draggable = draggable;
        this.callback = callback;
        this.text = text;
    }

    public function draw(context:CanvasRenderingContext2D):Void
    {
        context.fillText(text, x, y);
        context.restore();
    }
}
