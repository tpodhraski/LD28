package prototype
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;

    import prototype.objects.Wall;

    public class Level
    {
        [Embed(source="../../assets/Level/Floor.png")]
        private static const Floor:Class;
        [Embed(source="../../assets/Level/Objects.png")]
        private static const Objects:Class;

        public static const NONE:uint = 0x000000;

        private var _floor:BitmapData;
        private var _objects:BitmapData;

        public function Level()
        {
            _floor = Bitmap(new Floor()).bitmapData;
            _objects = Bitmap(new Objects()).bitmapData;
        }

        public function floorAt(x:int, y:int):uint
        {
            return _floor.getPixel(x, y);
        }

        public function objectAt(x:int, y:int):uint
        {
            return _objects.getPixel(x, y);
        }

        public function get width():int { return _floor.width; }
        public function get height():int { return _floor.height; }

    }
}
