package prototype
{
    import Core.Geometry;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import main.Build;

    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.extensions.QuadtreeSprite;

    public class FogOfWar extends QuadtreeSprite
    {
        private var _level:Level;

        private var _cells:Array;

        public function FogOfWar(level:Level)
        {
            super(new Rectangle(0, 0, level.width * Build.CELL_WIDTH, level.height * Build.CELL_HEIGHT));

            _level = level;

            _cells = [];
            _cells.length = _level.width * _level.height;

            for (var j:int = 0; j < _level.height; j++)
            {
                for (var i:int = 0; i < _level.width; i++)
                {
                    var index:int = j * _level.width + i;
                    var quad:Quad = new Quad(Build.CELL_WIDTH, Build.CELL_HEIGHT, 0x000000);
                    quad.x = i * Build.CELL_WIDTH;
                    quad.y = j * Build.CELL_HEIGHT;
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
