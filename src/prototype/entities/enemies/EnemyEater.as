package prototype.entities.enemies
{
    import main.Build;
    import main.Main;

    import starling.core.Starling;

    import starling.display.MovieClip;

    import starling.textures.TextureSmoothing;

    public class EnemyEater extends Enemy
    {
        public static const CODE:int = 0xfe9c00;

        public function EnemyEater(terrain:int)
        {
            var mc:MovieClip = new MovieClip(Main.testAtlas.getTextures("mon"), 24);
            mc.smoothing = TextureSmoothing.NONE;
            mc.scaleX = mc.scaleY = 0.75;
            mc.x += Math.floor((32 - 32 * mc.scaleX) / 2);
            this.addChild(mc);
            Starling.juggler.add(mc);


            this.pivotY = this.height - Build.CELL_HEIGHT;


            this.damage = 1;
            this.health = 2;
            this.walk = 1;
            this.walkRecharge = 0;

        }
    }
}
