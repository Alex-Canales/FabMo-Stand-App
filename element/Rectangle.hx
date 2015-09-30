package element;

import js.html.CanvasRenderingContext2D;

class Rectangle implements IElement
{
    public var x:Float;
    public var y:Float;
    public var draggable:Bool;
    public var callback:Dynamic;  //callback function
    public var width:Float;
    public var height:Float;
    public var lineWidth:Int;
    public var lineColor:Dynamic;
    public var fillColor:Dynamic;

    public function new(x:Float, y:Float, draggable:Bool, callback:Dynamic,
            width:Float, height:Float, lineWidth:Int=1,
            lineColor:Dynamic="black", ?fillColor:Dynamic)
    {
        this.x = x;
        this.y = y;
        this.draggable = draggable;
        this.callback = callback;
        this.width = width;
        this.height = height;
        this.fillColor = fillColor;
        this.lineWidth = lineWidth;
        this.lineColor = lineColor;
    }

    public function draw(context:CanvasRenderingContext2D):Void
    {
        context.beginPath();
        context.rect(x, y, width, height);
        if(fillColor !=  null)
        {
            context.fillStyle = fillColor;
            context.fill();
        }
        context.lineWidth = lineWidth;
        context.strokeStyle = lineColor;
        context.stroke();
    }
}
