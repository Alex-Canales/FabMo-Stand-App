package element;

import js.html.CanvasRenderingContext2D;

class Dogbone implements IElement
{
    public var x:Float;
    public var y:Float;
    public var draggable:Bool;
    public var callback:Dynamic;  //callback function
    public var width:Float;
    public var height:Float;
    public var radius:Float;


    public function new(x:Float, y:Float, draggable:Bool, callback:Dynamic,
            width:Float, height:Float, radius:Float)
    {
        this.x = x;
        this.y = y;
        this.draggable = draggable;
        this.callback = callback;
        this.width = width;
        this.height = height;
        this.radius = radius;
    }

    public function draw(context:CanvasRenderingContext2D):Void
    {
        var xLeftBone:Float = x + radius;
        var xRightBone:Float = x + width - radius;
        var yTopBone:Float = y;
        var yBottomBone:Float = y + height;

        trace("Drawing dogbone");
        context.beginPath();

        //Rectangle hole
        context.rect(x, y, width, height);
        context.fillStyle = "0x000000";
        context.fill();
        context.lineWidth = 1;
        context.strokeStyle = "0x000000";
        context.stroke();

        //Draw shape top left
        context.arc(xLeftBone, yTopBone, radius, Math.PI, 2 * Math.PI, false);
        context.fillStyle = "0x000000";
        context.fill();
        context.stroke();

        //Draw shape bottom left
        context.arc(xLeftBone, yTopBone, radius, 0, Math.PI, false);
        context.fillStyle = "0x000000";
        context.fill();
        context.stroke();

        //Draw top right
        context.arc(xRightBone, yTopBone, radius, Math.PI, 2 * Math.PI, false);
        context.fillStyle = "0x000000";
        context.fill();
        context.stroke();

        //Draw bottom right
        context.arc(xRightBone, yTopBone, radius, 0, Math.PI, false);
        context.fillStyle = "0x000000";
        context.fill();
        context.stroke();
    }
}
