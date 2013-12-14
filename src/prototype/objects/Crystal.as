package prototype.objects
{
    import main.Main;

    import starling.display.Image;

    public class Crystal extends Image
    {
        public static const CODE:int = 0x25f5ae;

        private var _charged:Boolean = false;

        public function Crystal(terrainId:int)
        {
            super(Main.testAtlas.getTexture("Crystal"));
        }


        public function get charged():Boolean
        {
            return _charged;
        }

        public function charge():void
        {
            _charged = true;
            this.texture = Main.testAtlas.getTexture("CrystalLight");
        }
    }
}
