package prototype.objects.items
{
    import main.Main;

    import prototype.entities.Player;

    public class ItemGold extends Item
    {
        public static const CODE:int = 0xffff00;

        public function ItemGold(terrainId:int)
        {
            super(Main.testAtlas.getTexture("K"));

        }


        override public function pickup(target:Player):void
        {
            super.pickup(target);

            target.gold += 1;
        }
    }
}
