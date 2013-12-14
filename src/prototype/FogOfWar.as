package prototype
{
    import Core.Geometry;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.extensions.QuadtreeSprite;

    public class FogOfWar extends QuadtreeSprite
    {
        private var _level:Level;

        private var _cells:Array;

        public function FogOfWar(level:Level)
        {
            super(new Rectangle(0, 0, level.width * 32, level.height * 32));

            _level = level;

            _cells = [];
            _cells.length = _level.width * _level.height;

            for (var j:int = 0; j < _level.height; j++)
            {
                for (var i:int = 0; i < _level.width; i++)
                {
                    var index:int = j * _level.width + i;
                    var quad:Quad = new Quad(32, 32, 0x000000);
                    quad.x = i * 32;
                    quad.y = j * 32;
                    this.addChild(quad);
                    _cells[index] = quad;
                }
            }
        }

        public function reveal(x:int, y:int, cellsBounds:int):void
        {
            var b2:Number = cellsBounds * cellsBounds;
            var center:Point = new Point(x,y);

            var minX:int = Math.max(0, x - cellsBounds);
            var minY:int = Math.max(0, y - cellsBounds);

            var maxX:int = Math.min(_level.width - 1, x + cellsBounds);
            var maxY:int = Math.min(_level.width - 1, y + cellsBounds);

            for (var j:int = minY; j <= maxY; j++)
            {
                for (var i:int = minX; i < maxX; i++)
                {
                    if (Geometry.distanceSquared(center, new Point(i, j)) < b2)
                    {
                        var index:int = j * _level.width + i;
                        _cells[index].visible = false;
                    }
                }
            }

        }
    }
}
