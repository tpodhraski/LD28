package prototype.objects
{
    import main.Main;

    import starling.display.Image;

    public class Wall extends Image
    {
        public static const CODE:int = 0xffffff;

        public function Wall(terrainId:uint)
        {
            super(Main.testAtlas.getTexture("2"));

        }
    }
}
