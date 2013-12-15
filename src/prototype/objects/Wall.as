package prototype.objects
{
    import main.Build;
    import main.Main;

    import starling.display.Image;

    public class Wall extends Image
    {
        public static const CODE:int = 0xffffff;

        public function Wall(terrainId:uint)
        {
            super(Main.testAtlas.getTexture("Area1Wall"));
            this.pivotY = this.height - Build.CELL_HEIGHT;

        }
    }
}
