package state;

import js.html.Element;

interface IState
{
    public var container:Element;
    public var surface:Surface;

    public function create():Void;
    public function destroy():Void;
}
