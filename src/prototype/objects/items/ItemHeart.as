package prototype.objects.items
{
    import main.Main;

    import prototype.entities.Player;

    public class ItemHeart extends Item
    {
        public static const CODE:int = 0xce2503;

        public function ItemHeart(terrainId:int)
        {
            super(Main.testAtlas.getTexture("Heart"));

        }


        override public function pickup(target:Player):void
        {
            super.pickup(target);

            target.health += 1;
        }
    }
}
