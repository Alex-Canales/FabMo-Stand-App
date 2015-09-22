package element;

import js.html.CanvasRenderingContext2D;

interface IElement
{
    public var x:Float;
    public var y:Float;
    public var draggable:Bool;
    public var callback:Dynamic;  //callback function

    //  Draw the element in the given context
    public function draw(context:CanvasRenderingContext2D):Void;
}
